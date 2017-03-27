//
//  Response.swift
//  ApiConnector
//
//  Created by Oleksii on 27/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation
import Alamofire

public struct Response {
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
    
    public func validate(_ validation: DataRequest.Validation) throws -> Response {
        switch validation(request, response, data) {
        case .success: return self
        case let .failure(error): throw error
        }
    }
    
    public static let defaultValidation: DataRequest.Validation = { request, response, data -> Request.ValidationResult in
        let code = response.statusCode
        switch code {
        case 200...299:
            return .success
        default:
            let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: code))
            return .failure(error)
        }
    }
}
