//
//  MsgAttachment+AttachmentObjectProperties.swift
//  
//
//  Created by Hugh Bellamy on 20/08/2020.
//

import Foundation
import MAPI

/// [MS-OXCMSG] 2.2 Message Syntax
/// [MS-OXCMSG] 2.2.2 Attachment Object Properties
/// [MS-OXCMSG] 2.2.2.1 General Properties
/// The following properties exist on any Attachment object. These properties are set by the server and are read-only for the client.
public extension MsgAttachment {
    /// [MS-OXCMSG] 2.2.2.1 General Properties
    /// The following properties exist on any Attachment object. These properties are set by the server and
    /// are read-only for the client.
    /// [MS-OXCPRPT] 2.2.1.2 PidTagAccessLevel Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAccessLevel property ([MS-OXPROPS] section 2.501) indicates the client's access level to
    /// the object. This property does not apply to Folder objects and Logon objects. This value of this
    /// property MUST be one of the values in the following table. This property is read-only for the client.
    var accessLevel: MessageAccessLevel? {
        guard let rawValue: UInt32 = getProperty(id: .tagAccessLevel) else {
            return nil
        }
        
        return MessageAccessLevel(rawValue: rawValue)
    }
    
    /// [MS-OXCPRPT] 2.2.1.7 PidTagObjectType Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagObjectType property ([MS-OXPROPS] section 2.807) indicates the type of Server
    /// object. This property does not apply to Folder objects and Logon objects. The value of this
    /// property MUST be one of the values in the following table. This property is read-only for the client.
    var objectType: ObjectType? {
        guard let rawValue: UInt32 = getProperty(id: .tagObjectType) else {
            return nil
        }
        
        return ObjectType(rawValue: rawValue)
    }
    
    /// [MS-OXCPRPT] 2.2.1.8 PidTagRecordKey Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagRecordKey property ([MS-OXPROPS] section 2.904) contains a unique binary-comparable
    /// identifier for a specific object. Whenever a copy of an object is created, the server generates a new
    /// identifier for the copied object. This property does not apply to Folder objects and Logon objects.
    /// This property is read-only for the client.
    var recordKey: Data? {
        return getProperty(id: .tagRecordKey)
    }
    
    /// [MS-OXCMSG] 2.2.2.2 PidTagLastModificationTime Property
    /// Type: PtypTime, in UTC ([MS-OXCDATA] section 2.11.1)
    /// The PidTagLastModificationTime property ([MS-OXPROPS] section 2.764) indicates the last time
    /// the file referenced by the Attachment object was modified, or the last time the Attachment object
    /// itself was modified.
    var lastModificationTime: Date? {
        return getProperty(id: .tagLastModificationTime)
    }
    
    /// [MS-OXCMSG] 2.2.2.3 PidTagCreationTime Property
    /// Type: PtypTime, in UTC ([MS-OXCDATA] section 2.11.1)
    /// Indicates the time the file referenced by the Attachment object was created, or the time the
    /// Attachment object itself was created.
    var creationTime: Date? {
        return getProperty(id: .tagCreationTime)
    }
    
    /// [MS-OXCMSG] 2.2.2.4 PidTagDisplayName Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagDisplayName property ([MS-OXPROPS] section 2.676) contains the name of the
    /// attachment as input by the end user. This property is set to the same value as the
    /// PidTagAttachLongFilename property (section 2.2.2.13).
    /// [MS-OXORMMS] 2.2.3.1 PidTagAttachLongFilename Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagAttachLongFilename property ([MS-OXCMSG] section 2.2.2.10) for a
    /// rights-managed email message MUST be set to "message.rpmsg".
    var displayName: String? {
        return getProperty(id: .tagDisplayName)
    }
    
    /// [MS-OXCMSG] 2.2.2.5 PidTagAttachSize Property
    /// Type: PtypInteger32, unsigned ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachSize property ([MS-OXPROPS] section 2.608) contains the size in bytes consumed
    /// by the Attachment object on the server. This property is read-only for the client.
    var attachSize: UInt32? {
        return getProperty(id: .tagAttachSize)
    }
    
