//
//  StockPriceController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

class EquityPriceController {
    
    static let baseURL = URL(string: "https://www.alphavantage.co/query")
    // Function Query
    static private let functionKey = "function"
    static private let functionValue = "TIME_SERIES_INTRADAY"
    // Symbol Query
    static private let symbolKey = "symbol"
    
    //
    
    static func getIntraDayPrices(forSymbol symbol: String, completion: @escaping (Result<[IntradayPricePoint], NetworkError>) -> Void) {
        
        guard let baseURL = URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=MSFT&interval=5min&apikey=demo") else { return }
        
        URLSession.shared.dataTask(with: baseURL) { (data, _, error) in
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                guard let topLevel = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                
                guard let secondLevel = topLevel["Time Series (5min)"] as? [String: [String: String]] else { return }
                
                var intraDayPricePoints: [IntradayPricePoint] = []
            
                for (k, v) in secondLevel {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    guard let date = dateFormatter.date(from: k) else { return }
                    guard let openPrice = v["1. open"] else { return }
                    
                    let pricePoint = IntradayPricePoint(date: date, price: openPrice)
                    intraDayPricePoints.append(pricePoint)
                    
                    intraDayPricePoints.sort(by: >)
                }
                
                completion(.success(intraDayPricePoints))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}
