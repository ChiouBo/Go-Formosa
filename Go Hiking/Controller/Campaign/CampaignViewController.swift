//
//  CampaignViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Kingfisher

class CampaignViewController: UIViewController {

    var filteredCampaign = [Campaign]()
    
    let campaigns = Campaign.getAllCampaigns()
    
    var eventData: [EventCurrent] = []
    
    lazy var publicTableView: UITableView = {
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
    
    @objc func toPrivateList() {
        
        let controller = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "Private")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func setNavVC() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Icons_24px_Explore")?.withRenderingMode(.alwaysOriginal),
            style: .done, target: self, action: #selector(toPrivateList))
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavVC()
        
        navigationItem.searchController = searchController
        
        publicTableView.separatorStyle = .none
        
        setupElements()
        
//        UploadEvent.shared.download { (result) in
//            
//            switch result {
//                
//            case .success(let data):
//                
//                print(data)
//                
//                self.eventData.append(data)
//                self.publicTableView.reloadData()
//            case .failure(let error):
//                
//                print(error)
//                
//            }
//        }
        
        
        
//        createGradientLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        eventData = []
        
        UploadEvent.shared.download { (result) in
            
            switch result {
                
            case .success(let data):
                
                print(data)
                
                self.eventData.append(data)
                self.publicTableView.reloadData()
            case .failure(let error):
                
                print(error)
                
            }
        }
    }
    
//        func createGradientLayer() {
//    
//            let background = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//    
//            let gradientLayer = CAGradientLayer()
//    
//            gradientLayer.frame = background.bounds
//    
//            gradientLayer.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor]
//    
//            view.layer.addSublayer(gradientLayer)
//        }

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredCampaign = campaigns.filter({ (campaign: Campaign) -> Bool in
        
            let doesCategoryMatch = (scope == "All") || (campaign.type == scope)
            
            if isSearchBarEmpty() {
                
                return doesCategoryMatch
            } else {
                
                return doesCategoryMatch && (campaign.title.lowercased().contains(searchText.lowercased()) || campaign.type.lowercased().contains(searchText.lowercased()))
            }
        })
        
        publicTableView.reloadData()
    }

    func isSearchBarEmpty() -> Bool {
        
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        
        return searchController.isActive && (!isSearchBarEmpty() || searchBarScopeIsFiltering)
    }
    
}
extension CampaignViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension CampaignViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchText: searchController.searchBar.text!, scope: scope)
    }
}

extension CampaignViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() { return eventData.count}
        
        return eventData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Campaign", for: indexPath) as?
            CampaignTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
//        let currentCampaign: Campaign
//
//        if isFiltering() {
//            currentCampaign = filteredCampaign[indexPath.row]
//        } else {
//            currentCampaign = campaigns[indexPath.row]
//        }
        
//        cell.campaignTitle.text = currentCampaign.title
//        cell.campaignLevel.text = currentCampaign.level
        
        cell.campaignTitle.text = eventData[indexPath.row].title
        cell.campaignLevel.text = eventData[indexPath.row].member
        cell.campaignImage.kf.setImage(with: URL(string: eventData[indexPath.row].image))
        cell.backgroundColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        
        animator.addAnimations {
            
            cell.alpha = 1
            cell.transform = .identity
            self.publicTableView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
}

extension CampaignViewController {
    
    func setupElements() {
        
        view.addSubview(publicTableView)
        publicTableView.backgroundColor = .black
        publicTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        publicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        publicTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        publicTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
