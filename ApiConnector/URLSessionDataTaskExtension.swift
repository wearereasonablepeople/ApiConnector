//
//  URLSessionDataTask.swift
//  ApiConnector
//
//  Created by Mirellys on 24/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension URLSessionDataTask: DataRequestType {
    public static func requestObservable(with request: URLRequest, _ validation: (DataRequest.Validation)?) -> Observable<DataResponse<Data>> {
        
        return Observable.create({ observer -> Disposable in
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                }
                else if let data = data, let response = response as? HTTPURLResponse {
                    observer.onNext(DataResponse(request: request, response: response, data: data, result:.success(data)))
                } else {
                    observer.onError(AFError.responseSerializationFailed(reason: .inputDataNil))
                }
            })
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
