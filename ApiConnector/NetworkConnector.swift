//
//  NetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

protocol DataRequestType {
    static func dataRequest(with request: URLRequest) -> Self
    
    func validate() -> Self
    func validate(_ validation: @escaping Alamofire.DataRequest.Validation) -> Self
    func cancel()
    
    func responseData(completionHandler: @escaping (Data?, Error?) -> Void) -> Self
}

protocol ApiConnectionType {
    associatedtype Request: DataRequestType
    associatedtype Router: ApiRouter
    
    var environment: Router.EnvironmentType { get }
    var defaultHeaders: HTTPHeaders? { get }
    
    func request(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> URLRequest
    func requestData(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> Request
}

extension ApiConnectionType {
    var defaultHeaders: HTTPHeaders? { return nil }
    
    func request(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> URLRequest {
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
    
    func requestData(with data: Data?, at endpoint: Router, headers: HTTPHeaders?) -> Request {
        return Request.dataRequest(with: request(with: data, at: endpoint, headers: headers))
    }
}
