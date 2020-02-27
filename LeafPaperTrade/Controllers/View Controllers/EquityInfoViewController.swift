//
//  EquityInfoViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/26/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

private extension CGFloat {
  static let tickerHeightMultiplier: CGFloat = 0.4
  static let graphHeightMultiplier: CGFloat = 0.6
}

class EquityInfoViewController: UIViewController{
    
    // MARK: - Properties
    
    var equity: Equity? {
        didSet {
            updateGraph()
        }
    }
    
    private var graphData = EquityChartData.portfolioData
    
    lazy private var graphView: GraphView = {
        return GraphView(data: graphData)
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var TopGraphView: GraphView!
    
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView.backgroundColor = .white
        graphView.translatesAutoresizingMaskIntoConstraints = false
        graphView.delegate = self
        TopGraphView.addSubview(graphView)
        
        self.view.addConstraints([
            NSLayoutConstraint(item: graphView, attribute: .bottom, relatedBy: .equal, toItem: TopGraphView, attribute: .bottom, multiplier: 0.9, constant: 0.0),
        NSLayoutConstraint(item: graphView, attribute: .leading, relatedBy: .equal, toItem: TopGraphView, attribute: .leading, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: graphView, attribute: .trailing, relatedBy: .equal, toItem: TopGraphView, attribute: .trailing, multiplier: 1.0, constant: 0.0),
        NSLayoutConstraint(item: graphView, attribute: .height, relatedBy: .equal, toItem: TopGraphView, attribute: .height, multiplier: .graphHeightMultiplier, constant: 0.0)
        ])
    
    }
    
    // MARK: - Private Functions
    
    private func updateGraph() {
        
    }
}

extension EquityInfoViewController: GraphViewDelegate {
  func didMoveToPrice(_ graphView: GraphView, price: Double) {
    //tickerControl.showNumber(price)
  }
}
