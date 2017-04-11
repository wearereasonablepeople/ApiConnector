//
//  HTTP.swift
//  ApiConnector
//
//  Created by Mirellys on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct HTTP {
    public typealias Headers = [Header.Key: Header.Value]
    
    public enum Method: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
    
    public struct Header {
        public struct Key : RawRepresentable {
            public let rawValue: String
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public init(_ rawValue: String) {
                self.init(rawValue: rawValue)
            }
        }
        
        public struct Value : RawRepresentable {
            public let rawValue: String
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public init(_ rawValue: String) {
                self.init(rawValue: rawValue)
            }
        }
        
        public static func toStringKeys(headers: [Key : Value]) -> [String : String] {
            var result = [String : String]()
            for (key, value) in headers {
                result[key.rawValue] = value.rawValue
            }
            return result
        }
    }
}

public extension HTTP.Header.Key {
    public static let accept: HTTP.Header.Key = "Accept"
    public static let acceptLanguage = HTTP.Header.Key("Accept-Language")
    public static let authorization = HTTP.Header.Key("Authorization")
    public static let cacheControl  = HTTP.Header.Key("Cache-Control")
    public static let contentType  = HTTP.Header.Key("Content-Type")
}

extension HTTP.Header.Key : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String){
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension HTTP.Header.Key: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func == (lhs: HTTP.Header.Key, rhs: HTTP.Header.Key) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public extension HTTP.Header.Value {
    public static let applicationJson: HTTP.Header.Value = "application/json"
    public static let applicationJavascript = HTTP.Header.Value("application/javascript")
    public static let applicationXml = HTTP.Header.Value("application/xml")
    public static let applicationZip  = HTTP.Header.Value("application/zip")
    public static let language_en_EN = HTTP.Header.Value("en-US")
    public static let charset_utf_8 = HTTP.Header.Value("charset=utf-8")
}

extension HTTP.Header.Value : ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String){
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}

extension HTTP.Header.Value: Hashable {
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func == (lhs: HTTP.Header.Value, rhs: HTTP.Header.Value) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

