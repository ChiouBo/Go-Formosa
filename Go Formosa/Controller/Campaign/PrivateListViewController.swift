//
//  PrivateListViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

class PrivateListViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = CreateTransition()
    //
    //    var filteredCampaign = [Campaign]()
    //
    //    let campaigns = Campaign.getAllCampaigns()
    
    var eventAll: EventCurrent?
    
    var eventList = [EventCurrent]()
    
    var eventData = [EventCurrent]()
    
    var filteredEvent: [EventCurrent] = [] 
    
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
        //        search.searchBar.scopeButtonTitles = ["All", "Hiking", "Running", "Cycling"]
        search.searchBar.delegate = self
        return search
    }()
    
    lazy var createBtn: UIButton = {
        let create = UIButton()
        create.translatesAutoresizingMaskIntoConstraints = false
        create.setImage(UIImage(named: "Icon_Plus"), for: .normal)
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
    
    func setNavVC() {
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.title = "我的活動"
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = .clear
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        
        privateTableView.separatorStyle = .none
 
        setCustomBackground()
        
        setupElements()
        
        setNavVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        eventData = []
        
        filteredEvent = []
        
        getEventData()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        privateTableView.reloadData()
    }
    
    func getEventData() {
        
        UploadEvent.shared.loadPrivate { (result) in
            
            switch result {
                
            case .success(let data):
                
                print(data)
                
                self.filteredEvent.append(data)
                self.eventData.append(data)
                
                self.privateTableView.reloadData()
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        //        filteredCampaign = campaigns.filter({ (campaign: Campaign) -> Bool in
        //
        //            let doesCategoryMatch = (scope == "All") || (campaign.type == scope)
        //
        //            if isSearchBarEmpty() {
        //
        //                return doesCategoryMatch
        //            } else {
        //
        //                return doesCategoryMatch && (campaign.title.lowercased().contains(searchText.lowercased()) || campaign.type.lowercased().contains(searchText.lowercased()))
        //            }
        //        })
        
        filteredEvent = []
        
        filteredEvent = eventData.filter({ (event: EventCurrent) -> Bool in
            
            let doesCategoryMatch = (scope == "All")
            
            if searchText.isEmpty {
                
                return doesCategoryMatch
            } else {
                
                return doesCategoryMatch &&
                    event.title.lowercased().contains(searchText.lowercased())
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
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
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
        filterContentForSearchText(searchText: searchBar.text!)
        //            , scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension PrivateListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        //        let searchBar = searchController.searchBar
        //        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        //            , scope: scope)
    }
}

extension PrivateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if isFiltering() { return filteredCampaign.count}
        
        //        return campaigns.count
        
        return filteredEvent.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 4.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Campaign", for: indexPath) as?
            CampaignTableViewCell else {
                return UITableViewCell()
                
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        cell.campaignTitle.text = "  \(filteredEvent[indexPath.row].title)"
        cell.campaignMember.text = "參加人數 \(filteredEvent[indexPath.row].memberList.count) 人"
        cell.campaignLevel.text = filteredEvent[indexPath.row].start
        cell.campaignImage.kf.setImage(with: URL(string: filteredEvent[indexPath.row].image))
        
        cell.campaignDelete.isHidden = false
        
        cell.deleteEventHandler = {
            
            UploadEvent.shared.removeEvent(event: self.filteredEvent[indexPath.row].eventID) { (result) in
                
                switch result {
                    
                case .success:
                    
                    self.filteredEvent.remove(at: indexPath.row)
                    
                    self.privateTableView.deleteRows(at: [indexPath], with: .right)
                    
                    self.privateTableView.reloadData()
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let content = UIStoryboard(name: "Campaign", bundle: nil)
        
        guard let contentVC = content.instantiateViewController(withIdentifier: "EventContent") as? ContentViewController else {
            return
            
        }
        
        let data = filteredEvent[indexPath.row]
        
        contentVC.eventDict = data
        
        show(contentVC, sender: nil)
    }
}

extension PrivateListViewController {
    
    func setupElements() {
        
        view.addSubview(privateTableView)
        view.addSubview(createBtn)
        
        privateTableView.backgroundColor = .clear
        privateTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        privateTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        privateTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        privateTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        createBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        createBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        createBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        createBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
