//
//  SearchViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 2/24/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import SVProgressHUD

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var equities: [Equity] = [] {
        didSet {
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
                    self.equities = equities
                    SVProgressHUD.dismiss()
                    if self.equities.count == 0 {
                        SVProgressHUD.showInfo(withStatus: "No Results Found")
                        SVProgressHUD.dismiss(withDelay: 0.5)
                    }
                    
                }
            case .failure(let error):
                print(error.errorDescription ?? error.localizedDescription)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toEquityDetailVC" {
            guard let destinationVC = segue.destination as? EquityInfoViewController, let indexPath = searchResultTableView.indexPathForSelectedRow else { return }
               
            let equityToSend = self.equities[indexPath.row]
            destinationVC.equity = equityToSend
           }
       }
    
}// End of Class

// MARK: - UITableViewDataSource Extension

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.equities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? SearchResultTableViewCell else { return UITableViewCell() }
        
        let equity = equities[indexPath.row]
        
        cell.equityNameLabel.text = equity.name
        cell.equitySymbolLabel.text = equity.symbol
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 12
    }
    
}

// MARK: - SearchBarDelegate Extension

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchViewSearchBar.layoutIfNeeded()
        self.searchViewSearchBar.setShowsCancelButton(true, animated: true)
        SVProgressHUD.setContainerView(self.view)
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
        SVProgressHUD.show(withStatus: "Loading")
        self.searchViewSearchBar.endEditing(true)
        guard let searchTerm = searchViewSearchBar.text, !searchTerm.isEmpty else { return }
        grabEquities(withSearchTerm: searchTerm)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            equities = []
        }
    }
}
