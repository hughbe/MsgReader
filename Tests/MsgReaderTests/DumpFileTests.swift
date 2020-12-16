import XCTest
import MAPI
@testable import MsgReader

final class DumpFileTests: XCTestCase {
    func testDumpFile() throws {
        for name in [
            /* aquasync/ruby_msg */
            "contact-plain",
            "contact-unicode",
            "ruby_msg_note",
            "qwerty_1-orig",
            "qwerty_2-with_custom_properties",
            "qwerty_3",
            "Swetlana Novikova",
            "test_Blammo",
            
            /* aribeth97/PSTar */
            "1",
            "2",
            "export",
            
            /* aspose-email/Aspose.Email-for-Java */
            "AddVotingButtonToExistingMessage",
            "attachment_out",
            "Bertha A. Buell",
            "Christoffer van de Meeberg",
            "EmbededMessageAsAttachment",
            "Invitation",
            "MAPITask",
            "Margaret J. Tolle",
            "Matthew R. Wilcox",
            "message",
            "message1",
            "messageMapi",
            "Note",
            "Sebastian Wright",
            "Wichert Kroos",
            "WithEmbeddedMsg",
            
            /* bbottema/outlook-message-parser */
            "attachment with a bracket in the name",
            "chinese message",
            "S_MIME test message encrypted",
            "S_MIME test message signed & encrypted",
            "S_MIME test message signed",
            "simple email with TO and CC_multiple",
            "simple reply with CC",
            "testgetmsgAttch",
            "tst_unicode",
            
            /* ctabin/jotlmsg */
            "attachment",
            "base-message",
            "many-attachments",
            "many-recipients",
            "sent",
            "simple",
            "simple2",
            "with-attachments-2",
            "without-attachment",
            
            /* FreiraumIO/msgreader */
            "msgreader_test",
            
            /* grych/msgviewer */
            "Test Message",
            
            /* HamiltonInsurance/outlook_msg */
            "No attachment",
            "outlook_msg_Test",
            
            /* hrbrmstr/msgxtractr */
            "TestMessage-ansi",
            "TestMessage-default",
            "TestMessage-unicode",
            "unicode",
            
            /* hfig/MAPI */
            "sample",
            "Swetlana",
            
            /* HiraokaHyperTools/msgreader */
            "msgInMsg",
            "msgInMsgInMsg",
            "Subject",
            "test",
            "test1",
            "test2",
            
            /* hughbe */
            "Appointment",
            "Contact Group",
            "contact",
            "custom",
            "custom3",
            "discussion",
            "event",
            "FlaggedMessage",
            "Journal Entry",
            "Meeting",
            "multiple",
            "MVP",
            "Recurring Appointment",
            "Sample Contact",
            "Simple Note",
            "Simple Task",
            "SimpleMessage",
            "task",
            
            /* lolo101/MsgViewer */
            "MsgViewer_test",
            "testxxx",
            "testyyyy",
            "20190502_094613_1556783173.7038",
            "Ab auf die Piste!",
            "cyril",
            "danke",
            "Diesel 50%OFF - Calvin Klein - Banana Republic - Moda Hoje",
            "Dipl  Ing  Alexander Oberzalek  Geschenkideen aus Elektronik & Foto bis 70% reduziert - Amazon de",
            "fox",
            "gutschein",
            "ltur ",
            "Newsletter für UCI KINOWELT Annenhof (Graz)",
            "Re   Foxgui-users  FOX DEVELOPMENT 1 7 25 released!",
            "rtf",
            "Unbenannt",
            "welcome_test",
            "welcome_test2",
            "welcome_test3",
            
            /* microsoft/compoundfilereader */
            "a test email message",
            
            /* mvz/email-outlook-message-perl */
            "charset",
            "gpg_signed",
            "plain_jpeg_attached",
            "plain_uc_unsent",
            "plain_uc_wc_unsent",
            "plain_unsent",
            
            /* nickrussler/email-to-pdf-converter */
            "testHtml",
            
            /* online */
            "online_example",
            "online_sample",
            
            /* Sicos1977/MSGReader */
            "EmailWith2Attachments",
            "EmailWithAttachments",
            "HtmlSampleEmail",
            "HtmlSampleEmailWithAttachment",
            "RtfSampleEmail",
            "RtfSampleEmailWithAttachment",
            "TxtSampleEmail",
            "TxtSampleEmailWithAttachment",
            
            /* TeamMsgExtractor/msg-extractor */
            "strangeDate",
            "msg-extractor_unicode",
            
            /* TheConfusedCat/msgparser */
            "attachments",
            "embedded image",
            "forward with attachments and embedded images",
            "HTML mail with replyto and attachment and embedded image",
            "nested simple mail",
            "plain chain",
            "simple sent",
            "unsent draft",
            
            /* vikramarsid/msg_parser */
            "complete",
            "other",
            "outer",
        ] {
            let data = try getData(name: name)
            let msg = try MsgFile(data: data)
            testDump(message: msg)
        }
    }
}
