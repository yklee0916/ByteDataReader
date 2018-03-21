//
//  ByteDataReader.swift
//  SafeDriveExample
//
//  Created by younggi.lee on 06/12/2017.
//  Copyright © 2017 YKLEE. All rights reserved.
//

import Foundation

class ByteDataReader: NSObject {
    
    var offset: Int
    var bytes: NSData
    var useN2H: Bool
    
    convenience  init(_ data: Data) {
        self.init(data as NSData)
    }
    
    init(_ data: NSData) {
        offset = 0
        bytes = data
        useN2H = true
    }
    
    func readData(at index: Int) -> NSData {
        if bytes.length < offset {
            return NSData()
        }
        return bytes.subdata(with: NSRange(location: index, length: bytes.length - offset)) as NSData
    }
    
    func readData(length: Int) -> NSData {
        let returnValue = readData(at: offset, length: length)
        offset += length
        return returnValue
    }
    
    func readData(at index: Int, length: Int) -> NSData {
        if bytes.length < index + length {
            return NSData()
        }
        return bytes.subdata(with: NSRange(location: index, length: length)) as NSData
    }
    
    func readUInt8() -> UInt8 {
        let returnValue = readUInt8(at: offset)
        offset = offset + sizeof(UInt8.self)
        return returnValue
    }
    
    func readUInt8(at index: Int) -> UInt8 {
        let size = sizeof(UInt8.self)
        if bytes.length < index + size {
            return 0
        }
        var byte: UInt8 = 0
        bytes.getBytes(&byte, range: NSRange(location: index, length: size))
        return byte
    }
    
    func readUInt16() -> UInt16 {
        let returnValue = readUInt16(at: offset)
        offset = offset + sizeof(UInt16.self)
        return returnValue
    }
    
    func readUInt16(at index: Int) -> UInt16 {
        let size = sizeof(UInt16.self)
        if bytes.length < index + size {
            return 0
        }
        var byte: UInt16 = 0
        bytes.getBytes(&byte, range: NSRange(location: index, length: size))
        return useN2H ? CFSwapInt16(byte) : byte
    }
    
    func readUInt32() -> UInt32 {
        let returnValue = readUInt32(at: offset)
        offset = offset + sizeof(UInt32.self)
        return returnValue
    }
    
    func readUInt32(at index: Int) -> UInt32 {
        let size = sizeof(UInt32.self)
        if bytes.length < index + size {
            return 0
        }
        var byte: UInt32 = 0
        bytes.getBytes(&byte, range: NSRange(location: index, length: size))
        return useN2H ? CFSwapInt32(byte) : byte
    }
    
    func readString(_ length: Int) -> String {
        let returnValue = readString(length, at: offset)
        offset = offset + length
        return returnValue
    }
    
    func readString(_ length:Int, at index: Int) -> String {
        if bytes.length < index + length {
            return ""
        }
        var readBuffer = [CChar](repeating: 0, count: length + 1)
        bytes.getBytes(&readBuffer, range: NSRange(location: index, length: length))
        return String(cString: readBuffer)
    }
    
    func sizeof <T> (_ : T.Type) -> Int {
        return (MemoryLayout<T>.size)
    }
    
    func sizeof <T> (_ : T) -> Int {
        return (MemoryLayout<T>.size)
    }
    
    func sizeof <T> (_ value : [T]) -> Int {
        return (MemoryLayout<T>.size * value.count)
    }
}
