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
    
    func request(method: HTTPMethod, with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> URLRequest
    func requestData(method: HTTPMethod, with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> RequestType
    func validate(request: RequestType) -> RequestType
}

public extension ApiConnectionType {
    public var defaultHeaders: HTTPHeaders? { return nil }
    public var defaultValidation: Alamofire.DataRequest.Validation? { return nil }
    
    public func request(method: HTTPMethod, with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> URLRequest {
        do {
            let requestHeaders = headers ?? defaultHeaders
            let url = endpoint.url(for: environment)
            var request = try URLRequest(url: url, method:method, headers: requestHeaders)
            
            request.httpBody = data
            
            return request
        } catch let error {
            fatalError("Invalid request \(error)")
        }
    }
    
    public func requestData(method: HTTPMethod = .get, with data: Data?, at endpoint: RouterType, headers: HTTPHeaders?) -> RequestType {
        return RequestType.dataRequest(with: request(method: method, with: data, at: endpoint, headers: headers))
    }
    
    public func validate(request: RequestType) -> RequestType {
        guard let validation = defaultValidation else {
            return request.validate()
        }
        return request.validate(validation)
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
