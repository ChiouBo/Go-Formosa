//
//  ChatViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MessageKit

class ChatViewController: UIViewController {
    
    var eventChat: [EventCurrent] = [] {
        
        didSet {
            
            self.chatTableView.reloadData()
        }
    }
    
    var currentUser: UserInfo?
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var chatTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatTableView.separatorStyle = .none
        chatTableView.contentMode = .scaleAspectFill
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
        
        getEvent()
        
        getUserInfo()
        
        setNavi()
        
        refreshData()
        
        setCustomBackground()
    }
    
    func setNavi() {
        
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "聊天"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func refreshData() {
        
        refreshControl = UIRefreshControl()
        chatTableView.addSubview(refreshControl)
        
        refreshControl.attributedTitle = NSAttributedString(string: "正在更新", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.addTarget(self, action: #selector(getAllData), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func getAllData() {
        
        getUserInfo()
        
        eventChat = []
        
        getEvent()
    }
    
    func getUserInfo() {
        
        UserManager.share.loadUserInfo { (userInfo) in
            
            switch userInfo {
                
            case .success(let user):
                
                self.currentUser = user
                
            case .failure(let error):
                
                print(error)
            }
            
        }
    }
    
    func getEvent() {
        
        UserManager.share.loadUserInfo { (userInfo) in
            
            switch userInfo {
                
            case .success(let user):
                
                user.event.forEach { ref in
                    ref.getDocument { (event, error) in
                        
                        if error == nil {
                            
                            guard let event = event else { return }
                            
                            do {
                                guard let eventChat = try event.data(as: EventCurrent.self, decoder: Firestore.Decoder()) else { return }
                                
                                self.eventChat.append(eventChat)
                                
                            } catch {
                                
                                print(error)
                            }
                        }
                    }
                }
                
                user.eventCreate.forEach { ref in
                    ref.getDocument { (event, error) in
                        
                        if error == nil {
                            
                            guard let event = event else { return }
                            
                            do {
                                guard let eventChat = try event.data(as: EventCurrent.self, decoder: Firestore.Decoder()) else { return }
                                
                                self.eventChat.append(eventChat)
                                
                            } catch {
                                
                                print(error)
                            }
                        }
                    }
                }
                
            case .failure(let error):
                
                print(error)
            }
            
            self.chatTableView.reloadData()
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func setNavBar() {
        
        navigationController?.navigationBar.barStyle = .black
        
        let navBarNude = UIImage()
        
        navigationController?.navigationBar.setBackgroundImage(navBarNude, for: .default)
        
        self.navigationController?.navigationBar.shadowImage = navBarNude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.3)
        
        animator.addAnimations {
            
            cell.alpha = 1
            cell.transform = .identity
            
            self.chatTableView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.1 * Double(indexPath.item))
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let roomCell = tableView.dequeueReusableCell(withIdentifier: "Chatroom", for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
            
        }
        
        roomCell.selectionStyle = .none
        
        roomCell.groupImage.loadImage(eventChat[indexPath.row].image)
        
        roomCell.groupName.text = eventChat[indexPath.row].title
        
        return roomCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let channel = UIStoryboard(name: "Chat", bundle: nil)
        
        guard let chatVC = channel.instantiateViewController(withIdentifier: "Chatroom") as? MessageViewController else {
            return
            
        }
        
        let data = eventChat[indexPath.row]
        
        let current = currentUser
        
        chatVC.userInfo = data
        
        chatVC.user = current
        
        show(chatVC, sender: nil)
    }
    
}
