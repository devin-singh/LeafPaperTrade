//
//  SearchResultTableViewCell.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var addToWatchListButton: UIButton!
    
    @IBOutlet weak var equityNameLabel: UILabel!
    @IBOutlet weak var equitySymbolLabel: UILabel!
    
    
    // MARK: - Actions
    
    @IBAction func addToWatchListButtonPressed(_ sender: Any) {
        addToWatchListButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
    }
}
