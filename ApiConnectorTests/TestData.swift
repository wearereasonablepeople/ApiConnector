//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector

enum Router: String, ApiRouter, ApiEnvironment {
    typealias EnvironmentType = Router
    
    case me, pictures
    
    var host: String { return "testhost" }
}
