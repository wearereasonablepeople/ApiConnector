//
//  TestNetwork.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public protocol ResponseProvider {
    static func response(for request: URLRequest) -> TestConnectorResponse
}

public final class TestConnector<T: ResponseProvider>: DataRequestType {
    let validation: DataRequest.Validation?
    let request: URLRequest
    let completionHandler: ((Data?, Error?) -> Void)?
    
    public static func dataRequest(with request: URLRequest) -> TestConnector {
        return .init(request: request)
    }
    
    public init(request: URLRequest, validation: DataRequest.Validation? = nil, completionHandler: ((Data?, Error?) -> Void)? = nil) {
        self.completionHandler = completionHandler
        self.request = request
        self.validation = validation
        startIfPossible()
    }
    
    private func startIfPossible() {
        guard let completionHandler = completionHandler else { return }
        DispatchQueue.global().async {
            let response = T.response(for: self.request).validate(self.validation).completionValue
            completionHandler(response.0, response.1)
        }
    }
    
    public func validate() -> TestConnector {
        return validate({ request, response, data -> Request.ValidationResult in
            let code = response.statusCode
            switch code {
            case 200...299:
                return .success
            default:
                let error = AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: code))
                return .failure(error)
            }
        })
    }
    
    public func validate(_ validation: @escaping DataRequest.Validation) -> TestConnector {
        return .init(request: request, validation: validation)
    }
    
    public func cancel() {
        //Does nothing
    }
    
    public func responseData(completionHandler: @escaping (Data?, Error?) -> Void) -> TestConnector {
        return .init(request: request, validation: validation, completionHandler: completionHandler)
    }
}
