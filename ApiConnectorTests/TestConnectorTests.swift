//
//  TestConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import RxSwift
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
    
    func testsSuccessfulPostProviderResponse() {
        struct SuccessPostResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                let post: Post = TestData.defaultPost
                return .just(Response(for: request, with: 200, jsonObject: post))
            }
        }
        
        let connector = TestConnector<SuccessPostResponseProvider>.requestObservable(with: TestData.request)
            .map { try JSONDecoder().decode(Post.self, from: $0.data) }
        let responseExpectation = expectation(description: "SuccessPostMockResponse")

        let observable = connector.subscribe(onNext: { post in
            XCTAssertEqual(post, TestData.defaultPost)
            responseExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
}
