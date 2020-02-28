//
//  IntradayPricePoints.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

class PricePoint {
    let date: Date
    let price: String
    
    init(date: Date, price: String) {
        self.date = date
        self.price = price
    }
}

extension PricePoint: Comparable {
    static func < (lhs: PricePoint, rhs: PricePoint) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: PricePoint, rhs: PricePoint) -> Bool {
        return lhs.date == rhs.date
    }
    
    
}
