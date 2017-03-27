//
//  NetworkConnectoRouterType.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire
import RxSwift
import SweetRouter

public struct HTTP {
    public enum Method: String {
        case options = "OPTIONS"
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
}

public protocol DataRequestType {
    static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<Response>
}

public protocol ApiConnectionType {
    associatedtype RequestType: DataRequestType
    associatedtype RouterType: EndpointType
    
    var environment: RouterType.Environment { get }
    var defaultHeaders: HTTPHeaders? { get }
    var defaultValidation: DataRequest.Validation? { get }
    
    func request(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?) -> URLRequest
    func requestObservable(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?, _ validation: (DataRequest.Validation)?) -> Observable<Response>
}

public extension ApiConnectionType {
    public var environment: RouterType.Environment { return RouterType.default }
    public var defaultHeaders: HTTPHeaders? { return nil }
    public var defaultValidation: DataRequest.Validation? { return nil }
    
    public func request(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?) -> URLRequest {
        var request = URLRequest(url: Router<RouterType>(environment, at: endpoint).url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers ?? defaultHeaders
        request.httpBody = data
        return request
    }
    
    public func requestObservable(method: HTTP.Method = .get, with data: Data? = nil, at endpoint: RouterType.Route, headers: HTTPHeaders? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<Response> {
        return RequestType.requestObservable(with: request(method: method, with: data, at: endpoint, headers: headers), validation ?? defaultValidation)
    }
}

public struct NetworkConnector<T: DataRequestType, E: EndpointType>: ApiConnectionType {
    public typealias RequestType = T
    public typealias RouterType = E
    
    public let environment: RouterType.Environment
    
    public init(environment: RouterType.Environment = RouterType.default) {
        self.environment = environment
    }
}