    /// [MS-OXCMSG] 2.2.2.6 PidTagAttachNumber Property
    /// Type: PtypInteger32, unsigned ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachNumber property ([MS-OXPROPS] section 2.603) identifies the Attachment
    /// object within its Message object. The value of this property MUST be unique among the Attachment
    /// objects in a message.
    var attachNumber: UInt32? {
        return getProperty(id: .tagAttachNumber)
    }
    
    /// [MS-OXCMSG] 2.2.2.7 PidTagAttachDataBinary Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachDataBinary property ([MS-OXPROPS] section 2.589) contains the contents of the
    /// file to be attached.
    var attachBinaryData: Data? {
        return getProperty(id: .tagAttachDataBinary)
    }
    
    /// [MS-OXCMSG] 2.2.2.8 PidTagAttachDataObject Property
    /// Type: PtypObject ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachDataObject property ([MS-OXPROPS] section 2.590) contains the binary
    /// representation of the Attachment object in an application-specific format.
    var attachDataObject: Data? {
        return getProperty(id: .tagAttachDataBinary)
    }
    
    /// [MS-OXCMSG] 2.2.2.9 PidTagAttachMethod Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachMethod property ([MS-OXPROPS] section 2.601) represents the way the contents
    /// of an attachment are accessed. This property is set to one of the following values.
    /// [MS-OXOCAL] 2.2.10.1.3 PidTagAttachMethod Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagAttachMethod property ([MS-OXCMSG] section 2.2.2.9) MUST be
    /// afEmbeddedMessage (0x00000005), which indicates that the exception data in the
    /// PidTagAttachDataObject property ([MS-OXCMSG] section 2.2.2.8) is an Embedded Message
    /// object.
    /// [MS-OXORSS] 2.2.3.1 Attachment Objects
    /// [MS-OXORSS] 2.2.3.1.1 Full Article Attachment Objects
    /// A full article Attachment object contains the contents of the linked document. Its
    /// PidTagAttachMethod property ([MS-OXCMSG] section 2.2.2.9) MUST be set to 0x00000001
    /// (afByValue). The PidLidPostRssItemLink property (section 2.2.1.2) MUST be set to the URL from
    /// which the document was downloaded.
    /// An RSS object MUST NOT have more than one full article Attachment object.
    /// [MS-OXORSS] 2.2.3.1.2 Enclosure Attachment Objects
    /// An enclosure Attachment object contains the contents of an enclosure. For an atom entry, the
    /// enclosure is a file referenced in the href attribute of a link element that has its rel attribute set to
    /// "enclosure". For an RSS item, the enclosure is a file referenced in the enclosure element.
    /// An enclosure Attachment object MUST have the PidTagAttachMethod property ([MS-OXCMSG]
    /// section 2.2.2.9) set to 0x00000001 (afByValue). The PidLidPostRssItemLink property (section
    /// 2.2.1.2) MUST be set to the URL from which the enclosure was downloaded.
    /// [MS-OXORSS] 2.2.3.1.3 Other Attachment Objects
    /// An RSS object MUST NOT have Attachment objects other than full article Attachment objects and
    /// enclosure Attachment objects.
    var attachMethod: AttachMethod? {
        guard let rawValue: UInt32 = getProperty(id: .tagAttachMethod) else {
            return nil
        }
        
        return AttachMethod(rawValue: rawValue)
    }
    
