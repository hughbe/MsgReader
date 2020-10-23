//
//  NamedPropertyMapping.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import CompoundFileReader
import DataStream
import Foundation
import MAPI

/// [MS-OXMSG] 2.2.3.1 Property ID to Property Name Mapping
/// The streams specified in the following sections MUST be present inside the named property mapping storage.
internal struct NamedPropertyMapping: CustomDebugStringConvertible {
    public let dictionary: [NamedProperty: UInt16]
    public let properties: [UInt16: NamedProperty]
    
    public init(storage: CompoundFileStorage) throws {
        var storage = storage

        /// [MS-OXMSG] 2.2.3.1.1 GUID Stream
        /// The GUID stream MUST be named "__substg1.0_00020102". It MUST store the property set GUID part of the property name
        /// of all named properties in the Message object or any of its subobjects, except for those named properties that have
        /// PS_MAPI or PS_PUBLIC_STRINGS, as described in [MSOXPROPS] section 1.3.2, as their property set GUID.
        /// The GUIDs are stored in the stream consecutively like an array. If there are multiple named properties
        /// that have the same property set GUID, then the GUID is stored only once and all the named
        /// properties will refer to it by its index.
        guard let guidStream = storage.children["__substg1.0_00020102"] else {
            throw MsgReadError.missingStream(name: "__substg1.0_00020102")
        }
        
        var guidDataStream = guidStream.dataStream
        func getGuid(index: Int) throws -> UUID {
            let position = index * MemoryLayout<UUID>.size
            if position >= guidDataStream.count {
                throw MsgReadError.corrupted
            }

            guidDataStream.position = position
            return try guidDataStream.readGUID(endianess: .littleEndian)
        }
        
        /// [MS-OXMSG] 2.2.3.1.3 String Stream
        /// The string stream MUST be named "__substg1.0_00040102". It MUST consist of one entry for each
        /// string named property, and all entries MUST be arranged consecutively, like in an array.
        /// As specified in section 2.2.3.1.2, the offset, in bytes, to use for a particular property is stored in the
        /// corresponding entry in the entry stream. That is a byte offset into the string stream from where the
        /// entry for the property can be read. The strings MUST NOT be null-terminated. Implementers can add a
        /// terminating null character to the string after they read it from the stream, if one is required by the
        /// implementer's programming language.
        guard let stringStream = storage.children["__substg1.0_00040102"] else {
            throw MsgReadError.missingStream(name: "__substg1.0_00040102")
        }

        var stringDataStream = stringStream.dataStream
        func getString(offset: Int) throws -> String {
            stringDataStream.position = offset
            
            /// Name Length (4 bytes): The length of the following Name field in bytes.
            let nameLengthInBytes = try stringDataStream.read(endianess: .littleEndian) as UInt32
            
            /// Name (variable): A Unicode string that is the name of the property. A new entry MUST always start
            /// on a 4 byte boundary; therefore, if the size of the Name field is not an exact multiple of 4, and
            /// another Name field entry occurs after it, null characters MUST be appended to the stream after it
            /// until the 4-byte boundary is reached. The Name Length field for the next entry will then start at
            /// the beginning of the next 4-byte boundary.
            guard let name = try stringDataStream.readString(count: Int(nameLengthInBytes), encoding: .utf16LittleEndian) else {
                return ""
            }
            
            return name
        }
        
        /// [MS-OXMSG] 2.2.3.1.2 Entry Stream
        /// The entry stream MUST be named "__substg1.0_00030102" and consist of 8-byte entries, one for
        /// each named property being stored. The properties are assigned unique numeric IDs (distinct from
        /// any property ID assignment) starting from a base of 0x8000. The IDs MUST be numbered
        /// consecutively, like an array. In this stream, there MUST be exactly one entry for each named property
        /// of the Message object or any of its subobjects. The index of the entry for a particular ID is calculated
        /// by subtracting 0x8000 from it. For example, if the ID is 0x8005, the index for the corresponding 8-
        /// byte entry would be 0x8005 – 0x8000 = 5. The index can then be multiplied by 8 to get the actual
        /// byte offset into the stream from where to start reading the corresponding storage.
        /// Each of the 8-byte entries has the following format:
        guard let entryStream = storage.children["__substg1.0_00030102"] else {
            throw MsgReadError.missingStream(name: "__substg1.0_00030102")
        }

        var entryDataStream = entryStream.dataStream
        let entriesCount = entryDataStream.count / 8
        var dictionary = [NamedProperty: UInt16]()
        var properties = [UInt16: NamedProperty]()
        dictionary.reserveCapacity(entriesCount)
        properties.reserveCapacity(entriesCount)
        for _ in 0..<entriesCount {
            /// Name Identifier/String Offset (4 bytes): If this property is a numerical named property (as
            /// specified by the Property Kind subfield of the Index and Kind Information field), this value is
            /// the LID part of the PropertyName structure, as specified in [MS-OXCDATA] section 2.6.1. If this
            /// property is a string named property, this value is the offset in bytes into the strings stream
            /// where the value of the Name field of the PropertyName structure is located.
            let nameIdentifierOrStringOffset = try entryDataStream.read(endianess: .littleEndian) as UInt32
            
            /// Index and Kind Information (4 bytes): This value MUST have the structure specified in section 2.2.3.1.2.1.
            let indexAndKindInformation = try NamedPropertyIndexAndKindInformation(dataStream: &entryDataStream)

            let guid: UUID
            switch indexAndKindInformation.guidIndex {
            case 1:
                /// Always use the PS_MAPI property set, as specified in [MS-OXPROPS] section 1.3.2. No GUID is stored in the GUID stream.
                guid = CommonlyUsedPropertySet.mapi.uuid
            case 2:
                /// Always use the PS_PUBLIC_STRINGS property set, as specified in [MS-OXPROPS] section 1.3.2. No GUID is stored in the GUID stream.
                guid = CommonlyUsedPropertySet.publicStrings.uuid
            default:
                /// Use Value minus 3 as the index of the GUID into the GUID stream. For example, if the GUID index is 5,
                /// the third GUID (5 minus 3, resulting in a zero-based index of 2) is used as the GUID for the name
                /// property being derived.
                let index = indexAndKindInformation.guidIndex >= 3 ? indexAndKindInformation.guidIndex - 3 : indexAndKindInformation.guidIndex
                guid = try getGuid(index: Int(index))
            }

            let property: NamedProperty
            switch indexAndKindInformation.propertyKind {
            case .stringNamed:
                let name = try getString(offset: Int(nameIdentifierOrStringOffset))
                property = NamedProperty(guid: guid, name: name)
            case .numericalNamed:
                property = NamedProperty(guid: guid, lid: nameIdentifierOrStringOffset)
            }
            
            dictionary[property] = indexAndKindInformation.propertyIndex
            properties[indexAndKindInformation.propertyIndex] = property
        }
        
        self.dictionary = dictionary
        self.properties = properties
    }
    
