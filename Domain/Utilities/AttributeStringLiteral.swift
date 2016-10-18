//
//  AttributeStringLiteral.swift
//  PokerPalm
//
//  Created by Bohdan Orlov on 18/10/2016.
//  Copyright © 2016 berrylux. All rights reserved.
//

import Foundation

extension Attribute: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}