    /// [MS-OXCMSG] 2.2.2.10 PidTagAttachLongFilename Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachLongFilename property ([MS-OXPROPS] section 2.595) contains the full file name
    /// and extension of the Attachment object.
    /// [MS-OXOUM] 2.2.3.1.2 Message Content
    /// As specified in [MS-OXORMMS], a rights-managed e-mail message consists of a wrapper message
    /// with the original e-mail content encrypted as a BLOB in an attachment. The attachment has the
    /// following properties:
    ///  PidTagAttachLongFilename ([MS-OXCMSG] section 2.2.2.11): MUST be set to
    /// "message.rpmsg".
    var attachLongFilename: String? {
        return getProperty(id: .tagAttachLongFilename)
    }
    
    /// [MS-OXCMSG] 2.2.2.11 PidTagAttachFilename Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachFilename property ([MS-OXPROPS] section 2.593) contains the 8.3 name of the
    /// value of the PidTagAttachLongFilename property (section 2.2.2.10).
    var attachFilename: String? {
        return getProperty(id: .tagAttachFilename)
    }
        
    var name: String? {
        return displayName ?? attachLongFilename ?? attachFilename
    }
    
    /// [MS-OXCMSG] 2.2.2.12 PidTagAttachExtension Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachExtension property ([MS-OXPROPS] section 2.592) contains a file name extension
    /// that indicates the document type of an attachment.
    var attachExtension: String? {
        return getProperty(id: .tagAttachExtension)
    }
    
    /// [MS-OXCMSG] 2.2.2.13 PidTagAttachLongPathname Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachLongPathname property ([MS-OXPROPS] section 2.596) contains the fully
    /// qualified path and file name with extension.
    /// that indicates the document type of an attachment.
    var attachLongPathname: String? {
        return getProperty(id: .tagAttachLongPathname)
    }
    
    /// [MS-OXCMSG] 2.2.2.14 PidTagAttachPathname Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachPathname property ([MS-OXPROPS] section 2.604) contains the 8.3 name of the
    /// value of the PidTagAttachLongPathname property (section 2.2.2.13).
    var attachPathname: String? {
        return getProperty(id: .tagAttachPathname)
    }
    
    /// [MS-OXCMSG] 2.2.2.15 PidTagAttachTag Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachTag property ([MS-OXPROPS] section 2.609) contains the identifier information for
    /// the application that supplied the Attachment object's data. This property can be left unset; if set, it
    /// MUST be one of the following.
    /// Definition Data Comments
    /// TNEF {0x2A,86,48,86,F7,14,03,0A,01} The TNEF format is specified in [MS-OXTNEF].
    /// afStorage {0x2A,86,48,86,F7,14,03,0A,03,02,01} Data is in an application-specific format.
    /// MIME {0x2A,86,48,86,F7,14,03,0A,04} Conversion between Message object and MIME formats
    /// is specified in [MS-OXCMAIL].
    var attachTag: Data? {
        return getProperty(id: .tagAttachTag)
    }
    
    /// [MS-OXCMSG] 2.2.2.16 PidTagRenderingPosition Property
    /// Type: PtypInteger32, unsigned ([MS-OXCDATA] section 2.11.1)
    /// The PidTagRenderingPosition property ([MS-OXPROPS] section 2.914) represents an offset, in
    /// rendered characters, to use when rendering an attachment within the main message text.
    /// The values specify a relative ordering of the rendered attachment in the text. If a message has three
    /// attachments with values of 200, 100, and 500 for the PidTagRenderingPosition property, these
    /// will be rendered in the same order as if the attachments had the values 2, 1, and 5. A detailed
    /// example of this property is provided in [MS-OXRTFEX] section 3.2.
    /// The value 0xFFFFFFFF indicates a hidden attachment that is not to be rendered in the main text.
    var renderingPosition: UInt32? {
        return getProperty(id: .tagRenderingPosition)
    }
    
    /// [MS-OXCMSG] 2.2.2.17 PidTagAttachRendering Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachRendering property ([MS-OXPROPS] section 2.607) contains a Windows Metafile
    /// Format (WMF) metafile as specified in [MS-WMF] for the Attachment object.
    var attachRendering: Data? {
        return getProperty(id: .tagAttachRendering)
    }