    public var debugDescription: String {
        var s = ""

        for kvp in dictionary {
            s += "___\n"
            s += "Id: \(kvp.value.hexString)\n"
            s += "Guid: \(kvp.key.guid)\n"
            switch kvp.key.kind {
            case .numericalNamed:
                s += "LID: \(kvp.key.lid!.hexString)\n"
            case .stringNamed:
                s += "Name: \(kvp.key.name!)\n"
            }
        }
        
        return s
    }
    
    /// [MS-OXMSG] 2.2.3.1.2.1 Index and Kind Information
    /// The following structure specifies the stream indexes and whether the property is a numerical named property or a string named property.
    internal struct NamedPropertyIndexAndKindInformation {
        public var guidIndex: UInt16
        public var propertyKind: NamedProperty.Kind
        public var propertyIndex: UInt16

        public init(dataStream: inout DataStream) throws {
            // GUID Index (15 bits): Index into the GUID stream. The possible values are shown in the following table.
            // Value | GUID to use
            // ------|------------
            // 1     | Always use the PS_MAPI property set, as specified in [MS-OXPROPS] section 1.3.2. No GUID is stored in the GUID stream.
            // 2     | Always use the PS_PUBLIC_STRINGS property set, as specified in [MS-OXPROPS] section 1.3.2. No GUID is stored in the GUID stream.
            // >= 3  | Use Value minus 3 as the index of the GUID into the GUID stream. For example, if the GUID index is 5, the third GUID (5 minus 3, resulting in a zero-based index of 2) is used as the GUID for the name property being derived.
            // Property Kind (1 bit): Bit indicating the type of the property; zero (0) if numerical named property
            // and 1 if string named property.
            let indexAndPropertyKindInformation = try dataStream.read(endianess: .littleEndian) as UInt16
            
            guidIndex = (indexAndPropertyKindInformation >> 1) & 0b111111111111111

            let propertyType = indexAndPropertyKindInformation & 0b1
            propertyKind = propertyType == 1 ? .stringNamed : .numericalNamed
            
            /// Property Index (2 bytes): Sequentially increasing, zero-based index. This MUST be 0 for the first
            /// named property, 1 for the second, and so on.
            propertyIndex = try dataStream.read(endianess: .littleEndian)
        }
    }
}
