//
//  EquityList.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

struct EquityList: Codable {
    let equities: [Equity]
    
    enum CodingKeys: String, CodingKey {
        case equities = "bestMatches"
    }
}

struct Equity: Codable {
    let symbol: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
    }
}
