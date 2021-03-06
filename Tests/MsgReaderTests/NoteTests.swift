import XCTest
import CompressedRtf
import MAPI
import WindowsDataTypes
@testable import MsgReader

final class NoteTests: XCTestCase {
    public func testSimpleNote() throws {
        /* hughbe */
        let data = try getData(name: "Simple Note")
        let msg = try MsgFile(data: data)

        XCTAssertEqual("Note", msg.conversationTopic!)
        XCTAssertEqual(1080, msg.noteWidth!)
        XCTAssertEqual(.notAssigned, msg.taskMode!)
        XCTAssertEqual(1613001, msg.currentVersion!)
        XCTAssertEqual("Note", msg.subject!)
        XCTAssertEqual(.normal, msg.sensitivity!)
        XCTAssertTrue(msg.alternateRecipientAllowed!)
        XCTAssertEqual(1595844027.0, msg.messageDeliveryTime!.timeIntervalSince1970)
        XCTAssertEqual("", msg.displayTo!)
        XCTAssertEqual("", msg.displayBcc!)
        XCTAssertEqual([.unicodeOk, StoreSupportMask(rawValue: 0x00000E79)], msg.storeSupportMask)
        XCTAssertFalse(msg.readReceiptRequested!)
        XCTAssertEqual(0x00000303, msg.iconIndex!)
        XCTAssertEqual(.yellow, msg.noteColor!)
        XCTAssertEqual(1033, msg.messageLocaleId!)
        XCTAssertEqual(1, msg.predecessorChangeList!.values.count)
        XCTAssertEqual(GUID(0x504346B0, 0x3346, 0x4246, 0xAC66, 0x333EA06D2732), msg.predecessorChangeList!.values[0].namespaceGuid)
        XCTAssertEqual([0x00, 0x00, 0x18, 0x71], msg.predecessorChangeList!.values[0].localId)
        XCTAssertTrue(msg.rtfInSync!)
        XCTAssertFalse(msg.agingDontAgeMe!)
        XCTAssertNotNil(msg.rtfCompressed)
        XCTAssertEqual(.normal, msg.importance!)
        XCTAssertEqual(.readOnly, msg.accessLevel!)
        XCTAssertEqual(1595844027.0, msg.clientSubmitTime!.timeIntervalSince1970)
        XCTAssertEqual("", msg.displayCc!)
        XCTAssertEqual("Note", msg.normalizedSubject!)
        XCTAssertEqual("16.0", msg.currentVersionName!)
        XCTAssertFalse(msg.`private`!)
        XCTAssertFalse(msg.originatorDeliveryReportRequested!)
        XCTAssertEqual(1599906820.0, msg.creationTime!.timeIntervalSince1970)
        XCTAssertEqual("", msg.subjectPrefix!)
        XCTAssertEqual([0x92, 0x0B, 0x15, 0x7C, 0xAA, 0xEF, 0xFE, 0x43, 0x8F, 0x3B, 0xDB, 0x19, 0x3C, 0x6B, 0xE6, 0xBA], [UInt8](msg.searchKey!))
        XCTAssertEqual(80, msg.noteX!)
        XCTAssertEqual("Note\r\n\r\n", msg.body!)
        XCTAssertEqual("00000002\u{01}hughbellars@gmail.com", msg.internetAccountStamp!)
        XCTAssertEqual("IPM.StickyNote", msg.messageClass!)
        XCTAssertEqual([0xD5, 0x4A, 0x53, 0xCF, 0x81, 0x9A, 0xEE, 0x43, 0x84, 0xA0, 0x74, 0x97, 0x02, 0x05, 0xC9, 0x8E], [UInt8]((msg.getProperty(set: .common, name: "InTransitMessageCorrelator") as Data?)!))
        XCTAssertEqual(774, msg.noteHeight!)
        XCTAssertEqual(0, msg.reminderDelta!)
        XCTAssertEqual(1599906820.0, msg.lastModificationTime!.timeIntervalSince1970)
        XCTAssertEqual(0x01, msg.conversationIndex!.header.reserved)
        XCTAssertEqual(1378870058851.0, msg.conversationIndex!.header.currentFileTime.timeIntervalSince1970)
        XCTAssertEqual(GUID(0x985E10F3, 0x923E, 0x4952, 0x9E23, 0x44B976EE3A99), msg.conversationIndex!.header.guid)
        XCTAssertEqual(0, msg.conversationIndex!.responseLevels.count)
        XCTAssertEqual([.read], msg.messageFlags)
        XCTAssertFalse(msg.deleteAfterSubmit!)
        XCTAssertEqual(1595844027.0, msg.validFlagStringProof!.timeIntervalSince1970)
        XCTAssertEqual(.normal, msg.priority!)
        XCTAssertEqual(GUID(0x504346B0, 0x3346, 0x4246, 0xAC66, 0x333EA06D2732), msg.changeKey!.namespaceGuid)
        XCTAssertEqual([0x00, 0x00, 0x18, 0x71], msg.changeKey!.localId)
        XCTAssertEqual(.undefined, msg.nativeBody!)
        XCTAssertEqual([.read], msg.access)
        XCTAssertEqual("hughbellars@gmail.com", msg.internetAccountName!)
        XCTAssertEqual(80, msg.noteY!)
        XCTAssertEqual("hughbellars@gmail.com", msg.lastModifierName!)
        XCTAssertEqual([.coerceToInbox, .openForContextMenu], msg.sideEffects)

        XCTAssertEqual(0, msg.recipients.count)
        XCTAssertEqual(0, msg.attachments.count)
    }

    static var allTests = [
        ("testSimpleNote", testSimpleNote)
    ]
}
