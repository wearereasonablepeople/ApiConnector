//
//  ResponseTests.swift
//  ApiConnector
//
//  Created by Oleksii on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import Alamofire
import ApiConnector

class ResponseTests: XCTestCase {
    
    func testResponseValidation() {
        let data = Data()
        XCTAssertThrowsError(try Response(for: TestData.request, with: 400, data: data).validate(Response.defaultValidation)) { error in
            if let error = error as? AFError, case let .responseValidationFailed(reason: reason) = error, case let .unacceptableStatusCode(code: code) = reason {
                XCTAssertEqual(code, 400)
            } else {
                XCTFail()
            }
        }
        XCTAssertNotNil(try? Response(for: TestData.request, with: 200, data: data).validate(Response.defaultValidation))
    }
    
}
