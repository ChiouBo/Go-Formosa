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

    var eventList = [EventCurrent]()
    
    var eventData = [EventCurrent]()
    
    var filteredEvent: [EventCurrent] = [] {
        
        didSet {
            
            publicTableView.reloadData()
        }
    }
    
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
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Icons_24px_Explore")?.withRenderingMode(.alwaysOriginal),
            style: .done, target: self, action: #selector(toPrivateList))
        navigationController?.navigationBar.barTintColor = .clear
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func customizebackgroundView() {
          
          let bottomColor = UIColor(red: 9/255, green: 32/255, blue: 63/255, alpha: 1)
          let topColor = UIColor(red: 59/255, green: 85/255, blue: 105/255, alpha: 1)
          let gradientColors = [bottomColor.cgColor, topColor.cgColor]
          
          let gradientLocations:[NSNumber] = [0.3, 1.0]
          
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = gradientColors
          gradientLayer.locations = gradientLocations
//          gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//          gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
          gradientLayer.frame = self.view.frame
          self.view.layer.insertSublayer(gradientLayer, at: 0)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavVC()
        
        customizebackgroundView()
        
        navigationItem.searchController = searchController
        
        publicTableView.separatorStyle = .none
        
        setupElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        eventData = []
        
        filteredEvent = []
        
        getEventData()
        
//        navigationController?.setNavigationBarHidden(false, animated: false)
        
        publicTableView.reloadData()
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

//        let dateformat = DateFormatter()
//        
//        dateformat.dateFormat = "yyyy年 MM月 dd日 EE"
//        
//        let monthDay = dateformat.date(from: filteredEvent[indexPath.row].start)
        
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
        publicTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        publicTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        publicTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        publicTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
