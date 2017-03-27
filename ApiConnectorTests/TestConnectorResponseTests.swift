//
//  TestConnectorResponseTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import Alamofire
import ApiConnector

class TestConnectorResponseTests: XCTestCase {
    
    enum CustomError: Error {
        case testError
    }
    
    let defaultValidation: DataRequest.Validation = { request, response, data -> Request.ValidationResult in
        let code = response.statusCode
        switch code {
        case 200...299:
            return .success
        default:
            let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: code))
            return .failure(error)
        }
    }
    
    func testSuccessfulResponseValidation() {
        let successResponse = self.response(with: 200)
        let response = TestConnectorResponse.success(TestData.request, successResponse, Data())
        if case let .success(resultRequest, resultResponse, data) = response.validate(defaultValidation) {
            XCTAssertEqual(resultRequest, TestData.request)
            XCTAssertEqual(resultResponse, successResponse)
            XCTAssertEqual(data, Data())
        } else {
            XCTFail()
        }
    }
    
    func testFailValidation() {
        let errorCode = 500
        let successResponse = self.response(with: errorCode)
        let response = TestConnectorResponse.success(TestData.request, successResponse, Data())
        if case let .failure(error) = response.validate(defaultValidation) {
            if let error = error as? AFError, case let .responseValidationFailed(reason: reason) = error, case let .unacceptableStatusCode(code: code) = reason {
                XCTAssertEqual(errorCode, code)
            } else {
                XCTFail()
            }
        } else {
            XCTFail()
        }
    }
    
    func testValidationOfAlreadyFailedResponse() {
        let response = TestConnectorResponse.failure(CustomError.testError)
        if case let .failure(error) = response.validate(defaultValidation) {
            XCTAssertEqual(error as? CustomError, .testError)
        }
    }
    
    func testToResponseValue() {
        let response = self.response(with: 200)
        let successResponse = try! TestConnectorResponse.success(TestData.request, response, TestData.testBodyData).toResponse()
        
        XCTAssertEqual(successResponse.data, TestData.testBodyData)
        XCTAssertEqual(successResponse.request, TestData.request)
        XCTAssertEqual(successResponse.response, response)
        
        let errorResponse = TestConnectorResponse.failure(CustomError.testError)
        
        XCTAssertThrowsError(try errorResponse.toResponse()) { error in
            XCTAssertEqual(error as? CustomError, .testError)
        }
    }
    
    func response(with code: Int) -> HTTPURLResponse {
        return HTTPURLResponse(url: TestData.url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
    
}
