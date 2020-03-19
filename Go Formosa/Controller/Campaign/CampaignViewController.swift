//
//  CampaignViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import Kingfisher

class CampaignViewController: UIViewController {

    var eventList: [EventCurrent] = []
    
    var eventData: [EventCurrent] = []
    
    var filteredEvent: [EventCurrent] = [] {
        
        didSet {
            
            publicTableView.reloadData()
        }
    }
    
    var refreshControl: UIRefreshControl!
    
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
//        search.searchBar.scopeButtonTitles = ["All", "Hiking", "Running", "Cycling"]
        search.searchBar.delegate = self
        return search
    }()
    
    @objc func toPrivateList() {
        
        if Auth.auth().currentUser != nil {
            
            let controller = self.navigationController?.storyboard?.instantiateViewController(withIdentifier: "Private")
            self.navigationController?.pushViewController(controller!, animated: true)
        } else {
            
            let alertController = UIAlertController(title: "您尚未登入", message: "是否登入以繼續？", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "登入", style: .default) { (_) in
                
                if let authVC = UIStoryboard.auth.instantiateInitialViewController() {
                    
                    authVC.modalPresentationStyle = .overCurrentContext
                    
                    self.present(authVC, animated: false, completion: nil)
                }
            }
            
            alertController.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNavVC() {
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.title = "活動"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Icon_Flag")?.withRenderingMode(.alwaysOriginal),
            style: .done, target: self, action: #selector(toPrivateList))
        navigationController?.navigationBar.barTintColor = .clear
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func refreshData() {

        refreshControl = UIRefreshControl()
        publicTableView.addSubview(refreshControl)

        refreshControl.attributedTitle = NSAttributedString(string: "正在更新", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(getAllData), for: UIControl.Event.valueChanged)

    }
    
    @objc func getAllData() {
        
        filteredEvent = []
        
        eventData = []
        
        getEventData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavVC()
        
        setCustomBackground()
    
        navigationItem.searchController = searchController
        
        publicTableView.separatorStyle = .none
        
        publicTableView.backgroundColor = .red
        
        getEventData()
        
        setupElements()
        
        refreshData()
    }

    func getEventData() {
        
        UploadEvent.shared.download { (result) in
            
            switch result {
                
            case .success(let data):
                
                print(data)
                
                self.filteredEvent.append(data)
                self.eventData.append(data)

            case .failure(let error):
                
                print(error)
            }
            self.publicTableView.reloadData()

            self.refreshControl.endRefreshing()
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
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
        filterContentForSearchText(searchText: searchBar.text!)
//            , scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension CampaignViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
//        let searchBar = searchController.searchBar
//        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
//            , scope: scope)
    }
}

extension CampaignViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if isFiltering() { return filteredEvent.count}
        
        return filteredEvent.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 4.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Campaign", for: indexPath) as?
            CampaignTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.campaignTitle.text = "  \(filteredEvent[indexPath.row].title)"
        cell.campaignMember.text = "參加人數 \(filteredEvent[indexPath.row].memberList.count) 人"
        cell.campaignLevel.text = filteredEvent[indexPath.row].start
        cell.campaignImage.kf.setImage(with: URL(string: filteredEvent[indexPath.row].image))
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let content = UIStoryboard(name: "Campaign", bundle: nil)
        guard let contentVC = content.instantiateViewController(withIdentifier: "EventContent") as? ContentViewController else { return }
        
        let data = filteredEvent[indexPath.row]
        
        contentVC.eventDict = data
        
        show(contentVC, sender: nil)
    }
}

extension CampaignViewController {
    
    func setupElements() {
        
        view.addSubview(publicTableView)
        publicTableView.backgroundColor = .clear
        publicTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        publicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        publicTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        publicTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
