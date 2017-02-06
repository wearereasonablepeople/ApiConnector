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
    
    var route: URLRoute { get }
    func url(for environment: EnvironmentType) -> URL
}

public extension ApiRouter {
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
