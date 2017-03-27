//
//  TestConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import RxSwift
import SwiftyJSON
import Alamofire
import ApiConnector

class TestConnectorTests: XCTestCase {
    
    func testSuccessfulProviderResponse() {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return .just(Response(for: request, with: 200, data: TestData.testBodyData))
            }
        }
        
        let connector = TestConnector<SuccessResponseProvider>.requestObservable(with: TestData.request, nil).map { $0.data }
        let responseExpectation = expectation(description: "SuccessMockResponse")

        let observable = connector.subscribe(onNext: { data in
            XCTAssertEqual(data, TestData.testBodyData)
            responseExpectation.fulfill()
        })

        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
    func testFailProviderResponse() {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return Observable
                    .just(Response(for: request, with: 401, data: TestData.testBodyData))
                    .delay(2, scheduler: SerialDispatchQueueScheduler(qos: .userInitiated))
            }
        }
        
        let connector = TestConnector<SuccessResponseProvider>.requestObservable(with: TestData.request, nil).map { $0.data }
        let responseExpectation = expectation(description: "SuccessMockResponse")
        
        let observable = connector.subscribe(onError: { error in
            if let error = error as? AFError, case let .responseValidationFailed(reason: reason) = error, case let .unacceptableStatusCode(code: code) = reason {
                XCTAssertEqual(code, 401)
            } else {
                XCTFail()
            }
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5.0)
        observable.dispose()
    }
    
}
