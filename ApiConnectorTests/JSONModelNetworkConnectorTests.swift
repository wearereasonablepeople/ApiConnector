//
//  JSONModelNetworkConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector
import SwiftyJSON
import RxSwift

class JSONModelNetworkConnectorTests: XCTestCase {
    typealias Connection = TestApiConnection<PostResponseProvider>
    
    struct PostResponseProvider: ResponseProvider {
        static func response(for request: URLRequest) -> TestConnectorResponse {
            return successResponse(for: request, with: 200, data: request.httpBody)
        }
    }
    
    func testModelRequest() {
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let post = TestData.defaultPost
        let postObservable: Observable<Post> = Connection(environment: .test).requestObservable(with: post, at: .pictures)
        let disposable = postObservable.subscribe(onNext: { newPost in
            XCTAssertEqual(post, newPost)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testArrayOfModelsRequest() {
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let posts = [TestData.defaultPost]
        let postObservable: Observable<[Post]> = Connection(environment: .test).requestObservable(with: posts.jsonRepresantable, at: .pictures)
        let disposable = postObservable.subscribe(onNext: { newPosts in
            XCTAssertEqual(posts, newPosts)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testVoidObservable() {
        let successExpactation = expectation(description: "SuccessVoidExpactation")
        let voidObservable: Observable<Void> = TestApiConnection<SuccessProvider>(environment: .test).requestObservable(at: .pictures)
        let disposable = voidObservable.subscribe(onNext: {
            successExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
}
