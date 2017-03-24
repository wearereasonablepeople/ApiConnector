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

public protocol DataRequestType {
    static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<DataResponse<Data>>
}

public protocol ApiConnectionType {
    associatedtype RequestType: DataRequestType
    associatedtype RouterType: EndpointType
    
    var environment: RouterType.Environment { get }
    var defaultHeaders: HTTPHeaders? { get }
    var defaultValidation: DataRequest.Validation? { get }
    
    func request(method: HTTPMethod, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?) -> URLRequest
    func requestObservable(method: HTTPMethod, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?, _ validation: (DataRequest.Validation)?) -> Observable<DataResponse<Data>>
}

public extension ApiConnectionType {
    public var environment: RouterType.Environment { return RouterType.default }
    public var defaultHeaders: HTTPHeaders? { return nil }
    public var defaultValidation: DataRequest.Validation? { return nil }
    
    public func request(method: HTTPMethod, with data: Data?, at endpoint: RouterType.Route, headers: HTTPHeaders?) -> URLRequest {
        do {
            let requestHeaders = headers ?? defaultHeaders
            let route = Router<RouterType>(environment, at: endpoint)
            var request = try URLRequest(url: route.url, method:method, headers: requestHeaders)
            
            request.httpBody = data
            
            return request
        } catch let error {
            fatalError("Invalid request \(error)")
        }
    }
    
    public func requestObservable(method: HTTPMethod = .get, with data: Data? = nil, at endpoint: RouterType.Route, headers: HTTPHeaders? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<DataResponse<Data>> {
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
