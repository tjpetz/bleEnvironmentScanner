//
//  DataExtensions.swift
//  bleEnvironmentScanner
//
//  Support for decoding BLE encoded data
//
//  Created by Thomas Petz, Jr. on 10/15/20.
//

import Foundation

extension Data {

    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }

    func getUInt8 () -> UInt8 {
        return [UInt8](self)[0]
    }
    
    func getInt16 () -> Int16 {
        let val = [UInt8](self)
        return Int16(val[1]) << 8 + Int16(val[0])
    }
    
    func getInt32 () -> Int32 {
        let val = [UInt8](self)
        return Int32(val[3]) << 24 + Int32(val[2]) << 16 + Int32(val[1]) << 8 + Int32(val[0])
    }

}

func decodeString(_ data: Data?, defaultValue: String = "") -> String {
    if let val = data {
        return String(data: val, encoding: String.Encoding.utf8) ?? defaultValue
    } else {
        return defaultValue
    }
}
