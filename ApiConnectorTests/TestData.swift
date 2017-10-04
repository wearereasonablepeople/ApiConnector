//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector
import RxSwift
import SweetRouter

struct Api: EndpointType {
    enum Environment: EnvironmentType {
        case test
        case localhost
        case staging
        
        var value: URL.Env {
            switch self {
            case .test: return .init("test.com")
            case .localhost: return .localhost(8080)
            case .staging: return .init(IP(8,8,8,8), 3000)
            }
        }
    }
    
    enum Route: RouteType {
        case me, pictures
        case posts(userId: String)
        
        var route: URL.Route {
            switch self {
            case .me: return .init(at: "me")
            case .pictures: return .init(at: "pictures")
            case let .posts(userId: userId):
                return URL.Route(at: "posts").query(("userId", userId))
            }
        }
    }
    
    static let current = Environment.localhost
}

struct TestData {
    static let url = URL(string: "https://google.com")!
    static let request = URLRequest(url: url)
    
    static let testBodyData = "TestString".data(using: .utf8)!
    static let defaultPost = Post(title: "testTitle", description: "TestDescription")
}

enum TestsError: Error {
    case defaultError
}

struct SuccessProvider: ResponseProvider {
    static func response(for request: URLRequest) -> Observable<Response> {
        return .just(Response(for: request, with: 200, data: TestData.testBodyData))
    }
}

typealias TestApiConnection<Provider: ResponseProvider> = NetworkConnector<TestConnector<Provider>, Api>

struct Post: Codable {
    let title: String
    let description: String
}

extension Post: Equatable {}
func == (lhs: Post, rhs: Post) -> Bool {
    return lhs.title == rhs.title && lhs.description == rhs.description
}
