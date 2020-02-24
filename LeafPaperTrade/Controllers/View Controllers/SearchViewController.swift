//
//  SearchViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var equties: [Equity] = [] {
        didSet {
            //loadViewIfNeeded()
            self.searchResultTableView.reloadData()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchViewSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        searchViewSearchBar.delegate = self
    }
    
    
    
    // MARK: - Private Functions
    func grabEquities(withSearchTerm searchTerm: String) {
        
        EquitySearchModelController.getEquities(withSearchTerm: searchTerm) { (result) in
            switch result {
            case .success(let equities):
                DispatchQueue.main.async {
                    self.equties = equities
                    
                }
            case .failure(let error):
                print(error.errorDescription ?? error.localizedDescription)
            }
        }
    }
}


// MARK: - UITableViewDataSource Functions

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.equties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") else { return UITableViewCell() }
        
        cell.textLabel?.text = equties[indexPath.row].symbol
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 12
    }
    
    
}

// MARK: - SearchBarDelegate Functions

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchViewSearchBar.layoutIfNeeded()
        self.searchViewSearchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchViewSearchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchViewSearchBar.layoutIfNeeded()
        self.searchViewSearchBar.setShowsCancelButton(false, animated: true)
        self.searchViewSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchViewSearchBar.endEditing(true)
        guard let searchTerm = searchViewSearchBar.text, !searchTerm.isEmpty else { return }
        grabEquities(withSearchTerm: searchTerm)
    }
}
