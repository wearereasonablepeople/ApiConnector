//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector
import SwiftyJSONModel

enum Environment: ApiEnvironment {
    case test
    case localhost
    case staging
    
    var value: URLEnvironment {
        switch self {
        case .test: return .init("test.com")
        case .localhost: return .localhost(8080)
        case .staging: return .init(IP(8,8,8,8), 3000)
        }
    }
}

enum Router {
    case me, pictures
    case posts(userId: String)
}

extension Router: ApiRouter {
    typealias EnvironmentType = Environment
    
    var defaultPath: RoutePath { return ["api", "model"] }
    
    var route: URLRoute {
        switch self {
        case .me: return .init(["me"])
        case .pictures: return .init( ["pictures"])
        case let .posts(userId: userId):
            return .init(["posts"], ("userId", userId))
        }
    }
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

struct SuccessProvider: ResponseProvider {
    static func response(for request: URLRequest) -> TestConnectorResponse {
        return successResponse(for: request, with: 200, data: TestData.testBodyData)
    }
}

typealias TestApiConnection<Provider: ResponseProvider> = NetworkConnector<TestConnector<Provider>, Router>

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
    
    var dictValue: [PropertyKey : JSONRepresentable?] {
        return [.title: title, .description: description]
    }
}

extension Post: Equatable {}
func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.title == rhs.title && lhs.description == rhs.description
}
