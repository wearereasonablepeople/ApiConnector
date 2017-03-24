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
import SwiftyJSONModel

struct Api: EndpointType {
    enum Environment: EnvironmentType {
        case test
        case localhost
        case staging
        
        var value: URL.Environment {
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
            case .me: return .init(path: ["me"])
            case .pictures: return .init(path: ["pictures"])
            case let .posts(userId: userId):
                return .init(path: ["posts"], query: ("userId", userId))
            }
        }
    }
    
    static let `default` = Environment.localhost
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
    static func response(for request: URLRequest) -> Observable<TestConnectorResponse> {
        return .just(successResponse(for: request, with: 200, data: TestData.testBodyData))
    }
}

typealias TestApiConnection<Provider: ResponseProvider> = NetworkConnector<TestConnector<Provider>, Api>

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
