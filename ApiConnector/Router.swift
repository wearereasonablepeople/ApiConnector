//
//  Router.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public struct URLRoute {
    public let method: HTTPMethod
    public let path: RoutePath
    public let query: Query?
    
    public init(_ method: HTTPMethod, _ path: RoutePath, _ query: (name: String, value: QueryItemValue?)...) {
        self.method = method
        self.path = path
        self.query = Query(query)
    }
    
    public init(_ method: HTTPMethod, _ path: RoutePath) {
        self.method = method
        self.path = path
        self.query = nil
    }
    
    public init(_ path: RoutePath, _ query: (name: String, value: QueryItemValue?)...) {
        self.method = .get
        self.path = path
        self.query = Query(query)
    }
    
    public init(_ path: RoutePath) {
        self.init(.get, path)
    }
}

public protocol ApiRouter {
    associatedtype EnvironmentType: ApiEnvironment
    
    var route: URLRoute { get }
    func url(for environment: EnvironmentType) -> URL
}

public extension ApiRouter {
    public var query: Query? { return nil }
    public var method: HTTPMethod { return .get }
    public var defaultPath: RoutePath { return [] }
    
    public func url(for environment: EnvironmentType) -> URL {
        var components = URLComponents()
        let environment = environment.value
        let route = self.route
        
        components.scheme = environment.scheme.rawValue
        components.host = environment.host
        components.port = environment.port
        components.path = defaultPath.with(route.path).pathValue
        components.queryItems = route.query?.queryItems
        
        guard let url = components.url else {
            fatalError("URL components are not valid")
        }
        
        return url
    }
}
