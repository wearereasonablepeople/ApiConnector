//
//  TestData.swift
//  ApiConnector
//
//  Created by Oleksii on 01/11/2016.
//  Copyright © 2016 WeAreReasonablePeople. All rights reserved.
//

import ApiConnector

enum Environment: String, ApiEnvironment {
    case test = "test.com"
}

enum Router: String, ApiRouter {
    typealias EnvironmentType = Environment
    case me, pictures
}

struct TestData {
    static let url = URL(string: "https://google.com")!
    static let request = URLRequest(url: url)
}
