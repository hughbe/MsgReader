//
//  PropertyEntryFlags.swift
//
//
//  Created by Hugh Bellamy on 21/09/2020.
//

import Swift

/// Flags (4 bytes): Flags giving context to the property. Possible values for this field are given in the following table. Any bitwise combination of the flags is valid.
internal struct PropertyEntryFlags: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    /// If this flag is set for a property, that property MUST NOT be deleted from the .msg file (irrespective of which storage it is contained in)
    /// and implementations MUST return an error if any attempt is made to do so. This flag is set in circumstances where the implementation
    /// depends on that property always being present in the .msg file once it is written there.
    static let mandatory = PropertyEntryFlags(rawValue: 0x00000001)
    
    /// If this flag is not set on a property, that property MUST NOT be read from the .msg file and implementations MUST return an error if any
    /// attempt is made to read it. This flag is set on all properties unless there is an implementation-specific reason to prevent a property
    /// from being read from the .msg file.
    static let readable = PropertyEntryFlags(rawValue: 0x00000002)
    
    /// If this flag is not set on a property, that property MUST NOT be modified or deleted and implementations MUST return an error if
    /// any attempt is made to do so. This flag is set in circumstances where the implementation depends on the properties being writable.
    static let writable = PropertyEntryFlags(rawValue: 0x00000004)

    static let all: PropertyEntryFlags = [.mandatory, .readable, .writable]
}
