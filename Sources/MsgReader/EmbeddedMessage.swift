//
//  EmbeddedMesssage.swift
//  
//
//  Created by Hugh Bellamy on 23/10/2020.
//

import CompoundFileReader
import MAPI

public struct EmbeddedMessage: MessageStorageInternal, CustomStringConvertible {
    internal var properties: PropertyStream<EmbeddedMessagePropertiesHeader>
    internal var namedProperties: NamedPropertyMapping?
    
    public private(set) var recipients = [Recipient]()
    public private(set) var attachments = [Attachment]()

    internal init(storage: inout CompoundFileStorage, namedProperties: NamedPropertyMapping?) throws {
        self.properties = try PropertyStream(parent: storage)
        self.namedProperties = namedProperties
        
        for child in storage.children {
            if child.key.hasPrefix("__recip_version1.0_") {
                let recipient = try Recipient(storage: child.value, namedProperties: namedProperties)
                recipients.append(recipient)
            } else if child.key.hasPrefix("__attach_version1.0_") {
                let attachment = try Attachment(storage: child.value, namedProperties: namedProperties)
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
        let x = Dictionary(uniqueKeysWithValues: properties.values.map { ($0.key, try? properties.getValue(id: $0.key)) })
        return propertiesString(properties: x, namedProperties: namedProperties?.properties)
    }
}
