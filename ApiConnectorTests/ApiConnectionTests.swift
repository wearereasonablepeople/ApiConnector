//
//  ApiConnectionTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import SweetRouter
import RxSwift

@testable import ApiConnector

fileprivate class TestValidationConnection<Provider: ResponseProvider>: ApiConnectionType {
    typealias RequestType = TestConnector<Provider>
    typealias RouterType = Api
    
    var defaultValidation: Response.Validation {
        return { response in
            throw APIConnectorError.invalidRequest
        }
    }
}

class ApiConnectionTests: XCTestCase {
    
    func testRequestCreation() {
        let header: HTTP.Headers = [.accept: "application/json"]
        let headerToString = HTTP.Header.toStringKeys(headers: header)
        
        let request = TestApiConnection<SuccessProvider>(environment: .test)
            .request(method:.post, with: TestData.testBodyData, at: .me, headers: header)
        
        var expectedRequest = URLRequest(url: Router<Api>(.test, at: .me).url)
        expectedRequest.httpMethod = HTTP.Method.post.rawValue
        expectedRequest.allHTTPHeaderFields = headerToString
        expectedRequest.httpBody = TestData.testBodyData
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(request.httpMethod, HTTP.Method.post.rawValue)
        XCTAssertEqual(request.allHTTPHeaderFields!, headerToString)
    }
    
    func testcustomRequestValidation() {
        let connector = TestValidationConnection<SuccessProvider>()
        let responseExpectation = expectation(description: "SuccessMockResponse")
        let request = connector.requestObservable(with: nil as Data?, at: .me, headers: nil)
        
        let observable = request.subscribe(onError: { error in
            if let error = error as? APIConnectorError {
                XCTAssertEqual(error, APIConnectorError.invalidRequest)
            } else {
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
    func testValidationError() {
        struct NotFoundProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return Observable
                    .just(Response(for: request, with: 400, data: Data()))
                    .delay(2, scheduler: SerialDispatchQueueScheduler(qos: .userInitiated))
            }
        }
        
        let responseExpectation = expectation(description: "SuccessMockResponse")
        let observable = TestApiConnection<NotFoundProvider>(environment: .test)
            .requestObservable(at: .me)
            .subscribe(onError: { error in
                if let error = error as? APIConnectorError, case let .unacceptableStatusCode(code) = error {
                    XCTAssertEqual(code, 400)
                } else {
                    XCTFail()
                }
                responseExpectation.fulfill()
            })
        
        waitForExpectations(timeout: 5.0)
        observable.dispose()
    }
}
