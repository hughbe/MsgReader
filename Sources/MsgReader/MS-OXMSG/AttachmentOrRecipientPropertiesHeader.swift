//
//  AttachmentOrRecipientPropertiesHeader.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import DataStream

/// [MS-OXMSG] 2.4.1 Header
/// The header of the property stream differs depending on which storage this property stream belongs to.
/// [MS-OXMSG] 2.4.1.3 Attachment Object Storage or Recipient Object Storage
/// The header for the property stream contained inside an Attachment object storage or a Recipient object storage has the following structure.
internal struct AttachmentOrRecipientPropertiesHeader: PropertiesHeader, CustomDebugStringConvertible {
    public let reserved: UInt64
    
    public init(dataStream: inout DataStream) throws {
        /// Reserved (8 bytes): This field MUST be set to zero when writing a .msg file and MUST be ignored when reading a .msg file.
        self.reserved = try dataStream.read(endianess: .littleEndian)
    }
    
    public var debugDescription: String {
        var s = "-- Attachment Recipient Properties Header --\n"
        s += "- Reserved: \(reserved.hexString)\n"
        return s
    }
}
