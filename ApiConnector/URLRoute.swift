//
//  URLRoute.swift
//  ApiConnector
//
//  Created by Oleksii on 06/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
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

extension URLRoute: Equatable {
    public static func == (lhs: URLRoute, rhs: URLRoute) -> Bool {
        return lhs.method == rhs.method && lhs.path == rhs.path && lhs.query == rhs.query
    }
}
