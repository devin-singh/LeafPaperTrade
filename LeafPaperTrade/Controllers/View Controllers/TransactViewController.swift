//
//  TransactViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/6/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class TransactViewController: UIViewController {
    
    // MARK: - Properties
    
    var equity: Equity? {
        didSet {
            loadViewIfNeeded()
            updateSymbolAndDetailLabels()
        }
    }
    var transactionType: Transaction? {
        didSet {
            loadViewIfNeeded()
            updateTransactionItems()
        }
    }
    
    // MARK: - Outlets

    @IBOutlet weak var symbolTicker: UILabel!
    @IBOutlet weak var canBuyLabel: UILabel!
    @IBOutlet weak var transactButton: UIButton!
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private functions
    
    private func updateSymbolAndDetailLabels() {
        guard let equity = equity else { return }
        symbolTicker.text = equity.name
        
        EquityPriceController.getQuote(forEquity: equity) { (result) in
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self.canBuyLabel.text = "Last Price: $\(quote.price)"
                }
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    private func updateTransactionItems() {
        guard let transactionType = transactionType else { return }
        
        if transactionType == .buy {
            transactButton.setTitle("Buy", for: .normal)
        } else {
            transactButton.setTitle("Sell", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func transactButtonPressed(_ sender: Any) {
        //SVProgressHUD.setContainerView(self.view)
        

        
        self.dismiss(animated: true)
    }
    
}
