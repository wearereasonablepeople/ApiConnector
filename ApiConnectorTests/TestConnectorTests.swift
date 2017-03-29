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
import ApiConnector

class TestConnectorTests: XCTestCase {
    
    func testSuccessfulProviderResponse() {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return .just(Response(for: request, with: 200, data: TestData.testBodyData))
            }
        }
        
        let connector = TestConnector<SuccessResponseProvider>.requestObservable(with: TestData.request).map { $0.data }
        let responseExpectation = expectation(description: "SuccessMockResponse")

        let observable = connector.subscribe(onNext: { data in
            XCTAssertEqual(data, TestData.testBodyData)
            responseExpectation.fulfill()
        })

        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
}
