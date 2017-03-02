//
//  IP.swift
//  ApiConnector
//
//  Created by Oleksii on 02/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct IP {
    public let firstOctet: Int
    public let secondOctet: Int
    public let thirdOctet: Int
    public let fourthOctet: Int
    
    public init?(_ first: Int, _ second: Int, _ third: Int, _ fourth: Int) {
        let range = 0...255
        guard range ~= first, range ~= second, range ~= third, range ~= fourth else {
            return nil
        }
        firstOctet = first
        secondOctet = second
        thirdOctet = third
        fourthOctet = fourth
    }
    
    public var stringValue: String {
        return "\(firstOctet).\(secondOctet).\(thirdOctet).\(fourthOctet)"
    }
}
