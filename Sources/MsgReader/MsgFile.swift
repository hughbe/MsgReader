//
//  MsgFile.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import CompoundFileReader
import DataStream
import Foundation
import MAPI

public struct MsgFile: MessageStorageInternal, CustomStringConvertible {
    internal var properties: PropertyStream<TopLevelPropertiesHeader>
    internal var namedProperties: NamedPropertyMapping?

    public private(set) var recipients = [MsgRecipient]()
    public private(set) var attachments = [MsgAttachment]()
    
    public init(data: Data) throws {
        let file = try CompoundFile(data: data)
        try self.init(storage: file.rootStorage)
    }
    
    public init(storage: CompoundFileStorage) throws {
        properties = try PropertyStream(parent: storage)
        
        var storage = storage
        if let namedPropertiesEntry = storage.children["__nameid_version1.0"] {
            namedProperties = try? NamedPropertyMapping(storage: namedPropertiesEntry)
        }
        
        for child in storage.children {
            if child.key.hasPrefix("__recip_version1.0_") {
                let recipient = try MsgRecipient(storage: child.value, file: self)
                recipients.append(recipient)
            } else if child.key.hasPrefix("__attach_version1.0_") {
                let attachment = try MsgAttachment(storage: child.value, file: self)
                attachments.append(attachment)
            }
        }
        
        recipients.sort { ($0.rowid ?? 0) < ($1.rowid ?? 0) }
        attachments.sort { ($0.attachNumber ?? 0) < ($1.attachNumber ?? 0) }
    }

    /// [MS-OXMSG] 2.1.1 Properties of a .msg File
    /// [MS-OXMSG] 2.1.1.1 PidTagStoreSupportMask
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagStoreSupportMask property ([MS-OXPROPS] section 2.1024) indicates whether string
    /// properties within the .msg file are Unicode-encoded or not. This property defines multiple flags, but
    /// only the STORE_UNICODE_OK flag is valid. All other bits MUST be ignored. The settings for this
    /// property are summarized in the following table.
    var storeSupportMask: StoreSupportMask? {
        guard let rawValue: UInt32 = getProperty(id: .tagStoreSupportMask) else {
            return nil
        }
        
        return StoreSupportMask(rawValue: rawValue)
    }
    
    public var description: String {
        let x = Dictionary(uniqueKeysWithValues: properties.values.map { ($0.key, properties.getValue(id: $0.key)) })
        var s = propertiesString(properties: x, namedProperties: namedProperties?.properties)

        for recipient in recipients {
            s += "\(recipient)\n"
        }
        for attachment in attachments {
            s += "\(attachment)\n"
        }
        
        return s
    }
}
