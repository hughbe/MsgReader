import XCTest
import CompressedRtf
import MAPI
@testable import MsgReader

final class MeetingTests: XCTestCase {
    public func testSimpleMeeting() throws {
        let data = try getData(name: "hughbe/Meeting")
        let msg = try MsgFile(data: data)
        
        testDump(message: msg)
    }
    
    static var allTests = [
        ("testSimpleMeeting", testSimpleMeeting)
    ]
}
