//
//  ApiConnectionTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
@testable import ApiConnector

class ApiConnectionTests: XCTestCase {
    
    func testRequestCreation() {
        let request = TestApiConnection<SuccessProvider>(environment: .test).requestData(with: TestData.testBodyData, at: .me, headers: nil).request
        var expectedRequest = try! URLRequest(url: Router.me.url(for: .test), method: Router.me.method, headers: nil)
        expectedRequest.httpBody = TestData.testBodyData
        
        XCTAssertEqual(request, expectedRequest)
    }
    
}
