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
    
    func testHTTPHashable() {
        XCTAssertEqual(HTTP.Header.Key.accept, "Accept")
        XCTAssertNotEqual(HTTP.Header.Key.accept, "Accept-Language")
        XCTAssertEqual(HTTP.Header.Key.accept.hashValue, HTTP.Header.Key("Accept").hashValue)
    }
    
    func testHTTPToString() {
        let headers: HTTP.Headers = [.accept: "application/json" ,
                                     .acceptLanguage: "en-US",
                                     .contentType: "charset=utf-8"]
        let result = [HTTP.Header.Key.accept.rawValue: "application/json" ,
                      HTTP.Header.Key.acceptLanguage.rawValue: "en-US",
                      HTTP.Header.Key.contentType.rawValue: "charset=utf-8"]
         XCTAssertEqual(result, HTTP.Header.toStringKeys(headers: headers))
    }
    
    func testHTTPHeadersStringLiteral(){
        XCTAssertEqual(HTTP.Header.Key(unicodeScalarLiteral: "김").rawValue, "김")
        XCTAssertEqual(HTTP.Header.Key(extendedGraphemeClusterLiteral: "\u{00032}\u{00032}").rawValue, "22")
    }
}
