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
        let observable = TestApiConnection().requestData(with: nil, at: .me, headers: nil).responseObservable().subscribe(onNext: { data in
            XCTAssertEqual(data, TestData.testBodyData)
            successExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 2.0)
        observable.dispose()
    }
    
}
