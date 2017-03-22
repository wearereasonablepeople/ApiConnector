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

extension ObservableType where E: ResponseType {
    public func mapValue<T>(_ transform: @escaping (E.Value) throws -> T) -> Observable<Response<T>> {
        return map { try $0.map(transform) }
    }
    
    public func toValue() -> Observable<E.Value> {
        return map { $0.value }
    }
}

extension ObservableType where E == Response<Data> {
    public func toJSON() -> Observable<Response<JSON>> {
        return mapValue { JSON(data: $0) }
    }
    
    public func toModel<T: JSONInitializable>() -> Observable<Response<T>> {
        return toJSON().mapValue { try T(json: $0) }
    }
    
    public func toModel<T: JSONInitializable>() -> Observable<Response<[T]>> {
        return toJSON().mapValue { try $0.arrayValue().map({ try T(json: $0) }) }
    }
}
