//
//  TestConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import SwiftyJSON
import Alamofire
import ApiConnector

class TestConnectorTests: XCTestCase {
    
    func testResponseProvider() {
        struct TestProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                return .failure(TestsError.defaultError)
            }
        }
        
        let code = 200
        let successResponse = TestProvider.successResponse(for: TestData.request, with: 200, jsonObject: TestData.defaultPost)
        
        if case let .success(resultRequest, response, data) = successResponse {
            XCTAssertEqual(resultRequest, TestData.request)
            XCTAssertEqual(data.flatMap({ JSON(data: $0) }), TestData.defaultPost.jsonValue)
            XCTAssertEqual(response.statusCode, code)
        } else {
            XCTFail()
        }
    }
    
    func testSuccessfulProviderResponse() {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                return successResponse(for: request, with: 200, data: TestData.testBodyData)
            }
        }

        let connector = TestConnector<SuccessResponseProvider>.dataRequest(with: TestData.request)
        let responseExpectation = expectation(description: "SuccessMockResponse")

        _ = connector.validate().responseData { data, error in
            XCTAssertNil(error)
            XCTAssertEqual(data, TestData.testBodyData)
            responseExpectation.fulfill()
        }

        waitForExpectations(timeout: 2.0)
    }
    
    func testFailProviderResponse() {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                return successResponse(for: request, with: 401, data: TestData.testBodyData)
            }
        }
        
        let connector = TestConnector<SuccessResponseProvider>.dataRequest(with: TestData.request)
        let responseExpectation = expectation(description: "SuccessMockResponse")
        
        _ = connector.validate().responseData { data, error in
            if let error = error as? AFError, case let .responseValidationFailed(reason: reason) = error, case let .unacceptableStatusCode(code: code) = reason {
                XCTAssertEqual(code, 401)
            } else {
                XCTFail()
            }
            XCTAssertNil(data)
            responseExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0)
    }
    
}
