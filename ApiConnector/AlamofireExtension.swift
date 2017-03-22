//
//  AlamofireExtension.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire
import RxSwift

public enum ApiNetworkError: Error {
    case noErrorNoData
}

extension Alamofire.DataRequest: DataRequestType {
    public static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<DataResponse<Data>> {
        return Observable.create({ observer -> Disposable in
            var request = Alamofire.request(request)
            
            if let validation = validation {
                request = request.validate(validation)
            } else {
                request = request.validate()
            }
            
            request.responseData() { response in
                if let error = response.error {
                    observer.onError(error)
                } else if response.request != nil && response.response != nil && response.data != nil {
                    observer.onNext(response)
                } else {
                    observer.onError(ApiNetworkError.noErrorNoData)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
