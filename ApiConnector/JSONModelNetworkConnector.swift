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
}
