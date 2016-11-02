//
//  AlamofireExtension.swift
//  ApiConnector
//
//  Created by Oleksii on 02/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

extension Alamofire.DataRequest: DataRequestType {
    
    public static func dataRequest(with request: URLRequest) -> Self {
        return convertWithRequest(with: request)
    }
    
    static func convertWithRequest<T>(with request: URLRequest) -> T {
        return Alamofire.request(request) as! T
    }
    
    public func responseData(completionHandler: @escaping (Data?, Error?) -> Void) -> Self {
        return responseData { response in
            completionHandler(response.result.value, response.result.error)
        }
    }
}
