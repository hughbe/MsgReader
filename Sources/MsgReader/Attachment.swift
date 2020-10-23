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
///  The Attachment object storage representing the first Attachment object is named "__attach_version1.0_#00000000". The storage
/// representing the second is named "__attach_version1.0_#00000001" and so on. The digit suffix is in hexadecimal. For example, the
/// storage name for the eleventh Attachment object is "__attach_version1.0_#0000000A"
///  A .msg file can have a maximum of 2048 Attachment object storages.
///  There is exactly one property stream, and it contains entries for all properties of the Attachment object.
///  There is exactly one stream for each variable length property of the Attachment object, as specified in section 2.1.3.
///  There is exactly one stream for each fixed length multiple-valued property of the Attachment object, as specified in section 2.1.4.1.
///  For each variable length multiple-valued property of the Attachment object, if there are N values, there are N + 1 streams, as
/// specified in section 2.1.4.2.
///  If the Attachment object itself is a Message object, there is an Embedded Message object storage under the Attachment object storage.
///  If the Attachment object has a value of afStorage (0x00000006) for the PidTagAttachMethod property ([MS-OXCMSG] section 2.2.2.9),
/// then there is a custom attachment storage under the Attachment object storage.
///  For any named properties on the Attachment object, the corresponding mapping information MUST be present in the named property
/// mapping storage.
public struct Attachment: MessageStorageInternal, CustomStringConvertible {
    private let storage: CompoundFileStorage
    internal var properties: PropertyStream<AttachmentOrRecipientPropertiesHeader>
    internal var namedProperties: NamedPropertyMapping?
    
    internal init(storage: CompoundFileStorage, namedProperties: NamedPropertyMapping?) throws {
        self.storage = storage
        self.properties = try PropertyStream(parent: storage)
        self.namedProperties = namedProperties
    }
    
    /// [MS-OXMSG] 2.1.1 Properties of a .msg File
    /// [MS-OXMSG] 2.1.1.1 PidTagStoreSupportMask
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagStoreSupportMask property ([MS-OXPROPS] section 2.1024) indicates whether string properties within the .msg file
    /// are Unicode-encoded or not. This property defines multiple flags, but only the STORE_UNICODE_OK flag is valid. All other bits
    /// MUST be ignored. The settings for this property are summarized in the following table.
    public var storeSupportMask: StoreSupportMask? {
        guard let rawValue: UInt32 = getProperty(id: .tagStoreSupportMask) else {
            return nil
        }
        
        return StoreSupportMask(rawValue: rawValue)
    }
    
    /// [MS-OXMSG] 2.2.2.1 Embedded Message Object Storage
    /// The .msg File Format defines separate storage semantics for Embedded Message objects. First, as for any other Attachment object,
    /// an Attachment object storage is created for them. Any properties on the Attachment object are stored under the Attachment object
    /// storage, as would be done for a regular Attachment object.
    /// Then within that Attachment object storage, a substorage with the name "__substg1.0_3701000D" MUST be created. All properties
    /// of the Embedded Message object are contained inside this storage and follow the regular property storage semantics.
    /// If there are multiple levels of Attachment objects; for example, if the Embedded Message object further has Attachment objects,
    /// they are represented by substorages contained in the Embedded Message object storage and follow the regular storage semantics
    /// for Attachment objects. For each Recipient object of the Embedded Message object, there is a Recipient object storage contained in
    /// the Embedded Message object storage.
    /// However, named property mapping information for any named properties on the Embedded Message object MUST be stored in the
    /// named property mapping storage under the top level, and the Embedded Message object MUST NOT contain a named property
    /// mapping storage.
    /// The Embedded Message object can have different Unicode state than the Message object containing it, and so its Unicode state
    /// SHOULD be checked as specified in section 2.1.3. It is important to understand the difference between the properties on the
    /// Attachment object and the properties on the Embedded Message object that the Attachment object represents. An example of a
    /// property on the Attachment object would be PidTagDisplayName ([MS-OXPROPS] section 2.670), which is a property that all
    /// Attachment objects have irrespective of whether they represent Embedded Message objects or regular Attachment objects. Such
    /// properties are stored in the Attachment object storage. An example of a property on an Embedded Message object is
    /// PidTagSubject ([MSOXPROPS] section 2.1027), and it is contained in the Embedded Message object storage.
    public var embeddedMessage: EmbeddedMessage? {
        guard let attachMethod = attachMethod, attachMethod == .embeddedMessage else {
            return nil
        }
        
        var storage = self.storage
        guard var embeddedStorage = storage.children["__substg1.0_3701000D"] else {
            return nil
        }
        
        return try? EmbeddedMessage(storage: &embeddedStorage, namedProperties: namedProperties)
    }

    /// [MS-OXMSG] 2.2.2.2 Custom Attachment Storage
    /// The .msg File Format defines separate storage semantics for attachments that represent data from an     arbitrary client application.
    /// These are attachments that have the PidTagAttachMethod property ([MS-OXCMSG] section 2.2.2.9) set to afStorage (0x00000006).
    /// First, as for any other Attachment object, an Attachment object storage is created for them. Any properties on the Attachment object
    /// are stored under the Attachment object storage, as would be done for a regular Attachment object.
    /// Then, within that Attachment object storage, a substorage with the name "__substg1.0_3701000D" is created. At this point, the
    /// application that owns the data is allowed to define the structure of the substorage. Thus, the streams and storages contained in
    /// the custom attachment storage are defined by the application that owns the data. For an example, see section 3.3.
    public var customAttachmentStorage: CompoundFileStorage? {
        guard let attachMethod = attachMethod, attachMethod == .storage else {
            return nil
        }
        
        var storage = self.storage
        return storage.children["__substg1.0_3701000D"]
    }
    
    public var name: String? {
        return displayName ?? attachLongFilename ?? attachFilename
    }
    
    public var description: String {
        let x = Dictionary(uniqueKeysWithValues: properties.values.map { ($0.key, try? properties.getValue(id: $0.key)) })
        return propertiesString(properties: x, namedProperties: namedProperties?.properties)
    }
}
