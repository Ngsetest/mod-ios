//
//  UzCard.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 5/13/18.
//  Copyright © 2018 moda. All rights reserved.
//

import Caishen
import Foundation

struct UzCardType: CardType {
    public let name = "UzCard"
    public let CVCLength = 0
    public let numberGrouping = [4, 4, 4, 4]
    public let identifyingDigits: Set<Int> = [8600]
    public let requiresCVC = false
    public let requiresExpiry = true
    public init() {}
}
