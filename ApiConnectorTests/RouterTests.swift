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
        XCTAssertEqual(Router.me.url(for: .test).absoluteString, "http://test.com/me")
        XCTAssertEqual(Router.pictures.url(for: .test).absoluteString, "http://test.com/pictures")
        XCTAssertEqual(Router.pictures.url(for: .localhost).absoluteString, "http://localhost:8080/pictures")
        XCTAssertEqual(Router.posts(userId: "myId").url(for: .test).absoluteString, "http://test.com/posts?userId=myId")
    }
    
    func testRouterMethod() {
        XCTAssertEqual(Router.me.method, .get)
    }
    
}
