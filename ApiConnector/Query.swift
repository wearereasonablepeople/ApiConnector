//
//  Query.swift
//  ApiConnector
//
//  Created by Oleksii on 01/02/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public protocol QueryItemValue {
    var stringValue: String { get }
}

public struct Query {
    private let items: [(name: String, value: QueryItemValue?)]
    
    public init(_ items: (name: String, value: QueryItemValue?)...) {
        self.init(items)
    }
    
    public init(_ items: [(name: String, value: QueryItemValue?)]) {
        self.items = items
    }
    
    public var queryItems: [URLQueryItem] {
        return items.map({ URLQueryItem(name: $0.name, value: $0.value?.stringValue) })
    }
}

extension String: QueryItemValue {}
