//
//  APIConnectorError.swift
//  ApiConnector
//
//  Created by Mirellys on 29/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public enum APIConnectorError: Error {
    case noResponse
    case invalidRequest
    case unacceptableStatusCode(Int)
}

extension APIConnectorError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .noResponse:
            return "No response"
        case .invalidRequest:
            return "Invalid request"
        case .unacceptableStatusCode(let code):
            return "Status unnacceptable with code: \(code)"
        }
    }
}

extension APIConnectorError: Equatable {
    public static func == (lError: APIConnectorError, rError: APIConnectorError) -> Bool {
        switch (lError, rError) {
        case (.noResponse, .noResponse), (.invalidRequest, .invalidRequest):
            return true
        case (let .unacceptableStatusCode(code1), let .unacceptableStatusCode(code2)):
            return code1 == code2
        default:
            return false
        }
    }
}
