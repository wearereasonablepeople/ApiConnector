//
//  TestNetwork.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift

public protocol ResponseProvider {
    static func response(for request: URLRequest) -> Observable<Response>
}

public final class TestConnector<T: ResponseProvider>: DataRequestType {
    public static func requestObservable(with request: URLRequest) -> Observable<Response> {
        return Observable
            .just()
            .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .flatMap { T.response(for: request) }
            .observeOn(MainScheduler.instance)
    }
}
