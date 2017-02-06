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
    associatedtype RequestType: DataRequestType
    associatedtype RouterType: ApiRouter
    
    var environment: RouterType.EnvironmentType { get }
    var defaultHeaders: HTTPHeaders? { get }
    var defaultValidation: Alamofire.DataRequest.Validation? { get }
    
    func request(with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> URLRequest
    func requestData(with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> RequestType
    func validate(request: RequestType) -> RequestType
}

public extension ApiConnectionType {
    public var defaultHeaders: HTTPHeaders? { return nil }
    public var defaultValidation: Alamofire.DataRequest.Validation? { return nil }
    
    public func request(with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> URLRequest {
        do {
            let requestHeaders = headers ?? defaultHeaders
            let url = endpoint.url(for: environment)
            var request = try URLRequest(url: url, method: endpoint.route.method, headers: requestHeaders)
            
            request.httpBody = data
            
            return request
        } catch let error {
            fatalError("Invalid request \(error)")
        }
    }
    
    public func requestData(with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> RequestType {
        return RequestType.dataRequest(with: request(with: data, at: endpoint, headers: headers))
    }
    
    public func validate(request: RequestType) -> RequestType {
        if let validation = defaultValidation {
            return request.validate(validation)
        } else {
            return request.validate()
        }
    }
}

public struct NetworkConnector<T: DataRequestType, E: ApiRouter>: ApiConnectionType {
    public typealias RequestType = T
    public typealias RouterType = E
    
    public let environment: RouterType.EnvironmentType
    
    public init(environment: RouterType.EnvironmentType) {
        self.environment = environment
    }
}
