//
//  PrivateListViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PrivateListViewController: UIViewController {
    
    var filteredCampaign = [Campaign]()
    
    let campaigns = Campaign.getAllCampaigns()
    
    lazy var privateTableView: UITableView = {
        let pTV = UITableView()
        let pCell = UINib(nibName: "CampaignTableViewCell", bundle: nil)
        pTV.translatesAutoresizingMaskIntoConstraints = false
        pTV.delegate = self
        pTV.dataSource = self
        pTV.register(pCell, forCellReuseIdentifier: "Campaign")
        pTV.rowHeight = UITableView.automaticDimension
        return pTV
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "請輸入活動關鍵字"
        search.searchBar.sizeToFit()
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.scopeButtonTitles = ["All", "Easy", "Medium", "Hard"]
        search.searchBar.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.self
        
        self.title = "我的活動"
        navigationItem.searchController = searchController
        
        privateTableView.separatorStyle = .none
        
        setupElements()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredCampaign = campaigns.filter({ (campaign: Campaign) -> Bool in
            
            let doesCategoryMatch = (scope == "All") || (campaign.level == scope)
            
            if isSearchBarEmpty() {
                
                return doesCategoryMatch
            } else {
                
                return doesCategoryMatch && (campaign.title.lowercased().contains(searchText.lowercased()) || campaign.level.lowercased().contains(searchText.lowercased()))
            }
        })
        
        privateTableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
}
extension PrivateListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension PrivateListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension PrivateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() { return filteredCampaign.count}
        
        return campaigns.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Campaign", for: indexPath) as?
            CampaignTableViewCell else { return UITableViewCell() }
        
        let currentCampaign: Campaign
        
        if isFiltering() {
            currentCampaign = filteredCampaign[indexPath.row]
        } else {
            currentCampaign = campaigns[indexPath.row]
        }
        
        cell.campaignTitle.text = currentCampaign.title
        cell.campaignLevel.text = currentCampaign.level
        
        return cell
    }
}

extension PrivateListViewController {
    
    func setupElements() {
        
        view.addSubview(privateTableView)
        
        privateTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        privateTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        privateTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        privateTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
