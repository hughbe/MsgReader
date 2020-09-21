//
//  MsgRecipient+Properties.swift
//  
//
//  Created by Hugh Bellamy on 26/08/2020.
//

import DataStream
import Foundation
import MAPI

/// [MS-OXOMSG] 2.2.3 E-Mail Submission Properties
/// The following are properties of the recipients (2) identified in the recipient table. These properties are used to control server behavior during message submission.
public extension MsgRecipient {
    /// [MS-OXCMSG] 2.2.1.1 General Properties
    /// The following properties exist on all Message objects. These properties are read-only for the client.
    /// [MS-OXCPRPT] 2.2.1.9 PidTagSearchKey Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagSearchKey property ([MS-OXPROPS] section 2.991) contains a unique binary-comparable
    /// key that identifies an object for a search. Whenever a copy of an object is created, the key is also
    /// copied from the original object. This property does not apply to Folder objects and Logon objects.
    /// This property is read-only for clients.
    /// [MS-OXOABK] 2.2.3.5 PidTagSearchKey
    /// Data type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagSearchKey property ([MS-OXCPRPT] section 2.2.1.9) is formed by concatenating the
    /// ASCII string "EX: " followed by the DN for the object converted to all uppercase, followed by a zerobyte value. This value MUST be present for all Address Book objects on an NSPI server and MUST
    /// be in the aforementioned format.
    /// The PidTagSearchKey property is not present on objects in an offline address book (OAB).
    var searchKey: Data? {
        return getProperty(id: .tagSearchKey)
    }
    
    /// [MS-OXCMSG] 2.2.1.38 PidTagRowid Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagRowid property ([MS-OXPROPS] section 2.939) contains a unique identifier for a
    /// recipient (2) in the message's recipient table. This is a temporary identifier that is valid only for
    /// the life of the Table object.
    var rowid: UInt32? {
        return getProperty(id: .tagRowid)
    }

    /// [MS-OXOMSG] 2.2.3.1 PidTagRecipientType Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagRecipientType property ([MS-OXPROPS] section 2.903) represents the type of a
    /// recipient (2) on the message. This property is set on each recipient (2). Valid values for this
    /// property are as follows.
    var recipientType: RecipientType? {
        guard let value: UInt32 = getProperty(id: .tagRecipientType) else {
            return nil
        }
        
        return RecipientType(rawValue: value)
    }
    
    /// [MS-OXOMSG] 2.2.3.2 PidTagDeferredSendNumber Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// When sending a message is deferred, the PidTagDeferredSendNumber property ([MS-OXPROPS]
    /// section 2.657) SHOULD be set along with the PidTagDeferredSendUnits property (section 2.2.3.3)
    /// if the PidTagDeferredSendTime property (section 2.2.3.4) is absent. The value is set between
    /// 0x00000000 and 0x000003E7 (0 and 999).
    /// The PidTagDeferredSendNumber property is used to compute the value of the
    /// PidTagDeferredSendTime property when the PidTagDeferredSendTime property is not present.
    var deferredSendNumber: UInt32? {
        return getProperty(id: .tagDeferredSendNumber)
    }

    /// [MS-OXOMSG] 2.2.3.3 PidTagDeferredSendUnits Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagDeferredSendUnits property ([MS-OXPROPS] section 2.659) specifies the unit of time by
    /// which the value of the PidTagDeferredSendNumber property (section 2.2.3.2) is multiplied. If set,
    /// the PidTagDeferredSendUnits property has one of the values listed in the following table.
    var deferredSendUnits: MessageUnits? {
        guard let value: UInt32 = getProperty(id: .tagDeferredSendUnits) else {
            return nil
        }
        
        return MessageUnits(rawValue: value)
    }
    
