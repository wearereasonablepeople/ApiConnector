//
//  Response.swift
//  ApiConnector
//
//  Created by Oleksii on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct Response {
    public typealias Validation = (Response) throws -> Response
    
    public let request: URLRequest
    public let response: HTTPURLResponse
    public let data: Data
    
    public init(for request: URLRequest, response: HTTPURLResponse, data: Data) {
        self.request = request
        self.response = response
        self.data = data
    }
    
    public init(for request: URLRequest, with code: Int, data: Data) {
        let response = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
        self.init(for: request, response: response, data: data)
    }
    
    public init<T: Encodable>(for request: URLRequest, with code: Int, jsonObject: T) {
        self.init(for: request, with: code, data: try! JSONEncoder().encode(jsonObject))
    }
}
