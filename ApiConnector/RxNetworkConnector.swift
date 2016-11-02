//
//  RxNetworkConnector.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import RxSwift

public enum ApiNetworkError: Error {
    case noErrorNoData
}

public extension DataRequestType {
    public func responseObservable() -> Observable<Data> {
        return Observable<Data>.create({ observer -> Disposable in
            let request = self.responseData(completionHandler: { data, error in
                if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                } else {
                    observer.onError(error ?? ApiNetworkError.noErrorNoData)
                }
            })
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
