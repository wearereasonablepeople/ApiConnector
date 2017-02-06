//
//  URLRouteTests.swift
//  ApiConnector
//
//  Created by Oleksii on 06/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class URLRouteTests: XCTestCase {
    
    func testUrlRouteEquatable() {
        XCTAssertEqual(URLRoute(["myPath"], ("user", nil)), URLRoute(.get, ["myPath"], ("user", nil)))
    }
    
}
