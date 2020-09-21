//
//  MsgAttachment.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import CompoundFileReader
import Foundation
import MAPI

/// [MS-OXMSG] 2.2.2 Attachment Object Storage
/// The Attachment object storage contains streams and substorages that store properties pertaining to one Attachment object.
/// The following MUST be true for Attachment object storages:
///  The Attachment object storage representing the first Attachment object is named
/// "__attach_version1.0_#00000000". The storage representing the second is named
/// "__attach_version1.0_#00000001" and so on. The digit suffix is in hexadecimal. For example, the
/// storage name for the eleventh Attachment object is "__attach_version1.0_#0000000A"
///  A .msg file can have a maximum of 2048 Attachment object storages.
///  There is exactly one property stream, and it contains entries for all properties of the Attachment
/// object.
///  There is exactly one stream for each variable length property of the Attachment object, as
/// specified in section 2.1.3.
///  There is exactly one stream for each fixed length multiple-valued property of the Attachment
/// object, as specified in section 2.1.4.1.
///  For each variable length multiple-valued property of the Attachment object, if there are N values,
/// there are N + 1 streams, as specified in section 2.1.4.2.
///  If the Attachment object itself is a Message object, there is an Embedded Message object
/// storage under the Attachment object storage.
///  If the Attachment object has a value of afStorage (0x00000006) for the PidTagAttachMethod
/// property ([MS-OXCMSG] section 2.2.2.9), then there is a custom attachment storage under the
/// Attachment object storage.
///  For any named properties on the Attachment object, the corresponding mapping information
/// MUST be present in the named property mapping storage.
public struct MsgAttachment: MessageStorageInternal, CustomStringConvertible {
    internal var properties: PropertyStream<AttachmentOrRecipientPropertiesHeader>
    internal var file: MsgFile
    
    internal var namedProperties: NamedPropertyMapping? {
        return file.namedProperties
    }
    
    internal init(storage: CompoundFileStorage, file: MsgFile) throws {
        self.properties = try PropertyStream(parent: storage)
        self.file = file
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
        return propertiesString(properties: x, namedProperties: namedProperties?.properties)
    }
}
