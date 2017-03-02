//
//  IPTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class IPTests: XCTestCase {
    
    func testIPInit() {
        XCTAssertEqual(IP(127, 0, 0, 1)?.stringValue, "127.0.0.1")
        XCTAssertNil(IP(999, 0, 0, 1))
        XCTAssertNil(IP(127, 999, 0, 1))
        XCTAssertNil(IP(127, 0, 999, 1))
        XCTAssertNil(IP(127, 0, 0, 999))
    }
    
}
