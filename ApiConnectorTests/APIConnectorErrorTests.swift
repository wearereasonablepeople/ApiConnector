//
//  APIConnectorTests.swift
//  ApiConnector
//
//  Created by Mirellys on 29/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import ApiConnector

class APIConnectorErrorTests: XCTestCase {
    
    func testAPIConnectors() {
        let noResponse = APIConnectorError.NoResponse
        let invalidRequest = APIConnectorError.InvalidRequest
        let unacceptableStatusCode = APIConnectorError.UnacceptableStatusCode(400)
        
        XCTAssertEqual(APIConnectorError.NoResponse, noResponse)
        XCTAssertEqual(APIConnectorError.InvalidRequest, invalidRequest)
        XCTAssertEqual(APIConnectorError.UnacceptableStatusCode(400), unacceptableStatusCode)
        XCTAssertNotEqual(noResponse, invalidRequest)
    }
    
    func testAPIConnectorsDescriptors()
    {
        XCTAssertEqual(APIConnectorError.NoResponse.description, "No response")
        XCTAssertEqual(APIConnectorError.UnacceptableStatusCode(400).description, "Status unnacceptable with code: 400")
        XCTAssertEqual(APIConnectorError.InvalidRequest.description, "Invalid request")
    }
}
