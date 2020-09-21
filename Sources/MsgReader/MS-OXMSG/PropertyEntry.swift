//
//  PropertyEntry.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import DataStream
import Foundation
import MAPI

/// [MS-OXMSG] 2.4.2 Data
/// The data inside the property stream MUST be an array of 16-byte entries. The number of properties, each represented by one entry,
/// can be determined by first measuring the size of the property stream, then subtracting the size of the header from it, and then dividing
/// the result by the size of one entry.
/// The structure of each entry, representing one property, depends on whether the property is a fixed length property or not.
internal struct PropertyEntry: CustomDebugStringConvertible {
    public let propertyTag: PropertyTag
    public let flags: PropertyEntryFlags
    public let value: UInt64
    
    public init(dataStream: inout DataStream) throws {
        // Property Tag (4 bytes): The property tag of the property.
        propertyTag = try PropertyTag(dataStream: &dataStream)

        // Flags (4 bytes): Flags giving context to the property. Possible values for this field are given in the following table. Any bitwise combination of the flags is valid.
        let flagsRaw = try dataStream.read(endianess: .littleEndian) as UInt32
        flags = PropertyEntryFlags(rawValue: flagsRaw)

        // Value (8 bytes): This field contains a Fixed Length Property Value structure, as specified in section 2.4.2.1.1.
        // [MS-OXMSG] 2.4.2.1.1 Fixed Length Property Value
        // The following structure contains the value of the property.
        // Data (variable): The value of the property. The size of this field depends upon the property type, which is specified in the Property Tag field, as specified in section 2.4.2.1.
        // The size required for each property type is specified in [MS-OXCDATA] section 2.11.1.
        // Reserved (variable): This field MUST be ignored when reading a .msg file. The size of the Reserved field is the difference between 8 bytes and the size of the Data field;
        // if the size of the Reserved field is greater than 0, this field MUST be set to 0 when writing a .msg file.
        value = try dataStream.read(endianess: .littleEndian) as UInt64
    }
    
    var debugDescription: String {
        var s = "-- PropertyValue --\n"
        s += "Tag: \(propertyTag)\n"
        s += "Flags: \(flags)\n"
        s += "Data: \(value.hexString)\n"
        return s
    }
}
