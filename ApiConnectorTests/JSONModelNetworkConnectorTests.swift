//
//  JSONModelNetworkConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector
import RxSwift

class JSONModelNetworkConnectorTests: XCTestCase {
    typealias Connection = TestApiConnection<PostResponseProvider>
    
    struct PostResponseProvider: ResponseProvider {
        static func response(for request: URLRequest) -> Observable<Response> {
            return .just(Response(for: request, with: 200, data: request.httpBody ?? Data()))
        }
    }
    
    func testModelRequestWithEmptyBody() {
        struct PostResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return .just(Response(for: request, with: 200, jsonObject: TestData.defaultPost))
            }
        }
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let post = TestData.defaultPost
        let postObservable: Observable<Post> = TestApiConnection<PostResponseProvider>().requestObservable(at: .pictures).toModel()
        let disposable = postObservable.subscribe(onNext: { newPost in
            XCTAssertEqual(post, newPost)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testArrayModelRequestWithEmptyBody() {
        struct PostResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> Observable<Response> {
                return .just(Response(for: request, with: 200, jsonObject: [TestData.defaultPost]))
            }
        }
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let posts = [TestData.defaultPost]
        let postObservable: Observable<[Post]> = TestApiConnection<PostResponseProvider>().requestObservable(at: .pictures).toModel()
        let disposable = postObservable.subscribe(onNext: { newPost in
            XCTAssertEqual(posts, newPost)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testModelRequest() {
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let post = TestData.defaultPost
        let postObservable: Observable<Post> = Connection().requestObservable(with: post, at: .pictures).toModel()
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
        let postObservable: Observable<[Post]> = Connection().requestObservable(with: posts, at: .pictures).toModel()
        let disposable = postObservable.subscribe(onNext: { newPosts in
            XCTAssertEqual(posts, newPosts)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testJSONObservable() {
        let postExpactation = expectation(description: "ModelRequestExpectation")
        let post = TestData.defaultPost
        let jsonObservable: Observable<Post> = Connection().requestObservable(with: post, at: .pictures).toModel()
        let disposable = jsonObservable.subscribe(onNext: { postJSON in
            XCTAssertEqual(post, postJSON)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testVoidObservable() {
        let successExpactation = expectation(description: "SuccessVoidExpactation")
        let voidObservable = TestApiConnection<SuccessProvider>().requestObservable(at: .pictures).toVoid()
        let disposable = voidObservable.subscribe(onNext: {
            successExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testFailModelEncodeOnRequest() {
        let successExpactation = expectation(description: "Error triggered encoding model.")
        let expectedError = TestsError.defaultError
        let testModel = TestData.testModel
        let modelObservable: Observable<Response> = Connection().requestObservable(method: .post, with: testModel, at: .pictures)
        let disposable = modelObservable.subscribe(onError: { error in
            XCTAssertEqual(expectedError, error as? TestsError)
            successExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }}

