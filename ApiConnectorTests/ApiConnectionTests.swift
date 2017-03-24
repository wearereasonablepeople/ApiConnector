//
//  ApiConnectionTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import Alamofire
import SweetRouter
@testable import ApiConnector

fileprivate enum ValidationError: Error {
    case invalidRequest
}

fileprivate class TestValidationConnection<Provider: ResponseProvider>: ApiConnectionType {
    typealias RequestType = TestConnector<Provider>
    typealias RouterType = Api
    
    var defaultValidation: Alamofire.DataRequest.Validation? {
        return { request, response, data in
            return .failure(ValidationError.invalidRequest)
        }
    }
}

class ApiConnectionTests: XCTestCase {
    
    func testRequestCreation() {
        let request = TestApiConnection<SuccessProvider>(environment: .test)
            .request(method:.get, with: TestData.testBodyData, at: .me, headers: nil)
        var expectedRequest = try! URLRequest(url: Router<Api>(.test, at: .me).url, method: .get, headers: nil)
        expectedRequest.httpBody = TestData.testBodyData
        
        XCTAssertEqual(request, expectedRequest)
    }
    
    func testcustomRequestValidation() {
        let connector = TestValidationConnection<SuccessProvider>()
        let responseExpectation = expectation(description: "SuccessMockResponse")
        let request = connector.requestObservable(with: nil as Data?, at: .me, headers: nil)
        
        let observable = request.subscribe(onError: { error in
            if let error = error as? ValidationError {
                XCTAssertEqual(error, .invalidRequest)
            } else {
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
}
