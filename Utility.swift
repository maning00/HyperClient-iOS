//
//  Utility.swift
//  HyperClient
//
//  Created by Niko Ma on 3/29/22.
//

import Foundation
import CryptoKit


extension StringProtocol {
    var hexa: [UInt8] {
        var startIndex = self.startIndex
        return (0..<count/2).compactMap { _ in
            let endIndex = index(after: startIndex)
            defer { startIndex = index(after: endIndex) }
            return UInt8(self[startIndex...endIndex], radix: 16)
        }
    }
}

extension DataProtocol {
    var data: Data { .init(self) }
    var hexa: String { map { .init(format: "%02x", $0) }.joined() }
}


struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}

func hashFunc(x: String, y: String) -> String{
    let con = min(x,y) + max(x,y)
    
    let hashed = SHA256.hash(data: con.hexa)
    return hashed.compactMap { String(format: "%02hhx", $0) }.joined()
}