    /// [MS-OXCMSG] 2.2.2.18 PidTagAttachFlags Property
    /// Type: PtypInteger32, as a bit field ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachFlags property ([MS-OXPROPS] section 2.594) indicates which body formats might
    /// reference this attachment when rendering data. This property contains a bitwise OR of zero or more of
    /// the following flags. If this property is absent or its value is 0x00000000, the attachment is available
    /// to be rendered in any format.
    var attachFlags: AttachFlags? {
        guard let rawValue: UInt32 = getProperty(id: .tagAttachFlags) else {
            return nil
        }
        
        return AttachFlags(rawValue: rawValue)
    }
    
    /// [MS-OXCMSG] 2.2.2.19 PidTagAttachTransportName Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachTransportName property ([MS-OXPROPS] section 2.610) contains the name of an
    /// attachment file, modified so that it can be correlated with TNEF messages, as specified in [MSOXTNEF].
    var transportName: String? {
        return getProperty(id: .tagAttachTransportName)
    }
    
    /// [MS-OXCMSG] 2.2.2.20 PidTagAttachEncoding Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachEncoding property ([MS-OXPROPS] section 2.591) contains encoding information
    /// about the Attachment object. If the attachment is in MacBinary format, this property is set to
    /// "{0x2A,86,48,86,F7,14,03,0B,01}"; otherwise, it is unset. This property is used to indicate that the
    /// attachment content, which is the value of the PidTagAttachDataBinary property (section 2.2.2.7),
    /// MUST be encoded in the MacBinary format, as specified in [MS-OXCMAIL]. Clients SHOULD<10>
    /// correctly detect MacBinary I, MacBinaryII, and MacBinary III formats.
    var encoding: Data? {
        return getProperty(id: .tagAttachEncoding)
    }
    
    /// [MS-OXCMSG] 2.2.2.21 PidTagAttachAdditionalInformation Property
    /// Type: PtypBinary ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachAdditionalInformation property ([MS-OXPROPS] section 2.585) MUST be set to
    /// an empty string if the PidTagAttachEncoding property (section 2.2.2.20) is unset. If the
    /// PidTagAttachEncoding property is set, the PidTagAttachAdditionalInformation property MUST
    /// be set to a string of the format ":CREA:TYPE", where ":CREA" is the four-letter Macintosh file creator
    /// code, and ":TYPE" is a four-letter Macintosh type code.
    var additionalInformation: Data? {
        return getProperty(id: .tagAttachAdditionalInformation)
    }
    
    /// [MS-OXCMSG] 2.2.2.22 PidTagAttachmentLinkId Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachmentLinkId property ([MS-OXPROPS] section 2.600) is the type of Message
    /// object to which this attachment is linked. This property MUST be set to 0x00000000 unless
    /// overridden by other protocols that extend the Message and Attachment Object Protocol as noted in
    /// section 1.4.
    var linkId: UInt32? {
        return getProperty(id: .tagAttachmentLinkId)
    }
    
    /// [MS-OXCMSG] 2.2.2.23 PidTagAttachmentFlags Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachmentFlags property ([MS-OXPROPS] section 2.598) indicates special handling for
    /// this Attachment object. This property MUST be set to 0x00000000 unless overridden by other
    /// protocols that extend the Message and Attachment Object Protocol as noted in section 1.4
    /// [MS-OXOCAL] 2.2.10.1 Exception Attachment Object
    /// The Exception Attachment object MUST have the properties listed in sections 2.2.10.1.1 through
    /// 2.2.10.1.6.
    /// [MS-OXOCAL] 2.2.10.1.2 PidTagAttachmentFlags Property
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagAttachmentFlags property ([MS-OXCMSG] section 2.2.2.23) MUST include
    /// the afException flag (0x00000002).
    var attachmentFlags: UInt32? {
        return getProperty(id: .tagAttachmentFlags)
    }
    
