//
//  NetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public protocol DataRequestType {
    static func dataRequest(with request: URLRequest) -> Self
    
    func validate() -> Self
    func validate(_ validation: @escaping Alamofire.DataRequest.Validation) -> Self
    func cancel()
    
    func responseData(completionHandler: @escaping (Data?, Error?) -> Void) -> Self
}

public protocol ApiConnectionType {
    associatedtype Request: DataRequestType
    associatedtype Router: ApiRouter
    
    var environment: Router.EnvironmentType { get }
    var defaultHeaders: HTTPHeaders? { get }
    
    func request(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> URLRequest
    func requestData(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> Request
}

public extension ApiConnectionType {
    public var defaultHeaders: HTTPHeaders? { return nil }
    
    public func request(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> URLRequest {
        do {
            let requestHeaders = headers ?? defaultHeaders
            let url = endpoint.url(for: environment)
            var request = try URLRequest(url: url, method: endpoint.method, headers: requestHeaders)
            
            request.httpBody = data
            
            return request
        } catch let error {
            fatalError("Invalid request \(error)")
        }
    }
    
    public func requestData(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> Request {
        return Request.dataRequest(with: request(with: data, at: endpoint, headers: headers))
    }
}

public struct NetworkConnector<T: DataRequestType, E: ApiRouter>: ApiConnectionType {
    public typealias Request = T
    public typealias Router = E
    
    public let environment: Router.EnvironmentType
    
    public init(environment: Router.EnvironmentType) {
        self.environment = environment
    }
}
