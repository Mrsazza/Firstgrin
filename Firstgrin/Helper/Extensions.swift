//
//  Extensions.swift
//  Firstgrin
//
//  Created by Sazza on 28/9/22.
//

import Foundation
import SwiftUI
import CommonCrypto

// Extension for finding devices screen size
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

// Extension for finding sha256 from a string
extension String {
    var sha256: String{
                if let stringData = self.data(using: String.Encoding.utf8) {
                    return stringData.sha256()
                }
                return ""
            }
     func validUrl() -> URL? {
        if let encodedUrlString = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let url = URL(string: encodedUrlString)
        {
            return url
        }
        return nil
    }
}

// Extension for finding sha256 from a data
extension Data{
    public func sha256() -> String{
        return hexStringFromData(input: digest(input: self as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        
        return hexString
    }
}

