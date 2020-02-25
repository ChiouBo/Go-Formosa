//
//  PrivateListViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PrivateListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = CreateTransition()
    
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
        search.searchBar.scopeButtonTitles = ["All", "Hiking", "Running", "Cycling"]
        search.searchBar.delegate = self
        return search
    }()
    
    lazy var createBtn: UIButton = {
       let create = UIButton()
        create.translatesAutoresizingMaskIntoConstraints = false
        create.setImage(UIImage(named: "Icons_48px_Add"), for: .normal)
        create.addTarget(self, action: #selector(toCreateVC), for: .touchUpInside)
        return create
    }()
    
    @objc func toCreateVC(sender: UIButton) {
        let createEvent = UIStoryboard(name: "Create", bundle: nil)
        guard let createVC = createEvent.instantiateViewController(withIdentifier: "CREATE") as? CreateViewController else { return }
        
        createVC.data = EventContent(image: [], title: "", desc: "", start: "", end: "", amount: "", location: "")
        
        createVC.transitioningDelegate = self
        createVC.modalPresentationStyle = .custom
        present(createVC, animated: true, completion: nil)
        
    }
    
    func customizebackgroundView() {
              
              let bottomColor = UIColor(red: 9/255, green: 32/255, blue: 63/255, alpha: 1)
              let topColor = UIColor(red: 59/255, green: 85/255, blue: 105/255, alpha: 1)
              let gradientColors = [bottomColor.cgColor, topColor.cgColor]
              
              let gradientLocations:[NSNumber] = [0.3, 1.0]
              
              let gradientLayer = CAGradientLayer()
              gradientLayer.colors = gradientColors
              gradientLayer.locations = gradientLocations
              gradientLayer.frame = self.view.frame
              self.view.layer.insertSublayer(gradientLayer, at: 0)
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        navigationItem.searchController = searchController
        
        privateTableView.separatorStyle = .none
        
        customizebackgroundView()
        
        setupElements()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredCampaign = campaigns.filter({ (campaign: Campaign) -> Bool in
            
            let doesCategoryMatch = (scope == "All") || (campaign.type == scope)
            
            if isSearchBarEmpty() {
                
                return doesCategoryMatch
            } else {
                
                return doesCategoryMatch && (campaign.title.lowercased().contains(searchText.lowercased()) || campaign.type.lowercased().contains(searchText.lowercased()))
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
    
    // MARK: - Transition
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning {
        
        transition.transitionMode = .present
        transition.startingPoint = createBtn.center
        transition.circleColor = UIColor.white
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        transition.startingPoint = createBtn.center
        transition.circleColor = UIColor.white
        
        return transition
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
        
//        return campaigns.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Campaign", for: indexPath) as?
            CampaignTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        let currentCampaign: Campaign
        
        if isFiltering() {
            currentCampaign = filteredCampaign[indexPath.row]
        } else {
            currentCampaign = campaigns[indexPath.row]
        }
        
//        cell.campaignTitle.text = currentCampaign.title
//        cell.campaignLevel.text = currentCampaign.type
        cell.backgroundColor = .clear
        
        return cell
    }
}

extension PrivateListViewController {
    
    func setupElements() {
        
        view.addSubview(privateTableView)
        view.addSubview(createBtn)
        
        privateTableView.backgroundColor = .clear
        privateTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        privateTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        privateTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        privateTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        createBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        createBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
