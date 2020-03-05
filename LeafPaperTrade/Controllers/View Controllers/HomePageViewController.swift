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
        
        let ref = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("Users/\(uid)/Portfolio Value").observe(.value, with: { (snapshot) in
            guard let portfolioValue = snapshot.value as? String else { return }
            
            DispatchQueue.main.async {
                self.portfolioValueLabel.text = portfolioValue
            }
        })
    }
    
    // MARK: - Private Functions
    
    private func updatePortfolioLabel() {
        
    }
}
