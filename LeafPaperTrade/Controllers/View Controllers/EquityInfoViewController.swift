//
//  EquityInfoViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import SVProgressHUD
import QuickTicker

private extension CGFloat {
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
    
    // MARK: - Outlets
    
    @IBOutlet weak var TopGraphView: GraphView!
    
    @IBOutlet weak var tickerLabel: UILabel!
    
    @IBOutlet weak var stockSymbolLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setContainerView(self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Private Functions
    
    private func updatePricePoints() {
        SVProgressHUD.show(withStatus: "Loading")
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
        
        if data.count == 0 { return }
        data.remove(at: 0)
        
        let dataPoints = EquityChartData(openingPrice: openingPrice, data: data.reversed())
        
        let newGraphView = GraphView(data: dataPoints)
        newGraphView.delegate = self
        TopGraphView.addSubview(newGraphView)
        
        newGraphView.backgroundColor = .black
        newGraphView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints([
            NSLayoutConstraint(item: newGraphView, attribute: .bottom, relatedBy: .equal, toItem: TopGraphView, attribute: .bottom, multiplier: 0.9, constant: 0.0),
            NSLayoutConstraint(item: newGraphView, attribute: .leading, relatedBy: .equal, toItem: TopGraphView, attribute: .leading, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: newGraphView, attribute: .trailing, relatedBy: .equal, toItem: TopGraphView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: newGraphView, attribute: .height, relatedBy: .equal, toItem: TopGraphView, attribute: .height, multiplier: .graphHeightMultiplier, constant: 0.0)
        ])
        
        tickerLabel.text = "\(dataPoints.openingPrice)"
        stockSymbolLabel.text = equity?.symbol
        SVProgressHUD.dismiss()
    }
}

extension EquityInfoViewController: GraphViewDelegate {
    func didMoveToPrice(_ graphView: GraphView, price: Double) {
        QuickTicker.animate(label: tickerLabel, toEndValue: formatPrice(price: price), duration: 0.3, options: [.easeOut])
    }
    
    private func formatPrice(price: Double) -> Double {
        Double(round(100*price)/100)
    }
    
}