    /// [MS-OXCMSG] 2.2.2.24 PidTagAttachmentHidden Property
    /// Type: PtypBoolean ([MS-OXCDATA] section 2.11.1)
    /// The PidTagAttachmentHidden property ([MS-OXPROPS] section 2.599) is set to TRUE (0x01) if this
    /// Attachment object is hidden from the end user.
    /// [MS-OXOCAL] 2.2.10.1 Exception Attachment Object
    /// The Exception Attachment object MUST have the properties listed in sections 2.2.10.1.1 through
    /// 2.2.10.1.6.
    /// [MS-OXOCAL] 2.2.10.1.1 PidTagAttachmentHidden Property
    /// Type: PtypBoolean ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagAttachmentHidden property ([MS-OXCMSG] section 2.2.2.24) MUST be
    /// TRUE.
    var hidden: Bool {
        // Attachments are not hidden by default
        guard let hidden: Bool = getProperty(id: .tagAttachmentHidden) else {
            return false
        }
        
        return hidden
    }
    
    /// [MS-OXCMSG] 2.2.2.25 PidTagTextAttachmentCharset Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidTagTextAttachmentCharset property ([MS-OXPROPS] section 2.1044) specifies the
    /// character set of messages for messages with a text body. This property corresponds to the charset
    /// parameter of the Content-Type header, as specified in [MS-OXCMAIL] section 2.2.3.4.1.2.
    var textAttachmentCharset: String? {
        return getProperty(id: .tagTextAttachmentCharset)
    }
    
    /// [MS-OXCMSG] 2.2.2.26 PidNameAttachmentProviderType
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The PidNameAttachmentProviderType property ([MS-OXPROPS] section 2.372) contains the type
    /// of web service manipulating the attachment.
    /// Value Description
    /// OneDrivePro The web reference attachment belongs to a OneDrive for Business
    /// service.
    /// OneDriveConsumer The web reference attachment belongs to a OneDrive Consumer
    /// service.
    var attachmentProviderType: String? {
        return getProperty(name: .nameAttachmentProviderType)
    }
    
    /// [MS-OXCMSG] 2.2.2.27 PidNameAttachmentOriginalPermissionType
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidNameAttachmentOriginalPermissionType property ([MS-OXPROPS] section 2.370)
    /// contains the original permission type data associated with a web reference attachment.
    var attachmentOriginalPermissionType: AttachmentPermissionType? {
        guard let rawValue: UInt32 = getProperty(name: .nameAttachmentOriginalPermissionType) else {
            return nil
        }
        
        return AttachmentPermissionType(rawValue: rawValue)
    }
    
