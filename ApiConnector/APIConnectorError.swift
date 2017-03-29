//
//  APIConnectorError.swift
//  ApiConnector
//
//  Created by Mirellys on 29/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public enum APIConnectorError: Error {
    case NoResponse
    case InvalidRequest
    case UnacceptableStatusCode(Int)
}

extension APIConnectorError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .NoResponse:
            return "No response"
        case .InvalidRequest:
            return "Invalid request"
        case .UnacceptableStatusCode(let code):
            return "Status unnacceptable with code: \(code)"
        }
    }
}

extension APIConnectorError: Equatable {
    public static func == (lError: APIConnectorError, rError: APIConnectorError) -> Bool {
        switch (lError, rError) {
        case (.NoResponse, .NoResponse):
            return true
        case (let .UnacceptableStatusCode(code1), let .UnacceptableStatusCode(code2)):
            return code1 == code2
        case (.InvalidRequest, .InvalidRequest):
            return true
        default:
            return false
        }
    }
}
