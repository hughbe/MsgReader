//
//  EmbeddedMessagePropertiesHeader.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import DataStream

/// [MS-OXMSG] 2.4.1 Header
/// The header of the property stream differs depending on which storage this property stream belongs to.
/// [MS-OXMSG] 2.4.1.2 Embedded Message object Storage
/// The header for the property stream contained inside any Embedded Message object storage has the following structure.
internal struct EmbeddedMessagePropertiesHeader: PropertiesHeader, CustomDebugStringConvertible {
    public let reserved: UInt64
    public let nextRecipientID: UInt32
    public let nextAttachmentID: UInt32
    public let recipientCount: UInt32
    public let attachmentCount: UInt32
    
    init(dataStream: inout DataStream) throws {
        /// Reserved (8 bytes): This field MUST be set to zero when writing a .msg file and MUST be ignored when reading a .msg file.
        self.reserved = try dataStream.read(endianess: .littleEndian)
        
        /// Next Recipient ID (4 bytes): The ID to use for naming the next Recipient object storage if one is created inside the .msg file.
        /// The naming convention to be used is specified in section 2.2.1.
        self.nextRecipientID = try dataStream.read(endianess: .littleEndian)
        
        /// Next Attachment ID (4 bytes): The ID to use for naming the next Attachment object storage if one is created inside the .msg file.
        /// The naming convention to be used is specified in section 2.2.2.
        self.nextAttachmentID = try dataStream.read(endianess: .littleEndian)
        
        /// Recipient Count (4 bytes): The number of Recipient objects.
        self.recipientCount = try dataStream.read(endianess: .littleEndian)
        
        /// Attachment Count (4 bytes): The number of Attachment objects.
        self.attachmentCount = try dataStream.read(endianess: .littleEndian)
    }
    
    public var debugDescription: String {
        var s = "-- EmbeddedMessagePropertiesHeader --\n"
        s += "- Reserved: \(reserved.hexString)\n"
        s += "- NextRecipientID: \(nextRecipientID.hexString)\n"
        s += "- NextAttachmentID: \(nextAttachmentID.hexString)\n"
        s += "- RecipientCount: \(recipientCount)\n"
        s += "- AttachmentCount: \(attachmentCount)\n"
        return s
    }
}
