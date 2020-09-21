//
//  PropertyStream.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import CompoundFileReader
import DataStream
import Foundation
import MAPI
import WindowsDataTypes

/// [MS-OXMSG] 2.4 Property Stream
/// The property stream MUST have the name "__properties_version1.0" and MUST consist of a header followed by an array of 16-byte entries.
/// With the exception of Named Property Mapping storage, which is specified in section 2.2.3, every storage type specified by the .msg File Format MUST have a
/// property stream in it.
/// Every property of an object MUST have an entry in the property stream for that object. Fixed length properties also have their values stored as a part of the entry,
/// whereas the values of variable length properties and multiple-valued properties are stored in separate streams.
internal class PropertyStream<T>: CustomDebugStringConvertible where T: PropertiesHeader {
    private var parent: CompoundFileStorage
    private let header: T
    internal var values = [UInt16: PropertyEntry]()

    public init(parent: CompoundFileStorage) throws {
        var parent = parent
        guard let propertiesEntry = parent.children["__properties_version1.0"] else {
            throw OutlookMessageError.missingStream(name: "__properties_version1.0")
        }
    
        self.parent = parent
        
        var dataStream = propertiesEntry.dataStream

        // [MS-OXMSG] 2.4.1 Header
        // The header of the property stream differs depending on which storage this property stream belongs to.
        self.header = try T(dataStream: &dataStream)
        
        // [MS-OXMSG] 2.4.2 Data
        // The data inside the property stream MUST be an array of 16-byte entries. The number of properties,
        // each represented by one entry, can be determined by first measuring the size of the property stream,
        // then subtracting the size of the header from it, and then dividing the result by the size of one entry.
        // The structure of each entry, representing one property, depends on whether the property is a fixed
        // length property or not.
        let numberOfStreams = dataStream.remainingCount / 16
        for _ in 0..<numberOfStreams {
            let value = try PropertyEntry(dataStream: &dataStream)
            self.values[value.propertyTag.id] = value
        }
    }
    