    /// [MS-OXOMSG] 2.2.3.4 PidTagDeferredSendTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The PidTagDeferredSendTime property ([MS-OXPROPS] section 2.658) can be present if a client
    /// would like to defer sending the message after a specific amount of time, as determined by the
    /// implementation.
    /// If the PidTagDeferredSendUnits property (section 2.2.3.3) and the PidTagDeferredSendNumber
    /// property (section 2.2.3.2) are present, the value of this property is recomputed by using the following
    /// formula and the original value is ignored. In this formula, TimeOf(PidTagDeferredSendUnits)
    /// converts the property into the appropriate multiplier based on its value, as specified for the
    /// PidTagDeferredSendUnits property.
    /// PidTagDeferredSendTime = PidTagClientSubmitTime +
    /// PidTagDeferredSendNumber *
    /// TimeOf(PidTagDeferredSendUnits)
    /// If the value of the PidTagDeferredSendTime property is earlier than the current time (in UTC), the
    /// message is sent immediately
    var deferredSendTime: Date? {
        return getProperty(id: .tagDeferredSendTime)
    }
    
    /// [MS-OXOMSG] 2.2.3.5 PidTagExpiryNumber Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagExpiryNumber property ([MS-OXPROPS] section 2.682) is used with the
    /// PidTagExpiryUnits property (section 2.2.3.6) to define the expiry send time. If this property is
    /// present, the value is set between 0x00000000 and 0x000003E7 (0 and 999).
    var expiryNumber: UInt32? {
        return getProperty(id: .tagExpiryNumber)
    }

    /// [MS-OXOMSG] 2.2.3.6 PidTagExpiryUnits Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagExpiryUnits property ([MS-OXPROPS] section 2.684) is used to describe the unit of time
    /// that the value of the PidTagExpiryNumber property (section 2.2.3.5) multiplies. If set, the following
    /// are the valid values of this property.
    var expiryUnits: MessageUnits? {
        guard let value: UInt32 = getProperty(id: .tagExpiryUnits) else {
            return nil
        }
        
        return MessageUnits(rawValue: value)
    }
    
    /// [MS-OXOMSG] 2.2.3.7 PidTagExpiryTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The PidTagExpiryTime property ([MS-OXPROPS] section 2.683) can be present when a client
    /// requests to receive an expiry event if the message arrives late.
    /// If the PidTagExpiryNumber property (section 2.2.3.5) and the PidTagExpiryUnits property
    /// (section 2.2.3.6) are both present, the value of this property is recomputed by the following formula;
    /// the original value is ignored.
    /// PidTagExpiryTime = PidTagClientSubmitTime +
    /// PidTagExpiryNumber *
    /// TimeOf(PidTagExpiryUnits)
    var expiryTime: Date? {
        return getProperty(id: .tagExpiryTime)
    }
    
    /// [MS-OXPROPS] 2.2.3.8 PidTagDeleteAfterSubmit Property
    /// Type: PtypBoolean ([MS-OXCDATA] section 2.11.1)
    /// The PidTagDeleteAfterSubmit property ([MS-OXPROPS] section 2.662) indicates whether the
    /// original message is deleted after the message is sent. If the property is not present, the server uses
    /// the value 0x00.
    /// The valid values for this property are specified in the following table.
    var deleteAfterSubmit: Bool? {
        return getProperty(id: .tagDeleteAfterSubmit)
    }
    
    /// [MS-OXPROPS] 2.2.3.9 PidTagMessageDeliveryTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The server sets the value of the PidTagMessageDeliveryTime property ([MS-OXPROPS] section
    /// 2.783) to the current time (in UTC) when it receives a message.
    var messageDeliveryTime: Date? {
        return getProperty(id: .tagMessageDeliveryTime)
    }
    
    /// [MS-OXPROPS] 2.2.3.10 PidTagSentMailSvrEID Property
    /// Type: PtypServerId ([MS-OXCDATA] section 2.11.1)
    /// The PidTagSentMailSvrEID property ([MS-OXPROPS] section 2.1005) represents the Sent Items
    /// folder for the message. This folder MUST NOT be a search folder. The server requires write
    /// permission on the folder so that the sent e-mail message can be copied to the Sent Items folder.
    /// If this property is present, a copy of the message is created in the specified folder after the message
    /// is sent.
    var sentMailSvrEID: Data? {
        return getProperty(id: .tagSentMailSvrEID)
    }

    /// [MS-OXOPFFB] 2.2.1.1.1 PidTagDisplayName Property
    /// Data type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagDisplayName property ([MS-OXPROPS] section 2.670) MUST be set to "Freebusy Data".
    var displayName: String? {
        return getProperty(id: .tagDisplayName)
    }

