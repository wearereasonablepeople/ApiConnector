//
//  JSONModelNetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift

public extension ObservableType where E == Response {
    public func toModel<T: Decodable>() -> Observable<T> {
        return map { try JSONDecoder().decode(T.self, from: $0.data) }
    }
    
    public func toVoid() -> Observable<Void> {
        return map({ _ in () })
    }
    
    public func validate(_ validation: @escaping Response.Validation) -> Observable<Response> {
        return map { try validation($0) }
    }
}

public extension ApiConnectionType {
    public func requestObservable<T: Encodable>(method: HTTP.Method = .get, with model: T?, at endpoint: RouterType.Route, headers: HTTP.Headers? = nil, _ validation: Response.Validation? = nil) -> Observable<Response> {
        let data: Data?
        do {
            data = try model.map({ try JSONEncoder().encode($0) })
        } catch let error {
            return .error(error)
        }
        return requestObservable(method: method, with: data, at: endpoint, headers: headers, validation)
    }
}
