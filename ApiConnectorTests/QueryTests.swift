//
//  QueryTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class QueryTests: XCTestCase {
    
    func testQueryEquatable() {
        XCTAssertNotEqual(Query(("userId", "123"), ("today", nil)), Query(("userId", "123")))
        XCTAssertNotEqual(Query(("userId", "123"), ("today", nil)), Query(("userId", "123"), ("tomorrow", nil)))
        XCTAssertNotEqual(Query(("userId", "123"), ("today", nil)), Query(("userId", "123"), ("today", "24")))
        XCTAssertEqual(Query(("userId", "123"), ("today", nil)), Query(("userId", "123"), ("today", nil)))
    }
    
    func testQueryCreation() {
        let query = Query(("userId", "123"), ("today", nil))
        let items: [URLQueryItem] = [.init(name: "userId", value: "123"), .init(name: "today", value: nil)]
        XCTAssertEqual(query.queryItems, items)
    }
    
}
