//
//  Quote.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/6/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation


struct QuoteTopLevel: Codable {
    
    let globalQuote: GlobalQuote
    
    enum CodingKeys: String, CodingKey {
        case globalQuote = "Global Quote"
    }
}

struct GlobalQuote: Codable {
    let price: String
    let percentChange: String
    
    enum CodingKeys: String, CodingKey {
        case price = "05. price"
        case percentChange = "10. change percent"
    }
}
