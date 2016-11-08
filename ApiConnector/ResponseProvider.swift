//
//  ResponseProvider.swift
//  ApiConnector
//
//  Created by Oleksii on 08/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public protocol ResponseProvider {
    static func response(for request: URLRequest) -> TestConnectorResponse
    static func successResponse(for request: URLRequest, with code: Int, data: Data?) -> TestConnectorResponse
}

public extension ResponseProvider {
    public static func successResponse(for request: URLRequest, with code: Int, data: Data?) -> TestConnectorResponse {
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
        return .success(request, httpResponse, data)
    }
}
