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
    
    func testAPIConnectorErrorEquatable() {
        let noResponse = APIConnectorError.noResponse
        let invalidRequest = APIConnectorError.invalidRequest
        let unacceptableStatusCode = APIConnectorError.unacceptableStatusCode(400)
        
        XCTAssertEqual(APIConnectorError.noResponse, noResponse)
        XCTAssertEqual(APIConnectorError.invalidRequest, invalidRequest)
        XCTAssertEqual(APIConnectorError.unacceptableStatusCode(400), unacceptableStatusCode)
        XCTAssertNotEqual(noResponse, invalidRequest)
    }
    
    func testAPIConnectorErrorDescriptors()
    {
        XCTAssertEqual(APIConnectorError.noResponse.description, "No response")
        XCTAssertEqual(APIConnectorError.unacceptableStatusCode(400).description, "Status unnacceptable with code: 400")
        XCTAssertEqual(APIConnectorError.invalidRequest.description, "Invalid request")
    }
}
