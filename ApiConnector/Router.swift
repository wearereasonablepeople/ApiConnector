//
//  Router.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public protocol ApiEnvironment {
    var host: String { get }
    var scheme: Scheme { get }
    var port: Int? { get }
}

public protocol ApiRouter {
    associatedtype EnvironmentType: ApiEnvironment
    
    var path: RoutePath { get }
    var defaultPath: RoutePath { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    
    func url(for environment: EnvironmentType) -> URL
}

public extension ApiEnvironment {
    public var scheme: Scheme { return .http }
    public var port: Int? { return nil }
}

public extension ApiRouter {
    public var queryItems: [URLQueryItem]? { return nil }
    public var method: HTTPMethod { return .get }
    public var defaultPath: RoutePath { return [] }
    
    public func url(for environment: EnvironmentType) -> URL {
        var components = URLComponents()
        
        components.scheme = environment.scheme.rawValue
        components.host = environment.host
        components.port = environment.port
        components.path = defaultPath.with(path).pathValue
        components.queryItems = queryItems
        
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

public extension ApiEnvironment where Self: RawRepresentable, Self.RawValue == String {
    public var host: String {
        return rawValue
    }
}
