//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector
import SwiftyJSONModel

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
    static let defaultPost = Post(title: "testTitle", description: "TestDescription")
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

struct Post {
    let title: String
    let description: String
}

extension Post: JSONModelType {
    enum PropertyKey: String {
        case title, description
    }
    
    init(object: JSONObject<PropertyKey>) throws {
        title = try object.value(for: .title)
        description = try object.value(for: .description)
    }
    
    var dictValue: [PropertyKey : JSONRepresentable] {
        return [.title: title, .description: description]
    }
}
