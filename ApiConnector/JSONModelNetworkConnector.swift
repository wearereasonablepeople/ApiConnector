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

public extension ObservableType where E == DataResponse<Data> {
    public func toData() -> Observable<Data?> {
        return map { $0.value }
    }
    
    public func toJSON() -> Observable<JSON> {
        return map { JSON(data: $0.value!) }
    }
    
    public func toModel<T: JSONInitializable>() -> Observable<T> {
        return toJSON().map { try T(json: $0) }
    }
    
    public func toModel<T: JSONInitializable>() -> Observable<[T]> {
        return toJSON().map { try $0.arrayValue().map({ try T(json: $0) }) }
    }
    
    public func toVoid() -> Observable<Void> {
        return map({ _ in () })
    }
}

public extension ApiConnectionType {
    public func requestObservable(method: HTTPMethod = .get, with json: JSON?, at endpoint: R.Route, headers: HTTPHeaders? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<DataResponse<Data>> {
        return requestObservable(method: method, with: json.flatMap({ try? $0.rawData() }), at: endpoint, headers: headers, validation)
    }
    
    public func requestObservable(method: HTTPMethod = .get, with model: JSONRepresentable?, at endpoint: R.Route, headers: HTTPHeaders? = nil, _ validation: (DataRequest.Validation)? = nil) -> Observable<DataResponse<Data>> {
        return requestObservable(method: method, with: model?.jsonValue, at: endpoint, headers: headers, validation)
    }
}
