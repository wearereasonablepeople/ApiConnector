//
//  Router.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

protocol ApiEnvironment {
    var host: String { get }
    var scheme: String { get }
    var port: Int { get }
}

protocol ApiRouter {
    associatedtype Environment: ApiEnvironment
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: HTTPMethod { get }
    
    func url(for environment: Environment) -> URL
}

extension ApiEnvironment {
    var scheme: String { return "http" }
    var port: Int { return 80 }
}

extension ApiRouter {
    var queryItems: [URLQueryItem]? { return nil }
    var method: HTTPMethod { return .get }
    
    func url(for environment: Environment) -> URL {
        var components = URLComponents()
        
        components.scheme = environment.scheme
        components.host = environment.host
        components.port = environment.port
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            fatalError("URL components are not valid")
        }
        
        return url
    }
}
