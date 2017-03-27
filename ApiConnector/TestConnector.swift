//
//  TestNetwork.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire
import RxSwift

public final class TestConnector<T: ResponseProvider>: DataRequestType {
    public static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<Response> {
        return Observable
            .just()
            .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .flatMap { T.response(for: request) }
            .map { $0.validate(validation ?? Response.defaultValidation) }
            .map { try $0.toResponse() }
            .observeOn(MainScheduler.instance)
    }
}
