//
//  HTTP.swift
//  ApiConnector
//
//  Created by Mirellys on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public protocol HTTPHeaderType: RawRepresentable, ExpressibleByStringLiteral, Hashable {
    init(rawValue: String)
    init(_ rawValue: String)
    var rawValue: String { get }
}

public extension HTTPHeaderType {
    public init(_ rawValue: String) {
        self.init(rawValue: rawValue)
    }
    
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String){
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

public struct HTTP {
    public typealias Headers = [Header.Key: Header.Value?]
    
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
        public struct Key : HTTPHeaderType {
            public let rawValue: String
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
        }
        
        public struct Value : HTTPHeaderType {
            public let rawValue: String
            
            public init(rawValue: String) {
                self.rawValue = rawValue
            }
            
            public static func optionalValue(_ rawValue: String?) -> HTTP.Header.Value? {
                return rawValue.map { HTTP.Header.Value($0) }
            }
        }
        
        public static func toStringKeys(headers: Headers) -> [String : String] {
            var result = [String : String]()
            for (key, value) in headers {
                result[key.rawValue] = value?.rawValue
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
    public static let token  = HTTP.Header.Key("Token")
}

public extension HTTP.Header.Value {
    public static let applicationJson: HTTP.Header.Value = "application/json"
    public static let applicationJavascript = HTTP.Header.Value("application/javascript")
    public static let applicationXml = HTTP.Header.Value("application/xml")
    public static let applicationZip  = HTTP.Header.Value("application/zip")
    public static let languageEnUS = HTTP.Header.Value("en-US")
    public static let charsetUtf8 = HTTP.Header.Value("charset=utf-8")
    public static let noCache = HTTP.Header.Value("no-cache")
}
