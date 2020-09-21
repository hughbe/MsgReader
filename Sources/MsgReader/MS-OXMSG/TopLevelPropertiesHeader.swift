//
//  TopLevelPropertiesHeader
//  MsgViewer
//
//  Created by Hugh Bellamy on 21/07/2020.
//  Copyright © 2020 Hugh Bellamy. All rights reserved.
//

import DataStream
import Foundation

/// [MS-OXMSG] 2.4.1 Header
/// The header of the property stream differs depending on which storage this property stream belongs to.
/// [MS-OXMSG] 2.4.1.1 Top Level
/// The header for the property stream contained inside the top level of the .msg file, which represents the Message object itself, has the following structure.
internal struct TopLevelPropertiesHeader: PropertiesHeader, CustomDebugStringConvertible {
    public let reserved1: UInt64
    public let nextRecipientID: UInt32
    public let nextAttachmentID: UInt32
    public let recipientCount: UInt32
    public let attachmentCount: UInt32
    public let reserved2: UInt64
    
    public init(dataStream: inout DataStream) throws {
        // Reserved (8 bytes): This field MUST be set to zero when writing a .msg file and MUST be ignored
        // when reading a .msg
        reserved1 = try dataStream.read(endianess: .littleEndian)

        // Next Recipient ID (4 bytes): The ID to use for naming the next Recipient object storage if one is
        // created inside the .msg  The naming convention to be used is specified in section 2.2.1. If no
        // Recipient object storages are contained in the .msg file, this field MUST be set to 0.
        nextRecipientID = try dataStream.read(endianess: .littleEndian)

        // Next Attachment ID (4 bytes): The ID to use for naming the next Attachment object storage if one
        // is created inside the .msg file. The naming convention to be used is specified in section 2.2.2. If
        // no Attachment object storages are contained in the .msg file, this field MUST be set to 0.
        nextAttachmentID = try dataStream.read(endianess: .littleEndian)

        // Recipient Count (4 bytes): The number of Recipient objects.
        recipientCount = try dataStream.read(endianess: .littleEndian)

        // Attachment Count (4 bytes): The number of Attachment objects.
        attachmentCount = try dataStream.read(endianess: .littleEndian)

        // Reserved (8 bytes): This field MUST be set to 0 when writing a .msg file and MUST be ignored when
        // reading a .msg file
        reserved2 = try dataStream.read(endianess: .littleEndian)
    }
    
    var debugDescription: String {
        var s = "-- TopLevelPropertiesHeader --\n"
        s += "Reserved1: \(reserved1.hexString)\n"
        s += "Next Recipient ID: \(nextRecipientID.hexString)\n"
        s += "Next Attachment ID: \(nextAttachmentID.hexString)\n"
        s += "Recipient Count: \(recipientCount.hexString)\n"
        s += "Attachment Count: \(attachmentCount.hexString)\n"
        s += "Reserved2: \(reserved2.hexString)\n"
        return s
    }
}
