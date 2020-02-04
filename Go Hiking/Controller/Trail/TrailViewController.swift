//
//  TrailViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailViewController: UIViewController {
    
    var trailResponse = TrailResponse()
    
    var trailListData = [Trail]()
    
    var trailFilter = [Trail]()
    
//    var filteredCampaign = [Campaign]()
//
//    let campaigns = Campaign.getAllCampaigns()
    
    lazy var trailTableView: UITableView = {
        let tTV = UITableView()
        let tCell = UINib(nibName: "TrailTableViewCell", bundle: nil)
        tTV.translatesAutoresizingMaskIntoConstraints = false
        tTV.delegate = self
        tTV.dataSource = self
        tTV.register(tCell, forCellReuseIdentifier: "Trail")
        tTV.rowHeight = UITableView.automaticDimension
        return tTV
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "請輸入活動關鍵字"
        search.searchBar.sizeToFit()
        search.searchBar.searchBarStyle = .prominent
//        search.searchBar.scopeButtonTitles = ["All", "Easy", "Medium", "Hard"]
        search.searchBar.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.self
        navigationItem.searchController = searchController
        
        trailResponse.delegate = self
        trailResponse.getTrailListData()
        
        trailTableView.separatorStyle = .none
        
        setupElements()
    }
  
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        trailFilter = trailListData.filter({ (trail: Trail) -> Bool in
            let doesCategoryMatch = (scope == "All")

            if searchText.isEmpty {

                return doesCategoryMatch
            } else {
                if trail.trPosition != nil {
                return doesCategoryMatch && (trail.trCname.lowercased().contains(searchText.lowercased()) || trail.trPosition?.lowercased().contains(searchText.lowercased()) ?? true)
                }
                return doesCategoryMatch && trail.trCname.lowercased().contains(searchText.lowercased())
            }
        })

        trailTableView.reloadData()
    }
    
    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
}
extension TrailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension TrailViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
//        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension TrailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trailFilter.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Trail", for: indexPath) as?
            TrailTableViewCell else { return UITableViewCell() }


        if trailFilter[indexPath.row].trPosition != nil {
        cell.trailTitle.text = trailFilter[indexPath.row].trCname
        cell.trailPosition.text = trailFilter[indexPath.row].trPosition
        cell.trailLevel.text = "難易度：\(trailFilter[indexPath.row].trDIFClass ?? "")"
        cell.trailLength.text = "全程約 \(trailFilter[indexPath.row].trLength) "
        }
        return cell
    }
}

extension TrailViewController: TrailResponseDelegate {
    
    func response(_ response: TrailResponse, get trailListData: [Trail]) {
        
        self.trailListData = trailListData
        
        self.trailFilter = trailListData
        
        DispatchQueue.main.async {
            
            self.trailTableView.reloadData()
        }
    }
}

extension TrailViewController {
    
    func setupElements() {
        
        view.addSubview(trailTableView)
        
        trailTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
