//
//  TestConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class TestConnectorTests: XCTestCase {
    
    func testResponseProvider() {
        struct TestProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                return .failure(TestsError.defaultError)
            }
        }
        
        let code = 200
        let successResponse = TestProvider.successResponse(for: TestData.request, with: 200, data: TestData.testBodyData)
        
        if case let .success(resultRequest, response, data) = successResponse {
            XCTAssertEqual(resultRequest, TestData.request)
            XCTAssertEqual(data, TestData.testBodyData)
            XCTAssertEqual(response.statusCode, code)
        } else {
            XCTFail()
        }
    }
    
    }
    
}
