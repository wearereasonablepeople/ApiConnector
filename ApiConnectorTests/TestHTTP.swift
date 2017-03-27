//
//  TestHTTP.swift
//  ApiConnector
//
//  Created by Mirellys on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class TestHTTP: XCTestCase {
    
    func testHTTPHashable() {
        XCTAssertEqual(HTTP.Header.Key.accept, "Accept")
        XCTAssertNotEqual(HTTP.Header.Key.accept, "Accept-Language")
        XCTAssertEqual(HTTP.Header.Key.accept.hashValue, HTTP.Header.Key("Accept").hashValue)
    }
    
    func testHTTHeader() {
        let headers: [HTTP.Header.Key: String] = [.accept: "application/json" ,
                                                  .acceptLanguage: "en-US",
                                                  .contentType: "charset=utf-8"]
        let result = [HTTP.Header.Key.accept.rawValue: "application/json" ,
                      HTTP.Header.Key.acceptLanguage.rawValue: "en-US",
                      HTTP.Header.Key.contentType.rawValue: "charset=utf-8"]
        XCTAssertEqual(headers.count, result.count)
        XCTAssertEqual(headers[.accept], result[HTTP.Header.Key.accept.rawValue])
        XCTAssertEqual(headers[.acceptLanguage], result[HTTP.Header.Key.acceptLanguage.rawValue])
        XCTAssertEqual(headers[.contentType], result[HTTP.Header.Key.contentType.rawValue])
        
    }
    
    func testHTTPToString() {
        let headers: [HTTP.Header.Key: String] = [.accept: "application/json" ,
                                                  .acceptLanguage: "en-US",
                                                  .contentType: "charset=utf-8"]
        var result: [String: String]
        result = HTTP.Header.toStringKeys(headers: headers)
        XCTAssertEqual(headers.count, result.count)
        XCTAssertEqual(headers[.accept], result[HTTP.Header.Key.accept.rawValue])
        XCTAssertEqual(headers[.acceptLanguage], result[HTTP.Header.Key.acceptLanguage.rawValue])
        XCTAssertEqual(headers[.contentType], result[HTTP.Header.Key.contentType.rawValue])
    }
}
