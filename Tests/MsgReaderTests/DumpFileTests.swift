import XCTest
import MAPI
@testable import MsgReader

final class DumpFileTests: XCTestCase {
    func testDumpFile() throws {
        for name in [
            "grych/msgviewer/Test Message",
            "HamiltonInsurance/outlook_msg/No attachment",
            "HamiltonInsurance/outlook_msg/Test",
            "aribeth97/PSTar/1",
            "aribeth97/PSTar/2",
            "aribeth97/PSTar/export",
            "ctabin/jotlmsg/attachment",
            "ctabin/jotlmsg/base-message",
            "ctabin/jotlmsg/many-attachments",
            "ctabin/jotlmsg/many-recipients",
            "ctabin/jotlmsg/sent",
            "ctabin/jotlmsg/simple",
            "ctabin/jotlmsg/simple2",
            "ctabin/jotlmsg/with-attachments-2",
            "ctabin/jotlmsg/without-attachment",
            "FreiraumIO/msgreader/test",
            "hrbrmstr/msgxtractr/TestMessage-ansi",
            "hrbrmstr/msgxtractr/TestMessage-default",
            "hrbrmstr/msgxtractr/TestMessage-unicode",
            "hrbrmstr/msgxtractr/unicode",
            "hfig/MAPI/sample",
            "hfig/MAPI/Swetlana",
            "aquasync/ruby-msg/contact-plain",
            "aquasync/ruby-msg/contact-unicode",
            "aquasync/ruby-msg/note",
            "aquasync/ruby-msg/qwerty_1-orig",
            "aquasync/ruby-msg/qwerty_2-with_custom_properties",
            "aquasync/ruby-msg/qwerty_3",
            "aquasync/ruby-msg/Swetlana Novikova",
            "aquasync/ruby-msg/test_Blammo",
            "bbottema/outlook-message-parser/attachment with a bracket in the name",
            "bbottema/outlook-message-parser/attachments",
            "bbottema/outlook-message-parser/chinese message",
            "bbottema/outlook-message-parser/embedded image",
            "bbottema/outlook-message-parser/forward with attachments and embedded images",
            "bbottema/outlook-message-parser/HTML mail with replyto and attachment and embedded image",
            "bbottema/outlook-message-parser/nested simple mail",
            "bbottema/outlook-message-parser/plain chain",
            "bbottema/outlook-message-parser/S_MIME test message encrypted",
            "bbottema/outlook-message-parser/S_MIME test message signed & encrypted",
            "bbottema/outlook-message-parser/S_MIME test message signed",
            "bbottema/outlook-message-parser/simple email with TO and CC_multiple",
            "bbottema/outlook-message-parser/simple reply with CC",
            "bbottema/outlook-message-parser/simple sent",
            "bbottema/outlook-message-parser/testgetmsgAttch",
            "bbottema/outlook-message-parser/tst_unicode",
            "bbottema/outlook-message-parser/unsent draft",
            "mvz/email-outlook-message-perl/charset",
            "mvz/email-outlook-message-perl/gpg_signed",
            "mvz/email-outlook-message-perl/plain_jpeg_attached",
            "mvz/email-outlook-message-perl/plain_uc_unsent",
            "mvz/email-outlook-message-perl/plain_uc_wc_unsent",
            "mvz/email-outlook-message-perl/plain_unsent",
            "nickrussler/email-to-pdf-converter/testHtml",
            "HiraokaHyperTools/msgreader/msgInMsg",
            "HiraokaHyperTools/msgreader/msgInMsgInMsg",
            "HiraokaHyperTools/msgreader/Subject",
            "HiraokaHyperTools/msgreader/test",
            "HiraokaHyperTools/msgreader/test1",
            "HiraokaHyperTools/msgreader/test2",
            "TeamMsgExtractor/msg-extractor/strangeDate",
            "TeamMsgExtractor/msg-extractor/unicode",
            "lolo101/MsgViewer/embedded/test",
            "lolo101/MsgViewer/embedded/testxxx",
            "lolo101/MsgViewer/embedded/testyyyy",
            "lolo101/MsgViewer/20190502_094613_1556783173.7038",
            "lolo101/MsgViewer/Ab auf die Piste!",
            "lolo101/MsgViewer/cyril",
            "lolo101/MsgViewer/danke",
            "lolo101/MsgViewer/Diesel 50%OFF - Calvin Klein - Banana Republic - Moda Hoje",
            "lolo101/MsgViewer/Dipl  Ing  Alexander Oberzalek  Geschenkideen aus Elektronik & Foto bis 70% reduziert - Amazon de",
            "lolo101/MsgViewer/fox",
            "lolo101/MsgViewer/gutschein",
            "lolo101/MsgViewer/ltur ",
            "lolo101/MsgViewer/Newsletter für UCI KINOWELT Annenhof (Graz)",
            "lolo101/MsgViewer/Re   Foxgui-users  FOX DEVELOPMENT 1 7 25 released!",
            "lolo101/MsgViewer/rtf",
            "lolo101/MsgViewer/Unbenannt",
            "lolo101/MsgViewer/welcome_test",
            "lolo101/MsgViewer/welcome_test2",
            "lolo101/MsgViewer/welcome_test3",
            "aspose-email/Aspose.Email-for-Java/AddVotingButtonToExistingMessage",
            "aspose-email/Aspose.Email-for-Java/attachment_out",
            "aspose-email/Aspose.Email-for-Java/Bertha A. Buell",
            "aspose-email/Aspose.Email-for-Java/Christoffer van de Meeberg",
            "aspose-email/Aspose.Email-for-Java/EmbededMessageAsAttachment",
            "aspose-email/Aspose.Email-for-Java/Invitation",
            "aspose-email/Aspose.Email-for-Java/MAPITask",
            "aspose-email/Aspose.Email-for-Java/Margaret J. Tolle",
            "aspose-email/Aspose.Email-for-Java/Matthew R. Wilcox",
            "aspose-email/Aspose.Email-for-Java/message",
            "aspose-email/Aspose.Email-for-Java/message1",
            "aspose-email/Aspose.Email-for-Java/messageMapi",
            "aspose-email/Aspose.Email-for-Java/Note",
            "aspose-email/Aspose.Email-for-Java/Sebastian Wright",
            "aspose-email/Aspose.Email-for-Java/Wichert Kroos",
            "aspose-email/Aspose.Email-for-Java/WithEmbeddedMsg",
            "Sicos1977/MSGReader/EmailWith2Attachments",
            "Sicos1977/MSGReader/EmailWithAttachments",
            "Sicos1977/MSGReader/HtmlSampleEmail",
            "Sicos1977/MSGReader/HtmlSampleEmailWithAttachment",
            "Sicos1977/MSGReader/RtfSampleEmail",
            "Sicos1977/MSGReader/RtfSampleEmailWithAttachment",
            "Sicos1977/MSGReader/TxtSampleEmail",
            "Sicos1977/MSGReader/TxtSampleEmailWithAttachment",
        ] {
            let data = try getData(name: name)
            let msg = try MsgFile(data: data)
            testDump(message: msg)
        }
    }
}