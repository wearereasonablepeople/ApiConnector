//
//  URLRoute.swift
//  ApiConnector
//
//  Created by Oleksii on 06/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct URLRoute {
    public let path: RoutePath
    public let query: Query?
    
    public init(_ path: RoutePath, _ query: (name: String, value: QueryItemValue?)...) {
        self.path = path
        self.query = Query(query)
    }
    
    public init(_ path: RoutePath) {
        self.path = path
        self.query = nil
    }
}

extension URLRoute: Equatable {
    public static func == (lhs: URLRoute, rhs: URLRoute) -> Bool {
        return lhs.path == rhs.path && lhs.query == rhs.query
    }
}
