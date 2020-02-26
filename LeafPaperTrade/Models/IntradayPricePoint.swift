//
//  IntradayPricePoints.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

class IntradayPricePoint {
    let date: Date
    let price: String
    
    init(date: Date, price: String) {
        self.date = date
        self.price = price
    }
}

extension IntradayPricePoint: Comparable {
    static func < (lhs: IntradayPricePoint, rhs: IntradayPricePoint) -> Bool {
        return lhs.date < rhs.date
    }
    
    static func == (lhs: IntradayPricePoint, rhs: IntradayPricePoint) -> Bool {
        return lhs.date == rhs.date
    }
    
    
}