    /// [MS-OXCMSG] 2.2.2.28 PidNameAttachmentPermissionType
    /// Type: PtypInteger32 ([MS-OXCDATA] section 2.11.1)
    /// The PidNameAttachmentPermissionType property ([MS-OXPROPS] section 2.371) contains the
    /// permission type data associated with a web reference attachment.
    var attachmentPermissionType: AttachmentPermissionType? {
        guard let rawValue: UInt32 = getProperty(name: .nameAttachmentPermissionType) else {
            return nil
        }
        
        return AttachmentPermissionType(rawValue: rawValue)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachMimeTag ([MS-OXPROPS]
    /// section 2.602)
    /// The Content-Type header.
    /// [MS-OXORMMS] 2.2.3.2 PidTagAttachMimeTag Property
    /// Type: PtypString ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagAttachMimeTag property ([MS-OXCMSG] section 2.2.2.29) for a rightsmanaged email message MUST be set to "application/x-microsoft-rpmsg-message".
    /// [MS-OXOUM] 2.2.3.1.2 Message Content
    /// As specified in [MS-OXORMMS], a rights-managed e-mail message consists of a wrapper message
    /// with the original e-mail content encrypted as a BLOB in an attachment. The attachment has the
    /// following properties:
    ///  PidTagAttachMimeTag ([MS-OXCMSG] section 2.2.2.29): MUST be set to "application/xmicrosoft-rpmsg-message".
    var attachMimeTag: String? {
        return getProperty(id: .tagAttachMimeTag)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachContentId ([MS-OXPROPS]
    /// section 2.587)
    /// A content identifier unique to this Message object that matches a corresponding "cid:"
    /// URI scheme reference in the HTML body of the Message object.
    var attachContentId: String? {
        return getProperty(id: .tagAttachContentId)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachContentLocation ([MSOXPROPS] section 2.588)
    /// A relative or full URI that matches a corresponding reference in the HTML body of
    /// the Message object.
    var attachContentLocation: String? {
        return getProperty(id: .tagAttachContentLocation)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachContentBase ([MS-OXPROPS]
    /// section 2.586)
    /// The base of a relative URI. MUST be set if the PidTagAttachContentLocation property contains a relative URI.
    var attachContentBase: String? {
        return getProperty(id: .tagAttachContentBase)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachPayloadClass ([MS-OXPROPS]
    /// section 2.605)
    /// The class name of an object that can display the contents of the message.
    var attachPayloadClass: String? {
        return getProperty(id: .tagAttachPayloadClass)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidTagAttachPayloadProviderGuidString
    /// ([MS-OXPROPS] section 2.606)
    /// The GUID of the software application that can display the contents of the message.
    var attachPayloadProviderGuidString: String? {
        return getProperty(id: .tagAttachPayloadProviderGuidString)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidNameAttachmentMacContentType ([MSOXPROPS] section 2.368)
    /// The Content-Type header of the Macintosh attachment.
    var attachmentMacContentType: String? {
        return getProperty(name: .nameAttachmentMacContentType)
    }

    /// [MS-OXCMSG] 2.2.2.29 MIME Properties
    /// The following properties contain MIME information and can be left unset. For details about MIME
    /// specifications, see [RFC2045]. For the specification on mapping these properties, see [MS-OXCMAIL].
    /// The types in the following table are specified in [MS-OXCDATA] section 2.11.1.
    /// PidNameAttachmentMacContentType ([MSOXPROPS] section 2.368)
    /// The headers and resource fork data associated with the Macintosh attachment.
    var attachmentMacInfo: Data? {
        return getProperty(name: .nameAttachmentMacInfo)
    }
    
    /// [MS-OXOCAL] 2.2.10.1.4 PidTagExceptionStartTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagExceptionStartTime property ([MS-OXPROPS] section 2.686) indicates the
    /// start date and time of the exception in the local time zone of the computer when the exception is
    /// created.
    /// This property is informational and cannot be relied on for critical information because if a user changes
    /// the client computer's time zone after this property is written, the value of this property will no longer
    /// match what is expected by the client.
    var exceptionStartTime: Date? {
        return getProperty(id: .tagExceptionStartTime)
    }
    
    /// [MS-OXOCAL] 2.2.10.1.5 PidTagExceptionEndTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagExceptionEndTime property ([MS-OXPROPS] section 2.684) indicates the
    /// end date and time of the exception in the local time zone of the computer when the exception is
    /// created.
    /// This property is informational and cannot be relied on for critical information because if a user changes
    /// the client computer's time zone after this property is written, the value of this property will no longer
    /// match what is expected by the client.
    var exceptionEndTime: Date? {
        return getProperty(id: .tagExceptionEndTime)
    }
    
    /// [MS-OXOCAL] 2.2.10.1.6 PidTagExceptionReplaceTime Property
    /// Type: PtypTime ([MS-OXCDATA] section 2.11.1)
    /// The value of the PidTagExceptionReplaceTime property ([MS-OXPROPS] section 2.685) indicates
    /// the original date and time at which the instance in the recurrence pattern would have occurred if it
    /// were not an exception. This value is specified in UTC.<33>
    var exceptionReplaceTime: Date? {
        return getProperty(id: .tagExceptionReplaceTime)
    }
}
