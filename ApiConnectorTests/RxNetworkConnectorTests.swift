//
//  RxNetworkConnectorTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class RxNetworkConnectorTests: XCTestCase {
    
    func testApiObservableSuccess() {
        let successExpectation = expectation(description: "ApiObservableExpectation")
        let observable = TestApiConnection<SuccessProvider>(environment: .test)
            .requestObservable(with: nil as Data?, at: .me)
            .subscribe(onNext: { response in
                XCTAssertEqual(response.data, TestData.testBodyData)
                successExpectation.fulfill()
            })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
    func testApiObservableFailure() {
        let successExpectation = expectation(description: "ApiObservableExpectation")
        let observable = TestApiConnection<SuccessProvider>()
            .requestObservable(with: nil as Data?, at: .me, { _ in
                throw TestsError.defaultError
            }).subscribe(onError: { error in
                XCTAssertEqual(error as? TestsError, .defaultError)
                successExpectation.fulfill()
            })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
}
