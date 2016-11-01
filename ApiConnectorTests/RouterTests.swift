//
//  RouterTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest

class RouterTests: XCTestCase {
    
    func testRouterUrlCreation() {
        XCTAssertEqual(Router.me.url(for: .test).absoluteString, "http://test.com:80/me")
        XCTAssertEqual(Router.pictures.url(for: .test).absoluteString, "http://test.com:80/pictures")
    }
    
}