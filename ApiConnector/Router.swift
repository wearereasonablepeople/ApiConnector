//
//  Router.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import Alamofire

protocol ApiEnvironment {
    var host: String { get }
    var scheme: String { get }
    var port: Int { get }
    
    static var `default`: Self { get }
}

extension ApiEnvironment {
    var scheme: String { return "http" }
    var port: Int { return 80 }
}
