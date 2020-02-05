//
//  TrailViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

struct Buttons {
    var buttons: [String]
}

class TrailViewController: UIViewController {
    
    var trailResponse = TrailResponse()
    
    var trailListData = [Trail]()
    
    var trailFilter = [Trail]()
    
    let filter = FilterItemManager()
    
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
        search.searchBar.delegate = self
        return search
    }()
    
    lazy var filterView: UICollectionView = {
        
        let layoutObject = UICollectionViewFlowLayout.init()
        let filter = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutObject)
        let filterButton = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        filter.translatesAutoresizingMaskIntoConstraints = false
        filter.backgroundColor = UIColor.T4
        filter.delegate = self
        filter.dataSource = self
        filter.register(filterButton, forCellWithReuseIdentifier: "Filter")
        filter.isScrollEnabled = true
        layoutObject.scrollDirection = .vertical
        return filter
    }()
    
    @objc func filterBtn() {
        
//        let controller = self.navigationController?.storyboard?.instantiateViewController(identifier: "Private")
//        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func setNavVC() {
        
        navigationController?.navigationBar.self
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Icons_24px_Sorting")?.withRenderingMode(.alwaysOriginal),
            style: .done, target: self, action: #selector(filterBtn))
        navigationController?.navigationBar.barTintColor = UIColor.T4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        
        trailResponse.delegate = self
        trailResponse.getTrailListData()
        
        trailTableView.separatorStyle = .none
        
        setupElements()
        
        setNavVC()
    }
    
    // MARK: - Filter for Search
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

// MARK: - SearchBar
extension TrailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
}

extension TrailViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

// MARK: - TableViewDelegate, TableViewDataSource
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let trail = UIStoryboard(name: "Trail", bundle: nil)
        guard let trailVC = trail.instantiateViewController(identifier: "TrailDetail") as? TrailDetailViewController else { return }
        
        show(trailVC, sender: nil)
        
    }
}

// MARK: - CollectionViewDelegate, CollectionViewDataSource
extension TrailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return filter.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filter.groups[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        guard let filterCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Filter", for: indexPath)
            as? FilterCollectionViewCell else {
                return UICollectionViewCell() }

        let item = filter.groups[indexPath.section].items[indexPath.row]
        
        filterCell.layoutCell(title: item.filterButton)
        
        return filterCell
    }
}

extension TrailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            return CGSize(width: UIScreen.main.bounds.width / 4.0, height: 40.0)
        
        } else if indexPath.section == 1 && indexPath.row == 0 {
            
            return CGSize(width: UIScreen.main.bounds.width / 4.0, height: 40.0)
            
        } else if indexPath.section == 0 {
            
            return CGSize(width: UIScreen.main.bounds.width / 7.0, height: 40.0)
        } else  {
            
            return CGSize(width: UIScreen.main.bounds.width / 5.2, height: 40.0)
        }
        
        return CGSize.zero
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10.0, left: 35, bottom: 0, right: 35)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 20.0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 0
    }
}

// MARK: - Trail DataSource API
extension TrailViewController: TrailResponseDelegate {
    
    func response(_ response: TrailResponse, get trailListData: [Trail]) {
        
        self.trailListData = trailListData
        
        self.trailFilter = trailListData
        
        DispatchQueue.main.async {
            
            self.trailTableView.reloadData()
        }
    }
}

// MARK: - ViewConstrants
extension TrailViewController {
    
    func setupElements() {
        
        view.addSubview(trailTableView)
        view.addSubview(filterView)
        
        trailTableView.topAnchor.constraint(equalTo: filterView.bottomAnchor).isActive = true
        trailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        filterView.bottomAnchor.constraint(equalTo: trailTableView.topAnchor).isActive = true
        filterView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        filterView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        filterView.heightAnchor.constraint(equalToConstant: 110).isActive = true
    }
    
}

// 收起filter, filter功能, 按鈕變色
