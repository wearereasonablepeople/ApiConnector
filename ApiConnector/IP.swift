//
//  IP.swift
//  ApiConnector
//
//  Created by Oleksii on 02/03/2017.
//  Copyright © 2017 WeAreReasonablePeople. All rights reserved.
//

import Foundation

public struct IP {
    public let firstOctet: UInt8
    public let secondOctet: UInt8
    public let thirdOctet: UInt8
    public let fourthOctet: UInt8
    
    public init(_ first: UInt8, _ second: UInt8, _ third: UInt8, _ fourth: UInt8) {
        firstOctet = first
        secondOctet = second
        thirdOctet = third
        fourthOctet = fourth
    }
    
    public var stringValue: String {
        return "\(firstOctet).\(secondOctet).\(thirdOctet).\(fourthOctet)"
    }
}
