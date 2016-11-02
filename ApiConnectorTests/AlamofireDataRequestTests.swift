//
//  AlamofireDataRequestTests.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import XCTest
import Alamofire
@testable import ApiConnector

class AlamofireDataRequestTests: XCTestCase {
    
    func testRequestCreation() {
        let dataRequest = Alamofire.DataRequest.dataRequest(with: TestData.request)
        XCTAssertEqual(dataRequest.request, TestData.request)
    }
    
}
