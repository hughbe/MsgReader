//
//  Helpers.swift
//  
//
//  Created by Hugh Bellamy on 16/10/2020.
//

import Foundation
import MAPI
@testable import MsgReader

public func getData(name: String) throws -> Data {
    let url = URL(forResource: name, withExtension: "msg")
    return try Data(contentsOf: url)
}

public func testDump(message: MsgFile) {
    func dumpEmbeddedMessage(accessor: String, message: EmbeddedMessage) -> String {
        var s = ""
        
        s += propertiesTestString(accessor: accessor, properties: message.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)

        s += "XCTAssertEqual(\(message.recipients.count), \(accessor).recipients.count)\n"
        for (offset, recipient) in message.recipients.enumerated() {
            s += propertiesTestString(accessor: "\(accessor).recipients[\(offset)]", properties: recipient.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)
        }

        s += "XCTAssertEqual(\(message.attachments.count), \(accessor).attachments.count)\n"
        for (offset, attachment) in message.attachments.enumerated() {
            s += propertiesTestString(accessor: "\(accessor).attachments[\(offset)]", properties: attachment.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)
        }

        return s
    }

    var s = ""
    
    s += propertiesTestString(accessor: "msg", properties: message.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)

    s += "XCTAssertEqual(\(message.recipients.count), msg.recipients.count)\n"
    for (offset, recipient) in message.recipients.enumerated() {
        s += propertiesTestString(accessor: "msg.recipients[\(offset)]", properties: recipient.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)
    }

    s += "XCTAssertEqual(\(message.attachments.count), msg.attachments.count)\n"
    for (offset, attachment) in message.attachments.enumerated() {
        s += propertiesTestString(accessor: "msg.attachments[\(offset)]", properties: attachment.properties.getAllProperties(), namedProperties: message.namedProperties?.properties)
        
        if let embeddedMessage = attachment.embeddedMessage {
            s += dumpEmbeddedMessage(accessor: "msg.attachments[\(offset)].embeddedMessage!", message: embeddedMessage)
        }
    }

    print(s.trimmingCharacters(in: CharacterSet.newlines))
}
