//
//  HomePageViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var portfolioValueLabel: UILabel!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePortfolioLabel()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
    }
    
    // MARK: - Private Functions
    
    private func updatePortfolioLabel() {
        
    }
}
