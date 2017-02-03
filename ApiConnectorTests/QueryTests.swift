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
    
    func testQueryCreation() {
        let query = Query(("userId", "123"), ("today", nil))
        let items: [URLQueryItem] = [.init(name: "userId", value: "123"), .init(name: "today", value: nil)]
        XCTAssertEqual(query.queryItems, items)
    }
    
}
