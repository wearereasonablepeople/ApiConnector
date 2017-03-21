//
//  Response.swift
//  ApiConnector
//
//  Created by Oleksii on 21/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct Response<Value> {
    public let request: URLRequest
    public let response: URLResponse
    public let value: Value
    
    public func map<T>(_ transform: (Value) throws -> T) throws -> Response<T> {
        return Response<T>(request: request, response: response, value: try transform(value))
    }
    
    public init(request: URLRequest, response: URLResponse, value: Value) {
        self.request = request
        self.response = response
        self.value = value
    }
}
