//
//  Router.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public protocol ApiRouter {
    associatedtype EnvironmentType: ApiEnvironment
    
    var path: RoutePath { get }
    var defaultPath: RoutePath { get }
    var query: Query? { get }
    var method: HTTPMethod { get }
    
    func url(for environment: EnvironmentType) -> URL
}

public extension ApiRouter {
    public var query: Query? { return nil }
    public var method: HTTPMethod { return .get }
    public var defaultPath: RoutePath { return [] }
    
    public func url(for environment: EnvironmentType) -> URL {
        var components = URLComponents()
        let environment = environment.value
        
        components.scheme = environment.scheme.rawValue
        components.host = environment.host
        components.port = environment.port
        components.path = defaultPath.with(path).pathValue
        components.queryItems = query?.queryItems
        
        guard let url = components.url else {
            fatalError("URL components are not valid")
        }
        
        return url
    }
}

public extension ApiRouter where Self: RawRepresentable, Self.RawValue == String {
    public var path: RoutePath {
        return .init(rawValue)
    }
}
