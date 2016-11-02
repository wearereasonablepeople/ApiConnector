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
    
    func testReponseModel() {
        typealias Connection = TestApiConnection<PostResponseProvider>
        
        struct PostResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                let data = try? TestData.defaultPost.jsonValue.rawData()
                return successResponse(for: request, with: 200, data: data)
            }
        }
        
        let postObservable: Observable<Post> = Connection(environment: .test).requestData(with: nil as Data?, at: .pictures, headers: nil).modelObservable()
        
        let postExpactation = expectation(description: "PostExpectation")
        let disposable = postObservable.subscribe(onNext: { post in
            XCTAssertEqual(post, TestData.defaultPost)
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
    
    func testReponseArrayOfModels() {
        typealias Connection = TestApiConnection<PostResponseProvider>
        
        struct PostResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                let data = try? [TestData.defaultPost].jsonRepresantable.jsonValue.rawData()
                return successResponse(for: request, with: 200, data: data)
            }
        }
        
        let postObservable: Observable<[Post]> = Connection(environment: .test).requestData(with: nil as Data?, at: .pictures, headers: nil).modelObservable()
        
        let postExpactation = expectation(description: "PostExpectation")
        let disposable = postObservable.subscribe(onNext: { post in
            XCTAssertEqual(post, [TestData.defaultPost])
            postExpactation.fulfill()
        })
        
        waitForExpectations(timeout: 2)
        disposable.dispose()
    }
}
