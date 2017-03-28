//
//  AlamofireExtension.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire
import RxSwift

extension Alamofire.DataRequest: DataRequestType {
    public static func requestObservable(with request: URLRequest) -> Observable<Response> {
        return Observable.create({ observer -> Disposable in
            let request = Alamofire.request(request).validate()
            
            request.responseData() { response in
                if let error = response.error {
                    observer.onError(error)
                } else if let request = response.request, let data = response.data, let response = response.response {
                    observer.onNext(Response(for: request, response: response, data: data))
                } else {
                    observer.onError(AFError.responseSerializationFailed(reason: .inputDataNil))
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        })
    }
}
