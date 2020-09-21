import XCTest
import CompressedRtf
import MAPI
@testable import MsgReader

final class TaskTests: XCTestCase {
    public func testSimpleTask() throws {
        let data = try getData(name: "Tasks/Simple Task")
        let msg = try MsgFile(data: data)

        XCTAssertEqual(.normal, msg.priority!)
        XCTAssertEqual("", msg.taskRole!)
        XCTAssertEqual("", msg.displayBcc!)
        XCTAssertEqual(0, msg.reminderDelta!)
        XCTAssertEqual("hughbellars@gmail.com", msg.lastModifierName!)
        XCTAssertEqual(2, msg.taskVersion!)
        XCTAssertFalse(msg.taskNoCompute!)
        XCTAssertEqual(.notAssigned, msg.taskOwnership!)
        XCTAssertEqual(0x01, msg.conversationIndex!.header.reserved)
        XCTAssertEqual(0xD6, msg.conversationIndex!.header.currentFileTime.0)
        XCTAssertEqual(0x85, msg.conversationIndex!.header.currentFileTime.1)
        XCTAssertEqual(0x16, msg.conversationIndex!.header.currentFileTime.2)
        XCTAssertEqual(0x53, msg.conversationIndex!.header.currentFileTime.3)
        XCTAssertEqual(0x57, msg.conversationIndex!.header.currentFileTime.4)
        XCTAssertEqual(UUID(uuidString: "F8D90074-0449-42EA-95E3-7D3592F9E6B8"), msg.conversationIndex!.header.guid)
        XCTAssertEqual(0, msg.conversationIndex!.responseLevels.count)
        XCTAssertEqual("", msg.displayTo!)
        XCTAssertEqual(1599483398.0, msg.toDoOrdinalDate!.timeIntervalSince1970)
        XCTAssertEqual("00000002\u{01}hughbellars@gmail.com", msg.internetAccountStamp!)
        XCTAssertEqual(1599483431.0, msg.lastModificationTime!.timeIntervalSince1970)
        XCTAssertEqual(0, msg.taskEstimatedEffort!)
        XCTAssertEqual("SMTP", (msg.getProperty(id: .tagSenderAddressType) as String?)!)
        XCTAssertEqual([.unicodeOk, StoreSupportMask(rawValue: 0x00000E79)], msg.storeSupportMask)
        XCTAssertEqual(1599483398.0, msg.messageDeliveryTime!.timeIntervalSince1970)
        XCTAssertEqual("hughbellars@gmail.com", msg.sentRepresentingName!)
        XCTAssertTrue(msg.alternateRecipientAllowed!)
        XCTAssertEqual("16.0", msg.currentVersionName!)
        XCTAssertEqual(UUID(uuidString: "504346B0-3346-4246-AC66-333EA06D2732"), msg.changeKey!.namespaceGuid)
        XCTAssertEqual([0x00, 0x00, 0x98, 0x5F], msg.changeKey!.localId)
        XCTAssertEqual("", msg.subjectPrefix!)
        XCTAssertEqual(.normal, msg.importance!)
        XCTAssertEqual(0x00000000, (msg.sentRepresentingEntryId as? OneOffEntryID)!.flags)
        XCTAssertEqual(UUID(uuidString: "812B1FA4-BEA3-1019-9D6E-00DD010F5402"), (msg.sentRepresentingEntryId as? OneOffEntryID)!.providerUid)
        XCTAssertEqual(0x0000, (msg.sentRepresentingEntryId as? OneOffEntryID)!.version)
        XCTAssertEqual([.unicode], (msg.sentRepresentingEntryId as? OneOffEntryID)!.entryFlags)
        XCTAssertEqual("hughbellars@gmail.com", (msg.sentRepresentingEntryId as? OneOffEntryID)!.displayName)
        XCTAssertEqual("SMTP", (msg.sentRepresentingEntryId as? OneOffEntryID)!.addressType)
        XCTAssertEqual("hughbellars@gmail.com", (msg.sentRepresentingEntryId as? OneOffEntryID)!.emailAddress)
        XCTAssertNotNil(msg.rtfCompressed)
        XCTAssertEqual([.coerceToInbox, .openForContextMenu], msg.sideEffects)
        XCTAssertEqual([.read], msg.access)
        XCTAssertEqual(0x00000000, (msg.senderEntryId as? OneOffEntryID)!.flags)
        XCTAssertEqual(UUID(uuidString: "812B1FA4-BEA3-1019-9D6E-00DD010F5402"), (msg.senderEntryId as? OneOffEntryID)!.providerUid)
        XCTAssertEqual(0x0000, (msg.senderEntryId as? OneOffEntryID)!.version)
        XCTAssertEqual([.unicode], (msg.senderEntryId as? OneOffEntryID)!.entryFlags)
        XCTAssertEqual("hughbellars@gmail.com", (msg.senderEntryId as? OneOffEntryID)!.displayName)
        XCTAssertEqual("SMTP", (msg.senderEntryId as? OneOffEntryID)!.addressType)
        XCTAssertEqual("hughbellars@gmail.com", (msg.senderEntryId as? OneOffEntryID)!.emailAddress)
        XCTAssertEqual("", msg.taskAssigner!)
        XCTAssertEqual("Simple Task", msg.conversationTopic!)
        XCTAssertEqual("Simple Task", msg.subject!)
        XCTAssertTrue(msg.rtfInSync!)
        XCTAssertFalse(msg.readReceiptRequested!)
        XCTAssertEqual("hughbellars@gmail.com", msg.internetAccountName!)
        XCTAssertEqual("\r\n", msg.body!)
        XCTAssertEqual("hughbellars@gmail.com", msg.taskOwner!)
        XCTAssertEqual(1, msg.predecessorChangeList!.values.count)
        XCTAssertEqual(UUID(uuidString: "504346B0-3346-4246-AC66-333EA06D2732"), msg.predecessorChangeList!.values[0].namespaceGuid)
        XCTAssertEqual([0x00, 0x00, 0x98, 0x5F], msg.predecessorChangeList!.values[0].localId)
        XCTAssertFalse(msg.taskComplete!)
        XCTAssertEqual("", msg.displayCc!)
        XCTAssertFalse(msg.deleteAfterSubmit!)
        XCTAssertFalse(msg.`private`!)
        XCTAssertEqual(28591, msg.internetCodepage!)
        XCTAssertEqual([0x50, 0xDA, 0xF8, 0x91, 0x7E, 0x19, 0x7E, 0x43, 0x91, 0x6F, 0xFC, 0x14, 0x3D, 0x2D, 0xA7, 0x06], [UInt8](msg.searchKey!))
        XCTAssertFalse(msg.teamTask!)
        XCTAssertEqual([0x53, 0x4D, 0x54, 0x50, 0x3A, 0x48, 0x55, 0x47, 0x48, 0x42, 0x45, 0x4C, 0x4C, 0x41, 0x52, 0x53, 0x40, 0x47, 0x4D, 0x41, 0x49, 0x4C, 0x2E, 0x43, 0x4F, 0x4D, 0x00], [UInt8](msg.sentRepresentingSearchKey!))
        XCTAssertEqual(1033, msg.messageLocaleId!)
        XCTAssertFalse(msg.originatorDeliveryReportRequested!)
        XCTAssertEqual("Simple Task", msg.normalizedSubject!)
        XCTAssertEqual(.undefined, msg.nativeBody!)
        XCTAssertEqual("hughbellars@gmail.com", msg.senderEmailAddress!)
        XCTAssertEqual(.normal, msg.sensitivity!)
        XCTAssertFalse(msg.agingDontAgeMe!)
        XCTAssertEqual(1599483398.0, msg.validFlagStringProof!.timeIntervalSince1970)
        XCTAssertEqual(4294965296, msg.taskOrdinal!)
        XCTAssertEqual(1033, (msg.getProperty(set: .common, lid: 0x000085EB) as UInt32?)!)
        XCTAssertEqual([0x53, 0x4D, 0x54, 0x50, 0x3A, 0x48, 0x55, 0x47, 0x48, 0x42, 0x45, 0x4C, 0x4C, 0x41, 0x52, 0x53, 0x40, 0x47, 0x4D, 0x41, 0x49, 0x4C, 0x2E, 0x43, 0x4F, 0x4D, 0x00], [UInt8](msg.senderSearchKey!))
        XCTAssertEqual(.notStarted, msg.taskStatus!)
        XCTAssertEqual(1599483431.0, msg.creationTime!.timeIntervalSince1970)
        XCTAssertEqual([.read], msg.messageFlags)
        XCTAssertEqual(.readOnly, msg.accessLevel!)
        XCTAssertEqual("hughbellars@gmail.com", msg.sentRepresentingEmailAddress!)
        XCTAssertEqual(1599483398.0, msg.clientSubmitTime!.timeIntervalSince1970)
        XCTAssertEqual(0, msg.taskActualEffort!)
        XCTAssertEqual("SMTP", msg.sentRepresentingAddressType!)
        XCTAssertEqual("5555555", msg.toDoSubOrdinal!)
        XCTAssertEqual("IPM.Task", msg.messageClass!)
        XCTAssertEqual(1613029, msg.currentVersion!)
        XCTAssertFalse(msg.taskFRecurring!)
        XCTAssertEqual(.notAssigned, msg.taskMode!)
        XCTAssertEqual(.notAssigned, msg.taskState!)
        XCTAssertFalse(msg.taskFFixOffline!)
        XCTAssertEqual(0.0, msg.percentComplete!)
        XCTAssertEqual(.notAssigned, msg.taskAcceptanceState!)
        XCTAssertEqual(0x00000500, msg.iconIndex!)
        XCTAssertEqual([0x85, 0x14, 0x66, 0xDD, 0x5D, 0x73, 0xA9, 0x4A, 0x80, 0x0E, 0xC9, 0x6E, 0x50, 0xB5, 0x8F, 0xE6], [UInt8]((msg.getProperty(set: .common, name: "InTransitMessageCorrelator") as Data?)!))
        XCTAssertEqual("hughbellars@gmail.com", (msg.getProperty(id: .tagSenderName) as String?)!)

        XCTAssertEqual(0, msg.recipients.count)
        XCTAssertEqual(0, msg.attachments.count)
    }

    static var allTests = [
        ("testSimpleTask", testSimpleTask)
    ]
}