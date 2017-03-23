//
//  ResponseProvider.swift
//  ApiConnector
//
//  Created by Oleksii on 08/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift
import SwiftyJSON
import SwiftyJSONModel

public protocol ResponseProvider {
    static func response(for request: URLRequest) -> Observable<TestConnectorResponse>
    static func successResponse(for request: URLRequest, with code: Int, data: Data) -> TestConnectorResponse
}

public extension ResponseProvider {
    public static func successResponse(for request: URLRequest, with code: Int, data: Data) -> TestConnectorResponse {
        let httpResponse = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
        return .success(request, httpResponse, data)
    }
    
    public static func successResponse(for request: URLRequest, with code: Int, jsonObject: JSONRepresentable) -> TestConnectorResponse {
        do {
            return successResponse(for: request, with: code, data: try jsonObject.jsonValue.rawData())
        } catch let error {
            return .failure(error)
        }
    }
}
