//
//  EquitySearchModelController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation


class EquitySearchModelController {
    
    static private let baseURL = URL(string: "https://www.alphavantage.co/query")
    // Function Query
    static private let functionKey = "function"
    static private let functionValue = "SYMBOL_SEARCH"
    // Keyword Query
    static private let keywordKey = "keywords"
    // Keyword value is searchTerm passed in from searchbar
    // Datatype Query
    static private let datatypeKey = "datatype"
    static private let datatypeValue = "json"
    // API Key Query
    static private let apiKey = "apikey"
    static private let apiValue = "W4RKS9Q6O3HNTA20"
    
    static func getEquities(withSearchTerm searchTerm: String, completion: @escaping (Result<[Equity], NetworkError>) -> Void) {
        
        guard let baseURL = baseURL else { return }
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        
        let functionQuery = URLQueryItem(name: functionKey, value: functionValue)
        let keywordQuery = URLQueryItem(name: keywordKey, value: searchTerm)
        let apiQuery = URLQueryItem(name: apiKey, value: apiValue)
        
        components?.queryItems = [functionQuery, keywordQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noDataFound)) }
            
            do {
                let equityLists = try JSONDecoder().decode(EquityLists.self, from: data)
                
                let usaEquities = sortOutNonUSEquities(equities: equityLists.equities)
                
                completion(.success(usaEquities))
            } catch {
                print(error, error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func sortOutNonUSEquities(equities: [Equity]) -> [Equity] {
        var usaEquities: [Equity] = []
        for equity in equities {
            if equity.region == "United States" {
                usaEquities.append(equity)
            }
        }
        return usaEquities
    }
}
