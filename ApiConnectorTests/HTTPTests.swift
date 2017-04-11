//
//  TestHTTP.swift
//  ApiConnector
//
//  Created by Mirellys on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector


class HTTPTests: XCTestCase {
    
    func testHTTKeyPHashable() {
        XCTAssertEqual(HTTP.Header.Key.accept, "Accept")
        XCTAssertNotEqual(HTTP.Header.Key.accept, "Accept-Language")
        XCTAssertEqual(HTTP.Header.Key.accept.hashValue, HTTP.Header.Key("Accept").hashValue)
    }
    
    func testHTTPValueHashable() {
        XCTAssertEqual(HTTP.Header.Value.applicationJson, "application/json")
        XCTAssertNotEqual(HTTP.Header.Value.applicationJson, "application/javascript")
        XCTAssertEqual(HTTP.Header.Value.applicationJson.hashValue, HTTP.Header.Value("application/json").hashValue)
    }
    
    func testHTTPToString() {
        let headers: HTTP.Headers = [.accept: .applicationJson,
                                     .acceptLanguage: .language_en_EN,
                                     .contentType: nil]
        let result = [HTTP.Header.Key.accept.rawValue: HTTP.Header.Value.applicationJson.rawValue,
                      HTTP.Header.Key.acceptLanguage.rawValue: HTTP.Header.Value.language_en_EN.rawValue]
         XCTAssertEqual(result, HTTP.Header.toStringKeys(headers: headers))
    }
    
    func testHTTPHeadersStringLiteral(){
        XCTAssertEqual(HTTP.Header.Key(unicodeScalarLiteral: "김").rawValue, "김")
        XCTAssertEqual(HTTP.Header.Key(extendedGraphemeClusterLiteral: "\u{00032}\u{00032}").rawValue, "22")
        XCTAssertEqual(HTTP.Header.Value(unicodeScalarLiteral: "김").rawValue, "김")
        XCTAssertEqual(HTTP.Header.Value(extendedGraphemeClusterLiteral: "\u{00032}\u{00032}").rawValue, "22")
    }
}
