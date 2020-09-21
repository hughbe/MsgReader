//
//  PropertiesHeader.swift
//
//
//  Created by Hugh Bellamy on 21/09/2020.
//

import DataStream

internal protocol PropertiesHeader {
    init(dataStream: inout DataStream) throws
}
