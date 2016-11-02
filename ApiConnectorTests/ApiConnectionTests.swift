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
    typealias TestRouter = Router
    
    struct TestApiConnection: ApiConnectionType {
        struct SuccessResponseProvider: ResponseProvider {
            static func response(for request: URLRequest) -> TestConnectorResponse {
                return successResponse(for: request, with: 200, data: TestData.testBodyData)
            }
        }
        
        typealias Request = TestConnector<SuccessResponseProvider>
        typealias Router = TestRouter
        
        let environment: Environment = .test
    }
    
    func testRequestCreation() {
        let request = TestApiConnection().requestData(with: TestData.testBodyData, at: .me, headers: nil).request
        var expectedRequest = try! URLRequest(url: Router.me.url(for: .test), method: Router.me.method, headers: nil)
        expectedRequest.httpBody = TestData.testBodyData
        
        XCTAssertEqual(request, expectedRequest)
    }
    
}
