//
//  NetworkConnectoRouterType.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift
import SweetRouter

public protocol DataRequestType {
    static func requestObservable(with request: URLRequest) -> Observable<Response>
}

public protocol ApiConnectionType {
    associatedtype RequestType: DataRequestType
    associatedtype RouterType: EndpointType
    
    var environment: RouterType.Environment { get }
    var defaultHeaders: HTTP.Headers? { get }
    var defaultValidation: Response.Validation { get }
    
    func request(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTP.Headers?) -> URLRequest
    func requestObservable(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTP.Headers?, _ validation: Response.Validation?) -> Observable<Response>
}

public extension ApiConnectionType {
    public var environment: RouterType.Environment { return RouterType.default }
    public var defaultHeaders: HTTP.Headers? { return nil }
    public var defaultValidation: Response.Validation {
        return { response -> Response in
            let code = response.response.statusCode
            switch code {
            case 200...299:
                return response
            default:
                throw APIConnectorError.unacceptableStatusCode(code)
            }
        }
    }
    
    public func request(method: HTTP.Method, with data: Data?, at endpoint: RouterType.Route, headers: HTTP.Headers?) -> URLRequest {
        var request = URLRequest(url: Router<RouterType>(environment, at: endpoint).url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = (headers ?? defaultHeaders).map { HTTP.Header.toStringKeys(headers: $0) }
        request.httpBody = data
        return request
    }
    
    public func requestObservable(method: HTTP.Method = .get, with data: Data? = nil, at endpoint: RouterType.Route, headers: HTTP.Headers? = nil, _ validation: Response.Validation? = nil) -> Observable<Response> {
        return RequestType.requestObservable(with: request(method: method, with: data, at: endpoint, headers: headers)).validate(validation ?? defaultValidation)
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
