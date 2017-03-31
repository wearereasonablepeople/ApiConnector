//
//  URLSessionDataTask.swift
//  ApiConnector
//
//  Created by Mirellys on 24/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation
import RxSwift

extension URLSessionDataTask: DataRequestType {
    public static func requestObservable(with request: URLRequest) -> Observable<Response> {
        return Observable<Response>
            .create({ observer -> Disposable in
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                
                let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let error = error {
                        observer.onError(error)
                    }
                    else if let data = data, let response = response as? HTTPURLResponse {
                        observer.onNext(Response(for: request, response: response, data: data))
                    } else {
                        observer.onError(APIConnectorError.noResponse)
                    }
                })
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }).observeOn(MainScheduler.instance)
    }
}
