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
    public static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<Response<Data?>> {
        return Observable.create({ observer -> Disposable in
            var request = Alamofire.request(request)
            
            if let validation = validation {
                request = request.validate(validation)
            } else {
                request = request.validate()
            }
            
            request.responseData() { responseValue in
                if let request = responseValue.request, let response = responseValue.response {
                    observer.onNext(
                        Response(
                            request: request,
                            response: response,
                            value: responseValue.data
                        )
                    )
                } else {
                    observer.onError(responseValue.error ?? ApiNetworkError.noErrorNoData)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
