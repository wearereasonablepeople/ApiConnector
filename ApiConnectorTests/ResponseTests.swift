//
//  ResponseTests.swift
//  ApiConnector
//
//  Created by Oleksii on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class ResponseTests: XCTestCase {
    
    func testReponseJSONInitializable() {
        let json = TestData.defaultPost.jsonValue
        
        XCTAssertEqual(Response(for: TestData.request, with: 200, jsonObject: json).data, try? json.rawData())
    }
    
}
