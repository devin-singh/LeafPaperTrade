//
//  PositionTableViewCell.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/16/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class PositionTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var positionChangeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var numSharesLabel: UILabel!
    
    // MARK: - Functions
    
    func updateWith(ticker: String, numShares: Int) {
        
        
    }

}
