import XCTest
import CompressedRtf
import MAPI
@testable import MsgReader

final class PerformanceTests: XCTestCase {
    func testPerformance() throws {
        #if false
        let data = try getData(name: "mattgwwalker.msg-extractor/unicode")
        guard #available(iOS 13.0, *) else {
            return
        }
        
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
            let msg = try! MsgFile(data: data)
            let _ = msg.description
        }
        #endif
    }
    
    static var allTests = [
        ("testPerformance", testPerformance)
    ]
}
