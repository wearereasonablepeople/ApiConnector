//
//  NetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire
import SweetRouter

public protocol DataRequestType {
    static func dataRequest(with request: URLRequest) -> Self
    
    func validate() -> Self
    func validate(_ validation: @escaping Alamofire.DataRequest.Validation) -> Self
    func cancel()
    
    func responseData(completionHandler: @escaping (Data?, Error?) -> Void) -> Self
}

public protocol ApiConnectionType {
    associatedtype RequestType: DataRequestType
    associatedtype R: RouterType
    
    var environment: R.Environment { get }
    var defaultHeaders: HTTPHeaders? { get }
    var defaultValidation: Alamofire.DataRequest.Validation? { get }
    
    func request(method: HTTPMethod, with data: Data?, at endpoint: R.Route, headers: HTTPHeaders?) -> URLRequest
    func requestData(method: HTTPMethod, with data: Data?, at endpoint: R.Route, headers: HTTPHeaders?) -> RequestType
    func validate(request: RequestType) -> RequestType
}

public extension ApiConnectionType {
    public var defaultHeaders: HTTPHeaders? { return nil }
    public var defaultValidation: Alamofire.DataRequest.Validation? { return nil }
    
    public func request(method: HTTPMethod, with data: Data?, at endpoint: R.Route, headers: HTTPHeaders?) -> URLRequest {
        do {
            let requestHeaders = headers ?? defaultHeaders
            let route = Router<R>(environment, at: endpoint)
            var request = try URLRequest(url: route.url, method:method, headers: requestHeaders)
            
            request.httpBody = data
            
            return request
        } catch let error {
            fatalError("Invalid request \(error)")
        }
    }
    
    public func requestData(method: HTTPMethod = .get, with data: Data?, at endpoint: R.Route, headers: HTTPHeaders?) -> RequestType {
        return RequestType.dataRequest(with: request(method: method, with: data, at: endpoint, headers: headers))
    }
    
    public func validate(request: RequestType) -> RequestType {
        guard let validation = defaultValidation else {
            return request.validate()
        }
        return request.validate(validation)
    }
}

public struct NetworkConnector<T: DataRequestType, E: RouterType>: ApiConnectionType {
    public typealias RequestType = T
    public typealias R = E
    
    public let environment: R.Environment
    
    public init(environment: R.Environment = R.default) {
        self.environment = environment
    }
}
