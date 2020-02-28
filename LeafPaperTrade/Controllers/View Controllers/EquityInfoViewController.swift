//
//  EquityInfoViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

private extension CGFloat {
  static let tickerHeightMultiplier: CGFloat = 0.4
  static let graphHeightMultiplier: CGFloat = 0.6
}

class EquityInfoViewController: UIViewController {
    
    // MARK: - Properties
    
    var equity: Equity? {
        didSet {
            updatePricePoints()
        }
    }
    
    var pricePoints: [PricePoint]? {
        didSet {
            updateGraphViewData()
        }
    }
    
    //private var graphData = EquityChartData.portfolioData
    lazy private var graphView: GraphView =  {
        return GraphView(data: nil)
    }()
    // MARK: - Outlets
    
    @IBOutlet weak var TopGraphView: GraphView!
    
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        graphView.delegate = self
        
//        TopGraphView.addSubview(graphView)
        
    }
    
    // MARK: - Private Functions
    
    private func updatePricePoints() {
        guard let equity = self.equity else { return }
        EquityPriceController.getIntraDayPrices(forEquity: equity) { (result) in
            switch result {
            case .success(let pricePoints):
                DispatchQueue.main.async {
                    self.pricePoints = pricePoints
                }
            case .failure(let error):
                print(error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    private func updateGraphViewData() {
        guard let pricePoints = self.pricePoints else { return }
        
        
        
        var pricePointsToday: [PricePoint] = []
        
        for pricePoint in pricePoints {
            let currentDay = Calendar.current.dateComponents([.weekday], from: Date()).weekday
            let pricePointDay = Calendar.current.dateComponents([.weekday], from: pricePoint.date).weekday
            
            if currentDay == pricePointDay {
                pricePointsToday.append(pricePoint)
            }
        }
        
        var data: [(date: Date, price: Double)] = []
        
        if pricePointsToday.count == 0 {
            SVProgressHUD.setContainerView(self.view)
            SVProgressHUD.showInfo(withStatus: "Not Enough Data To Display Chart")
            return
        }
        
        guard let openingPrice = Double(pricePointsToday[0].price) else { return }
        
        for (i, pricePoint) in pricePointsToday.enumerated() {
            if i == 0 {
                
            } else {
                guard let price = Double(pricePoint.price) else { break }
                data.append((date: pricePoint.date, price: price))
            }
        }
        
        data.remove(at: 0)
        
        let dataPoints = EquityChartData(openingPrice: openingPrice, data: data.reversed())
        
        
        let newGraphView = GraphView(data: dataPoints)
        TopGraphView.addSubview(newGraphView)
        
        newGraphView.backgroundColor = .black
        newGraphView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints([
            NSLayoutConstraint(item: newGraphView, attribute: .bottom, relatedBy: .equal, toItem: TopGraphView, attribute: .bottom, multiplier: 0.9, constant: 0.0),
        NSLayoutConstraint(item: newGraphView, attribute: .leading, relatedBy: .equal, toItem: TopGraphView, attribute: .leading, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: newGraphView, attribute: .trailing, relatedBy: .equal, toItem: TopGraphView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: newGraphView, attribute: .height, relatedBy: .equal, toItem: TopGraphView, attribute: .height, multiplier: .graphHeightMultiplier, constant: 0.0)
        ])
    }
}

extension EquityInfoViewController: GraphViewDelegate {
  func didMoveToPrice(_ graphView: GraphView, price: Double) {
    //tickerControl.showNumber(price)
  }
}
