//
//  NetworkError.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case thrownError(Error)
    case noDataFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Could not contact the server."
        case .thrownError(let error):
            return error.localizedDescription
        case .noDataFound:
            return "The server responded with no data."
        }
    }
}
