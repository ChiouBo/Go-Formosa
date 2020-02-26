//
//  ContentViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/24.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase

class ContentViewController: UIViewController {

    @IBOutlet weak var createrInfo: UIButton!
    
    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    @IBAction func createrInfo(_ sender: UIButton) {
        
        
    }
    
    let imageOriginHeight: CGFloat = 300
    
    var eventDict: EventCurrent?
    
    var userDict: User?
    
    var reqDict: [User] = []
    
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
    
    func loadUserInfo() {
        
        UserManager.share.loadUserInfo { (result) in
            
            switch result {
                
            case .success(let user):
                
                self.userDict = user
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleImage()
        
        setElement()
        
        loadReqUsers()
        
        loadUserInfo()
        
        customizebackgroundView()
    }
    
    func titleImage() {
        
        guard let photo = eventDict?.image else { return }
        
        contentImage.loadImage(photo)
    }
    
    func loadReqUsers() {
        
        guard let eventData = eventDict else { return }
        
        UploadEvent.shared.loadRequestUserInfo(event: eventData) { (result) in
            
            switch result {
                
            case .success(let users):
                
                print(users)
                
                self.reqDict.append(users)
                
                self.contentTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func setElement() {
        
        view.addSubview(contentTableView)
        contentTableView.addSubview(contentImage)
        
        contentTableView.backgroundColor = .clear
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UINib(nibName: "RequestTableViewCell", bundle: nil), forCellReuseIdentifier: "Request")
        contentTableView.rowHeight = UITableView.automaticDimension
        contentTableView.contentInset = UIEdgeInsets(top: imageOriginHeight, left: 0, bottom: 0, right: 0)
        contentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        imageHeightConstraint = contentImage.heightAnchor.constraint(equalToConstant: 300)
        imageHeightConstraint?.isActive = true
        contentImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        contentTableView.separatorStyle = .none
        
        createrInfo.layer.cornerRadius = 25
        createrInfo.layer.borderWidth = 2
        createrInfo.layer.borderColor = UIColor.white.cgColor
//        createrInfo.setImage(eventDict?., for: )
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let originOffsetY = -imageOriginHeight
        let moveDistance = abs(scrollView.contentOffset.y - originOffsetY)
        
        if scrollView.contentOffset.y < originOffsetY {
            
            imageHeightConstraint?.constant = imageOriginHeight + moveDistance
            
            contentTableView.backgroundColor = UIColor.clear
        } else {
            
            imageHeightConstraint?.constant = imageOriginHeight
            
            contentTableView.backgroundColor = UIColor(white: 0, alpha: moveDistance / imageOriginHeight)
        }
    }

}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Auth.auth().currentUser?.uid == eventDict?.creater, reqDict.count != 0 {
            
            return (eventDict?.waitingList.count ?? 0) + 1
            
        } else if eventDict?.waitingList.count == 0 {
            
            return 1
            
         } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as? ContentTableViewCell else {
                return UITableViewCell()
                
            }
            
            guard let eventData = eventDict else { return UITableViewCell()}
            
            cell.selectionStyle = .none
            
            cell.contentTitle.text = eventDict?.title
            cell.contentLocation.text = ""
            cell.contentDate.text = "\(eventDict?.start ?? "") - \(eventDict?.end ?? "")"
            cell.contentDesc.text = eventDict?.desc
            cell.contentMember.text = "夥伴 \(eventDict?.member ?? "")"
            
            cell.contentJoin.addTarget(self, action: #selector(requestEvent), for: .touchUpInside)
            
            guard let user = Auth.auth().currentUser?.uid else { return UITableViewCell() }
            
            if Auth.auth().currentUser?.uid != eventDict?.creater {
                
                cell.contentJoin.isHidden = false
                
                if (eventData.requestList.contains(user)) {
                    
                    cell.contentJoin.backgroundColor = .gray
                    cell.contentJoin.setTitle("申請已送出", for: .normal)
                    cell.contentJoin.isEnabled = false
                }
                
            } else {
                cell.contentJoin.isHidden = true
            }
            
            return cell
            
        } else {
            
            guard let reqCell = tableView.dequeueReusableCell(withIdentifier: "Request", for: indexPath) as? RequestTableViewCell else {
                return UITableViewCell()
                
            }
            
            reqCell.selectionStyle = .none
            
            guard let eventData = eventDict else {
                return UITableViewCell()
                
            }
            
            if Auth.auth().currentUser?.uid == eventData.creater {
                
                
                
                reqCell.reqUserImage.loadImage(reqDict[indexPath.row - 1].picture)
                
                reqCell.reqUserName.text = "\(reqDict[indexPath.row - 1].name) 想要加入活動"
                        
                }
            
            reqCell.currentCell = {
                
                let reqUid = self.reqDict[indexPath.row - 1].id
                
                UploadEvent.shared.acceptRequestUser(event: eventData, uid: reqUid) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        self.reqDict.remove(at: indexPath.row - 1)
                        
                        self.contentTableView.deleteRows(at: [indexPath], with: .right)
                        
                        self.contentTableView.reloadData()
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            return reqCell
        }
    }
    
    @objc func requestEvent() {
        
        guard let currentEvent = eventDict,
            let currentUser = userDict else {
                return
        }
        UploadEvent.shared.requestEvent(userRequest: currentUser, event: currentEvent) { (result) in
            
            switch result {
                
            case .success(let userData):
                
                print(userData)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    
}
