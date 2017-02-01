//
//  Environment.swift
//  ApiConnector
//
//  Created by Oleksii on 01/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public protocol ApiEnvironment {
    var value: URLEnvironment { get }
}

public struct URLEnvironment {
    public let scheme: Scheme
    public let host: String
    public let port: Int?
    
    public init(_ scheme: Scheme = .http, host: String, _ port: Int? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
    }
}
