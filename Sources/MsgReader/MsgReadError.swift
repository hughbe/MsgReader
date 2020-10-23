//
//  MsgReadError.swift
//  
//
//  Created by Hugh Bellamy on 01/10/2020.
//

public enum MsgReadError : Error {
    case missingStream(name: String)
    case corrupted
}
