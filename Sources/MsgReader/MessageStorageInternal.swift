//
//  MessageStorageInternal.swift
//
//
//  Created by Hugh Bellamy on 21/09/2020.
//

import CompoundFileReader
import Foundation
import MAPI

internal protocol MessageStorageInternal: MessageStorage {
    associatedtype HeaderType: PropertiesHeader

    var properties: PropertyStream<HeaderType> { get }
    var namedProperties: NamedPropertyMapping? { get }
}

extension MessageStorageInternal {
    public func getProperty<T>(id: UInt16) -> T? {
        return properties.getValue(id: id) as? T
    }
    
    public func getProperty<T>(name: NamedProperty) -> T? {
        guard let id = namedProperties?.dictionary[name] else {
            return nil
        }
        
        return getProperty(id: 0x8000 + id)
    }
}
