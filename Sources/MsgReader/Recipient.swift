//
//  MsgRecipient.swift
//
//
//  Created by Hugh Bellamy on 21/07/2020.
//
//

import CompoundFileReader
import Foundation
import MAPI

/// [MS-OXMSG] 2.2 Storages
/// [MS-OXMSG] 2.2.1 Recipient Object Storage
/// The Recipient object storage contains streams and substorages that store properties pertaining to one Recipient object.
/// The following MUST be true for Recipient object storages:
///  The Recipient object storage representing the first Recipient object is named
/// "__recip_version1.0_#00000000". The storage representing the second is named
/// "__recip_version1.0_#00000001" and so on. The digit suffix is in hexadecimal. For example, the
/// storage name for the eleventh Recipient object is "__recip_version1.0_#0000000A".
///  A .msg file can have a maximum of 2048 Recipient object storages.
///  There is exactly one property stream, and it contains entries for all properties of the Recipient object.
///  There is exactly one stream for each variable length property of the Recipient object, as specified in section 2.1.3.
public struct Recipient: MessageStorageInternal, CustomStringConvertible {
    internal var properties: PropertyStream<AttachmentOrRecipientPropertiesHeader>
    internal var namedProperties: NamedPropertyMapping?

    internal init(storage: CompoundFileStorage, namedProperties: NamedPropertyMapping?) throws {
        self.properties = try PropertyStream(parent: storage)
        self.namedProperties = namedProperties
    }
    
    public var description: String {
        let x = Dictionary(uniqueKeysWithValues: properties.values.map { ($0.key, try? properties.getValue(id: $0.key)) })
        return propertiesString(properties: x, namedProperties: namedProperties?.properties)
    }
}
