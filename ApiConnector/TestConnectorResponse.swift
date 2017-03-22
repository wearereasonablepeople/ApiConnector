//
//  TestConnectorResponse.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

public enum TestConnectorResponse {
    case success(URLRequest, HTTPURLResponse, Data)
    case failure(Error)
    
    public func validate(_ validation: DataRequest.Validation?) -> TestConnectorResponse {
        guard case let .success(request, response, data) = self else {
            return self
        }
        guard let validation = validation, case let .failure(error) = validation(request, response, data) else {
            return self
        }
        return .failure(error)
    }
    
    public func toResponse() throws -> DataResponse<Data> {
        switch self {
        case let .success(request, response, data):
            return DataResponse(request: request, response: response, data: data, result: .success(data))
        case let .failure(error):
            throw error
        }
    }
}
