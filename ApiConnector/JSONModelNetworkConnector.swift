//
//  JSONModelNetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON
import SwiftyJSONModel

public extension ObservableType where E == Response {
    public func toModel<T: JSONInitializable>() -> Observable<T> {
        return map { try T(json: JSON(data: $0.data)) }
    }
    
    public func toModel<T: JSONInitializable>() -> Observable<[T]> {
        return map { try JSON(data: $0.data).arrayValue().map({ try T(json: $0) }) }
    }
    
    public func toVoid() -> Observable<Void> {
        return map({ _ in () })
    }
}

public extension ApiConnectionType {
    public func requestObservable(method: HTTP.Method = .get, with model: JSONRepresentable?, at endpoint: RouterType.Route, headers: HTTP.Headers? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<Response> {
        return requestObservable(method: method, with: model.flatMap({ try? $0.jsonValue.rawData() }), at: endpoint, headers: headers, validation)
    }
    
    public func requestObservable<T: JSONInitializable>(method: HTTP.Method = .get, with model: JSONRepresentable? = nil, at endpoint: RouterType.Route, headers: HTTP.Headers? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<T> {
        return requestObservable(method: method, with: model, at: endpoint, headers: headers, validation).toModel()
    }
    
    public func requestObservable<T: JSONInitializable>(method: HTTP.Method = .get, with model: JSONRepresentable? = nil, at endpoint: RouterType.Route, headers: HTTP.Headers? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<[T]> {
        return requestObservable(method: method, with: model, at: endpoint, headers: headers, validation).toModel()
    }
}
