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

public extension DataRequestType {
    public func jsonObservable() -> Observable<JSON> {
        return responseObservable().map({ JSON(data: $0) })
    }
    
    public func modelObservable<T: JSONInitializable>() -> Observable<T> {
        return jsonObservable().map({ try T(json: $0) })
    }
    
    public func modelObservable<T: JSONInitializable>() -> Observable<[T]> {
        return jsonObservable().map({ try $0.arrayValue.map({ try T(json: $0) }) })
    }
    
    public func observable() -> Observable<Void> {
        return jsonObservable().map({ _ in () })
    }
}

public extension ApiConnectionType {
    
    public func requestData(method: HTTPMethod = .get, with model: JSONRepresentable? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> RequestType {
        return requestData(method: method, with: model?.jsonValue, at: endpoint, headers: headers)
    }
    
    public func requestData(method: HTTPMethod = .get, with json: JSON? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> RequestType {
        return requestData(method: method, with: json.flatMap({ try? $0.rawData() }), at: endpoint, headers: headers)
    }
    
    public func requestObservable<T: JSONInitializable>(method: HTTPMethod = .get, with model: JSONRepresentable? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> Observable<T> {
        return validate(request: requestData(method: method, with: model, at: endpoint, headers: headers)).modelObservable()
    }
    
    public func requestObservable<T: JSONInitializable>(method: HTTPMethod = .get, with model: JSONRepresentable? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> Observable<[T]> {
        return validate(request: requestData(method: method, with: model, at: endpoint, headers: headers)).modelObservable()
    }
    
    public func requestObservable(method: HTTPMethod = .get, with model: JSONRepresentable? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> Observable<Void> {
        return validate(request: requestData(method: method, with: model, at: endpoint, headers: headers)).observable()
    }
    
    public func requestObservable(method: HTTPMethod = .get, with model: JSONRepresentable? = nil, at endpoint: R.Route, headers: HTTPHeaders? = nil) -> Observable<JSON> {
        return validate(request: requestData(method: method, with: model, at: endpoint, headers: headers)).jsonObservable()
    }
}
