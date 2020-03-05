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
    // Interval Query
    static private let intervalKey = "interval"
    static private let intervalValue = "1min"
    // API Query
    static private let apiKey = "apikey"
    static private let apiValue = "W4RKS9Q6O3HNTA20"
    // Output Size Query
    static private let outputSizeKey = "outputsize"
    static private let outputSizeVal = "full"
    
    static func getIntraDayPrices(forEquity equity: Equity, completion: @escaping (Result<[PricePoint], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let functionQuery = URLQueryItem(name: functionKey, value: functionValue)
        let symbolQuery = URLQueryItem(name: symbolKey, value: equity.symbol)
        let intervalQuery = URLQueryItem(name: intervalKey, value: intervalValue)
        let outputSizeQuery = URLQueryItem(name: outputSizeKey, value: outputSizeVal)
        let apiQuery = URLQueryItem(name: apiKey, value: apiValue)
        
        components?.queryItems = [functionQuery, symbolQuery, intervalQuery, outputSizeQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error)
            }
            
            guard let data = data else { return }
            
            do {
                guard let topLevel = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else { return }
                
                guard let secondLevel = topLevel["Time Series (1min)"] as? [String: [String: String]] else { return }
                
                var intraDayPricePoints: [PricePoint] = []
                
                for (k, v) in secondLevel {
                    
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
                    
                    guard let date = dateFormatter.date(from: k) else { return }
                    guard let openPrice = v["1. open"] else { return }
                    
                    let pricePoint = PricePoint(date: date, price: openPrice)
                    intraDayPricePoints.append(pricePoint)
                    
                    intraDayPricePoints.sort(by: >)
                }
                
                completion(.success(intraDayPricePoints))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func getCurrentWeekPricing(forEquity equity: Equity, completion: @escaping (Result<[PricePoint], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
    }
}
