//
//  GraphData.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import Foundation

struct RobinhoodChartData {
  let openingPrice: Double
  let data: [(date: Date, price: Double)]
  
  static var portfolioData: RobinhoodChartData {
    var chartData: [(date: Date, price: Double)] = []
    
    var dateComponents = DateComponents()
    dateComponents.year = 2018
    dateComponents.month = 5
    dateComponents.day = 4
    dateComponents.minute = 0
    
    let calendar = Calendar.current
    var startDateComponents = dateComponents
    startDateComponents.hour = 9
    let startDate = calendar.date(from: startDateComponents)
    
    var endDateComponents = dateComponents
    endDateComponents.hour = 16
    let endDate = calendar.date(from: endDateComponents)
    
    // Creates an interval from the startDate to the endDate for later use.
    let dateInterval = DateInterval(start: startDate!, end: endDate!)
    
    let secondsInMinute = 60
    // Creates time interval increment of 5 mind
    let timeIntervalIncrement = 5 * secondsInMinute
    // Creates a duration which represents the duration from the first date to the last date
    let duration = Int(dateInterval.duration)
    
    let startPrice: Double = 400
    
    for i in stride(from: 0, to: duration, by: timeIntervalIncrement) {
      let date = startDate!.addingTimeInterval(TimeInterval(i))
      var randomPriceMovement = Double(arc4random_uniform(100))/50
      let upOrDown = arc4random_uniform(2)
      
      if upOrDown == 0 { randomPriceMovement = -randomPriceMovement }
      let chartDataPoint = (date: date, price: startPrice + randomPriceMovement)
      chartData.append(chartDataPoint)
    }

    let portfolioData = RobinhoodChartData(openingPrice: startPrice, data: chartData)
    
    return portfolioData
  }
}