    /// [MS-OXOPFFB] 2.2.4 PidTagEntryId Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagEntryId property ([MS-OXPROPS] section 2.677) identifies the Address Book object
    /// that specifies a user. The first two bytes of this property specify the number of bytes that follow. The
    /// remaining bytes constitute the PermanentEntryID structure ([MS-OXNSPI] section 2.2.9.3).
    /// If the PidTagMemberId property (section 2.2.5) is set to one of the two reserved values, the first
    /// two bytes of this property MUST be 0x0000, indicating that zero bytes follow (that is, no
    /// PermanentEntryID structure follows the first two bytes).
    /// [MS-OXOABK] 2.2.3.2 PidTagEntryId
    /// Data type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagEntryId property ([MS-OXCPERM] section 2.2.4) contains an entry ID that identifies an
    /// Address Book object on an NSPI server. The entry ID MUST be formatted as either a
    /// PermanentEntryID structure, as specified in [MS-NSPI] and [MS-OXNSPI] section 2.2.9.3, or an
    /// EphemeralEntryID structure, as specified in [MS-NSPI] and [MS-OXNSPI] section 2.2.9.2.<11>
    /// Messaging clients use this property to open an Address Book object. The client can then perform
    /// operations on the Address Book object, such as obtaining other properties. The types of operations
    /// that can be performed on an Address Book object are specified in [MS-NSPI] and [MS-OXNSPI]
    /// section 3.1.4 and in [MS-OXCMAPIHTTP] section 2.2.5. When the entry ID is in Permanent Entry ID
    /// format, its DN MUST match the value of the PidTagEmailAddress property (section 2.2.3.14) and
    /// MUST follow the format that is specified in section 2.2.1.1.
    /// The OAB Format and Schema Protocol specification, as specified in [MS-OXOAB], does not include
    /// value for the PidTagEntryId property for Address Book objects in its data structure. Instead, the
    /// PidTagEmailAddress property (section 2.2.3.14) identifies objects in an OAB. 
    var entryId: EntryID? {
        guard let data: Data = getProperty(id: .tagEntryId) else {
            return nil
        }
        
        var dataStream = DataStream(data: data)
        return try? getEntryID(dataStream: &dataStream, size: dataStream.count)
    }
    
    /// [MS-OXOABK] 2.2.3.6 PidTagInstanceKey
    /// Data type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagInstanceKey property ([MS-OXPROPS] section 2.737) identifies an object on an NSPI
    /// server. It is a Minimal Entry ID, represented as a 4 byte binary value, in little-endian byte order.
    /// The PidTagInstanceKey property is not present on objects in an offline address book (OAB).
    var instanceKey: Data? {
        return getProperty(id: .tagInstanceKey)
    }
    
    /// [MS-OXOABK] 2.2.3.14 PidTagEmailAddress
    /// Data type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagEmailAddress property ([MS-OXPROPS] section 2.675) contains an Address Book
    /// object's e-mail address, expressed in X500 format, using the format that is particular to the type of
    /// object, as specified in section 2.2.1.1. This property MUST be present for every Address Book object.
    /// Its value MUST match the DN of the Permanent Entry ID for the object if the object is present on an
    /// NSPI server. Its DN MUST follow the format particular to the type of object, as specified in section
    /// 2.2.1.1.
    var emailAddress: String? {
        return getProperty(id: .tagEmailAddress)
    }
    
    /// [MS-OXOABK] 2.2.3.35 PidTagAddressBookDisplayTypeExtended
    /// Data type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAddressBookDisplayTypeExtended property ([MS-OXPROPS] section 2.509) is limited
    /// to Recipient objects. The PidTagAddressBookDisplayTypeExtended property SHOULD be
    /// present on objects on an NSPI server or an offline address book (OAB).<22>
    var addressBookDisplayTypeExtended: UInt32? {
        return getProperty(id: .tagAddressBookDisplayTypeExtended)
    }
    
    /// [MS-OXOABK] 2.2.3.13 PidTagAddressType
    /// Data type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAddressType property ([MS-OXPROPS] section 2.570) contains an Address Book
    /// object's e-mail address type. It MUST have the value "EX" for all objects on an NSPI server.
    /// The PidTagAddressType property is not present on objects in an offline address book (OAB).
    var addressType: String? {
        return getProperty(id: .tagAddressType)
    }
}