    public func getValue(id: UInt16) -> Any? {
        guard let value = values[id] else {
            return nil
        }
        
        let type = value.propertyTag.type
        func reinterpret_cast<T>(to: T.Type) -> T {
            var data = value.value
            return withUnsafePointer(to: &data) {
                $0.withMemoryRebound(to: to, capacity: 1) {
                    $0.pointee
                }
            }
        }
        
        // [MS-OXMSG] 2.1.3 Variable Length Properties
        // A variable length property, within the context of this document, is defined as one where each instance
        // of the property can have a value of a different size. Such properties are specified along with their
        // lengths or have alternate mechanisms (such as terminating null characters) for determining their size.
        // Following is an exhaustive list of property types that are either variable length or stored in a stream
        // like variable length property types. These property types are specified in [MS-OXCDATA] section 2.11.1.
        //  PtypString
        //  PtypBinary
        //  PtypString8
        //  PtypGuid
        //  PtypObject
        // Each variable length property has an entry in the property stream. However, the entry contains only
        // the property tag, a flag providing more information about the property, the size, and a reserved
        // field. The entry does not contain the variable length property's value. Since the value can be variable
        // in length, it is stored in an individual stream by itself. Properties of type PtypGuid do not have
        // variable length values (they are always 16 bytes long). However, like variable length properties, they
        // are stored in a stream by themselves in the .msg file because the values have a large size. Therefore,
        // they are grouped along with variable length properties.
        // The name of the stream where the value of a particular variable length property is stored is
        // determined by its property tag. The stream name is created by prefixing a string containing the
        // hexadecimal representation of the property tag with the string "__substg1.0_". For example, if the
        // property is PidTagSubject ([MS-OXPROPS] section 2.1027), the name of the stream is
        // "__substg1.0_0037001F", where "0037001F" is the hexadecimal representation of the property tag for
        // PidTagSubject.
        // If the PidTagStoreSupportMask property (section 2.1.1.1) is present and has the
        // STORE_UNICODE_OK (bitmask 0x00040000) flag set, all string properties in the .msg file MUST be
        // present in Unicode format. If the PidTagStoreSupportMask is not available in the property stream
        // or if the STORE_UNICODE_OK flag is not set, the .msg file is considered to be non-Unicode and all
        // string properties in the file MUST be in non-Unicode format.
        // All string properties for a Message object MUST be either Unicode or non-Unicode. The .msg File
        // Format does not allow the presence of both simultaneously.
        func getStorageName(id: UInt16, type: PropertyType) -> String {
            let idHex = (String(id, radix: 16, uppercase: true).padLeft(toLength: 4, withPad: "0"))
            let dataTypeHex = (String(type.rawValue, radix: 16, uppercase: true).padLeft(toLength: 4, withPad: "0"))
            return "__substg1.0_\(idHex)\(dataTypeHex)"
        }
        
        func getData(id: UInt16, type: PropertyType) -> Data? {
            let storageName = getStorageName(id: id, type: type)
            guard let entry = parent.children[storageName] else {
                print("Could not find entry \(storageName)")
                return nil
            }
            
            return entry.data
        }
        
        /// [MS-OXMSG] 2.1.4.1 Fixed Length Multiple-Valued Properties
        /// A fixed length multiple-valued property, within the context of this document, is defined as a property
        /// that can have multiple values, where each value is of the same fixed length type. The following table
        /// is an exhaustive list of fixed length multiple-valued property types and the corresponding value
        /// types. All of the property types and value types in the following table are specified in [MS-OXCDATA]
        /// section 2.11.1.
        /// Property type Value type
        /// PtypMultipleInteger16 PtypInteger16
        /// PtypMultipleInteger32 PtypInteger32
        /// PtypMultipleFloating32 PtypFloating32
        /// PtypMultipleFloating64 PtypFloating64
        /// PtypMultipleCurrency PtypCurrency
        /// PtypMultipleFloatingTime PtypFloatingTime
        /// PtypMultipleTime PtypTime
        /// PtypMultipleGuid PtypGuid
        /// PtypMultipleInteger64 PtypInteger64
        /// The array of values of a fixed length multiple-valued property is stored in one stream. The name of
        /// that stream is determined by the property's property tag. The stream name is created by prefixing a
        /// string containing the hexadecimal representation of the property tag with the string "__substg1.0_".
        /// For example, if the property is PidTagScheduleInfoMonthsBusy ([MS-OXPROPS] section 2.976),
        /// the name of the stream is "__substg1.0_68531003", where "68531003" is the hexadecimal
        /// representation of the property tag for PidTagScheduleInfoMonthsBusy.
        /// The values associated with the fixed length multiple-valued property are stored in the stream
        /// contiguously like an array.
        func readFixedLengthMultiValuedProperty<T>(readFunc: (inout DataStream) throws -> T) throws -> [T]? {
            guard let data = getData(id: id, type: type) else {
                return nil
            }

            var dataStream = DataStream(data: data)
            let count = dataStream.count / MemoryLayout<T>.size
            var elements: [T] = []
            elements.reserveCapacity(count)
            for _ in 0..<count {
                let element = try readFunc(&dataStream)
                elements.append(element)
            }
            
            return elements
        }
        
        /// [MS-OXMSG] 2.1.4.2 Variable Length Multiple-Valued Properties
        /// A variable length multiple-valued property, within the context of this document, is defined as a
        /// property that can have multiple values, where each value is of the same type but can have different
        /// lengths. The following table is an exhaustive list of variable length multiple-valued property types
        /// and the corresponding value types. All of the property types and value types in the following table are
        /// specified in [MS-OXCDATA] section 2.11.1.
        /// Property type Value type
        /// PtypMultipleBinary PtypBinary
        /// PtypMultipleString8 PtypString8
        /// PtypMultipleString PtypString
        /// For each variable length multiple-valued property, if there are N values, there MUST be N + 1
        /// streams: N streams to store each individual value and one stream to store the lengths of all the
        /// individual values.
        func readVariableLengthMultiValuedProperty<T>(lengthFunc: (inout DataStream) throws -> UInt32, readFunc: (inout DataStream, Int) throws-> T) throws -> [T]? {
            /// [MS-OXMSG] 2.1.4.2.1 Length Stream
            /// The name of the stream that stores the lengths of all values is derived by prefixing a string containing
            /// the hexadecimal representation of the property tag with the string "__substg1.0_". For example, if
            /// the property is PidTagScheduleInfoDelegateNames ([MS-OXPROPS] section 2.963), the stream's
            /// name is "__substg1.0_6844101F", where "6844101F" is the hexadecimal representation of the
            /// property tag for PidTagScheduleInfoDelegateNames.
            /// The number of entries in the length stream (1) MUST be equal to the number of values of the
            /// multiple-valued property. The entries in the length stream are stored contiguously. The first entry in
            /// the length stream specifies the size of the first value of the multiple-valued property; the second entry
            /// specifies the size of the second value, and so on. The format of length stream entries depends on the
            /// property's type. The following sections specify the format of one entry in the length stream.
            guard let data = getData(id: id, type: type) else {
                return nil
            }
            
            var dataStream = DataStream(data: data)
            
            /// [MS-OXMSG] 2.1.4.2.1.2 Length for PtypMultipleString8 or PtypMultipleString
            /// Each entry in the length stream for a PtypMultipleString8 property or a PtypMultipleString
            /// property ([MS-OXCDATA] section 2.11.1) has the following structure.
            let count = dataStream.count / 4
            var lengths = [UInt32]()
            lengths.reserveCapacity(count)
            for _ in 0..<count {
                let length = try! lengthFunc(&dataStream)
                lengths.append(length)
            }
            
            /// [MS-OXMSG] 2.1.4.2.2 Value Streams
            /// Each value of the property MUST be stored in an individual stream. The name of the stream is constructed as follows:
            /// 1. Concatenate a string containing the hexadecimal representation of the property tag to the string "__substg1.0_".
            /// 2. Concatenate the character "-" to the result of step 1.
            /// 3. Concatenate a string containing the hexadecimal representation of the index of the value within that property,
            /// to the result of step 2. The index used MUST match the index of the value's length, which is stored in the length stream.
            /// The indexes are zero-based.
            /// For example, the first value of the property PidTagScheduleInfoDelegateNames ([MS-OXPROPS]
            /// section 2.963) is stored in a stream with name "__substg1.0_6844101F-00000000", where
            /// "6844101F" is the hexadecimal representation of the property tag and "00000000" represents the
            /// index of the first value. The second value of the property is stored in a stream with name
            /// "__substg1.0_6844101F-00000001", and so on.
            /// In case of multiple-valued properties of type PtypMultipleString and PtypMultipleString8 ([MSOXCDATA] section 2.11.1),
            /// all values of the property MUST end with the NULL terminating character.
            var values = [T]()
            values.reserveCapacity(count)
            for index in 0..<count {
                let indexHex = String(index, radix: 16, uppercase: true).padLeft(toLength: 8, withPad: "0")
                let storageName = "\(getStorageName(id: id, type: value.propertyTag.type))-\(indexHex)"
                guard let entry = parent.children[storageName] else {
                    print("Could not find entry \(storageName)")
                    return nil
                }
                
                var dataStream = entry.dataStream
                if let value = try? readFunc(&dataStream, Int(lengths[index]) - 1) {
                    values.append(value)
                }
            }
            
            return values
        }
        
        switch type {
        case .integer16:
            return reinterpret_cast(to: UInt16.self)
        case .unspecified:
            return nil
        case .null:
            return nil
        case .integer32:
            return reinterpret_cast(to: UInt32.self)
        case .floating32:
            return reinterpret_cast(to: Float32.self)
        case .floating64:
            return reinterpret_cast(to: Float64.self)
        case .boolean:
            return (reinterpret_cast(to: UInt8.self) != 0)
        case .integer64:
            return reinterpret_cast(to: UInt64.self)
        case .time:
            let ft = reinterpret_cast(to: FILETIME.self)
            return ft.date
        case .string8:
            guard let data = getData(id: id, type: type) else {
                return nil
            }

            return String(bytes: data, encoding: .utf8)
        case .string:
            guard let data = getData(id: id, type: type) else {
                return nil
            }

            return String(bytes: data, encoding: .utf16LittleEndian)
        case .binary:
            return getData(id: id, type: type)
        case .guid:
            guard let data = getData(id: id, type: type) else {
                return nil
            }
            
            var dataStream = DataStream(data: data)
            return try? dataStream.readGUID(endianess: .littleEndian)
        case .objectOrEmbeddedTable:
            return getData(id: id, type: type)
        case .multipleString8:
            /// [MS-OXMSG] 2.1.4.2.1.2 Length for PtypMultipleString8 or PtypMultipleString
            /// Each entry in the length stream for a PtypMultipleString8 property or a PtypMultipleString
            /// property ([MS-OXCDATA] section 2.11.1) has the following structure.
            /// Length (4 bytes): The length, in bytes, of the corresponding value of the PtypString8 property or
            /// the PtypString property ([MS-OXCDATA] section 2.11.1). The length includes the NULL
            /// terminating character.
            return try? readVariableLengthMultiValuedProperty(
                lengthFunc: { try $0.read(endianess: .littleEndian) as UInt32 },
                readFunc: { try $0.readString(count: $1, encoding: .ascii)! })
        case .multipleString:
            /// [MS-OXMSG] 2.1.4.2.1.2 Length for PtypMultipleString8 or PtypMultipleString
            /// Each entry in the length stream for a PtypMultipleString8 property or a PtypMultipleString
            /// property ([MS-OXCDATA] section 2.11.1) has the following structure.
            /// Length (4 bytes): The length, in bytes, of the corresponding value of the PtypString8 property or
            /// the PtypString property ([MS-OXCDATA] section 2.11.1). The length includes the NULL
            /// terminating character.
            return try? readVariableLengthMultiValuedProperty(
                lengthFunc: { try $0.read(endianess: .littleEndian) as UInt32 },
                readFunc: { try $0.readString(count: $1, encoding: .utf16LittleEndian)! })
        case .unknown:
            return nil
        case .currency:
            return "TODO: Currency"
        case .floatingTime:
            return "TODO: FloatingTime"
        case .errorCode:
            return "TODO: ErrorCode"
        case .serverId:
            return "TODO: ServerId"
        case .restriction:
            return "TODO: Restriction"
        case .ruleAction:
            return "TODO: RuleAction"
        case .multipleInteger16:
            return try? readFixedLengthMultiValuedProperty { try $0.read(endianess: .littleEndian) as UInt16 }
        case .multipleInteger32:
            return try? readFixedLengthMultiValuedProperty { try $0.read(endianess: .littleEndian) as UInt32 }
        case .multipleFloating32:
            return try? readFixedLengthMultiValuedProperty { try $0.readFloat(endianess: .littleEndian) }
        case .multipleFloating64:
            return try? readFixedLengthMultiValuedProperty { try $0.readFloat(endianess: .littleEndian) }
        case .multipleCurrency:
            return "TODO: MultipleCurrency"
        case .multipleFloatingTime:
            return "TODO: MultipleFloatingTime"
        case .multipleInteger64:
            return try? readFixedLengthMultiValuedProperty { try $0.read(endianess: .littleEndian) as UInt64 }
        case .multipleTime:
            return "TODO: MultipleTime"
        case .multipleGuid:
            return try? readFixedLengthMultiValuedProperty { try $0.readGUID(endianess: .littleEndian) }
        case .multipleBinary:
            /// [MS-OXMSG] 2.1.4.2.1.1 Length for PtypMultipleBinary
            /// Each entry in the length stream for a PtypMultipleBinary property ([MS-OXCDATA] section 2.11.1)
            /// has the following structure.
            return try? readVariableLengthMultiValuedProperty(
                lengthFunc: {
                    /// Length (4 bytes): The length, in bytes, of the corresponding value of the PtypBinary property
                    /// ([MS-OXCDATA] section 2.11.1).
                    let length: UInt32 = try $0.read(endianess: .littleEndian)
                    
                    /// Reserved (4 bytes): This field MUST be set to 0 when writing a .msg file and MUST be ignored when
                    /// reading a .msg file.
                    let _: UInt32 = try $0.read(endianess: .littleEndian)
                    
                    return length
                },
                readFunc: { try Data($0.readBytes(count: $1)) })
        }
    }
    
    public func getAllProperties() -> [UInt16: Any?] {
        var properties: [UInt16: Any] = [:]
        properties.reserveCapacity(values.count)
        
        for entry in values.sorted(by: { $0.key < $1.key }) {
            properties[entry.key] = getValue(id: entry.key)
        }
        
        return properties
    }
    
    public var debugDescription: String {
        var s = ""
        if let header = header as? CustomDebugStringConvertible {
            s += header.debugDescription
            s += "\n"
        }
        
        for kvp in values {
            s += "___\n"
            s += "Tag: \(kvp.value.propertyTag)\n"
            
            guard let any = getValue(id: kvp.key) else {
                continue
            }
            s += "Value: \(any)\n\n"
        }
        
        return s
    }
}
