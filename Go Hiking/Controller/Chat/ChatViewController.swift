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
    
    private let db = Firestore.firestore()
    
//    private var channelReference: CollectionReference {
//        return db.collection("channels")
//    }
//
//    private var channels = [Channel]()
//
//    private var channelListener: ListenerRegistration?
//
//    deinit {
//        channelListener?.remove()
//    }
//

    
    var eventChat: [EventCurrent] = [] {
        
        didSet {
            
            self.chatTableView.reloadData()
        }
    }
    
    @IBOutlet weak var chatTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        getEvent()
        setNavBar()
    }
    
    func setTableView() {
        
        chatTableView.separatorStyle = .none
        chatTableView.contentMode = .scaleAspectFill
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.rowHeight = UITableView.automaticDimension
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
        }
    }
    
    func setNavBar() {
        navigationController?.navigationBar.barStyle = .black
        
        let navBarNude = UIImage()
        navigationController?.navigationBar.setBackgroundImage(navBarNude, for: .default)
        self.navigationController?.navigationBar.shadowImage = navBarNude
    }
 
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventChat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let roomCell = tableView.dequeueReusableCell(withIdentifier: "Chatroom", for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        
        roomCell.selectionStyle = .none
        roomCell.groupImage.loadImage(eventChat[indexPath.row].image)
        roomCell.groupName.text = eventChat[indexPath.row].title
        
        return roomCell
    }
    
    
    
}


//    func customizebackgroundView() {
//
//        let topColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
//        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
//        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
//
//        let gradientLocations:[NSNumber] = [0.4, 1.0]
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations
//
//        gradientLayer.frame = self.view.frame
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
//    func customizebackground() {
//
//        let topColor = UIColor(red: 51/255, green: 8/255, blue: 103/255, alpha: 1)
//        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
//        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
//
//        let gradientLocations:[NSNumber] = [0.3, 1.0]
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations
//
//        gradientLayer.frame = self.view.frame
//        self.view.layer.insertSublayer(gradientLayer, at: 0)
//    }
