//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector

enum Environment: String, ApiEnvironment {
    case test = "test.com"
}

enum Router: String, ApiRouter {
    typealias EnvironmentType = Environment
    case me, pictures
}

struct TestData {
    static let url = URL(string: "https://google.com")!
    static let request = URLRequest(url: url)
    
    static let testBodyData = "TestString".data(using: .utf8)
}

enum TestsError: Error {
    case defaultError
}

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
