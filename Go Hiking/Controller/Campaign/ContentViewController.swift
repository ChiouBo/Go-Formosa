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
    
    var userDict: UserInfo?
    
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
        
        loadMemberUsers()
        
        loadUserInfo()
        
        setCustomBackground()
    }
    
    func titleImage() {
        
        guard let photo = eventDict?.image else { return }
        
        contentImage.loadImage(photo)
    }
    
    func loadReqUsers() {
        
        guard let eventData = eventDict else {
            
            return
        }
        
        UploadEvent.shared.loadRequestUserInfo(event: eventData) { (result) in
            
            switch result {
                
            case .success(let users):
                
                print(users)
                
                self.eventDict?.waitingListUser = users
                
                self.contentTableView.reloadData()
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    func loadMemberUsers() {
        
        guard let eventData = eventDict else {
            
            return
        }
        
        UploadEvent.shared.loadMemberUserInfo(event: eventData) { (result) in
            
            switch result {
                
            case .success(let users):
                
                print(users)
                
                self.eventDict?.memberListUser = users
                
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
        contentTableView.register(UINib(nibName: "MemberTableViewCell", bundle: nil), forCellReuseIdentifier: "Member")
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
        
        guard let requestCount = eventDict?.waitingListUser.count else { return 0 }
        
        guard let memberCount = eventDict?.memberListUser.count else { return 0 }
        
        if section == 0 {
            
            return 1
            
        } else if section == 1 {
            
            if memberCount != 0 {
                
                return memberCount
            } else {
                
                return 0
            }
            
        } else {
            
            if Auth.auth().currentUser?.uid == eventDict?.creater, requestCount != 0 {
                
                return requestCount
                
            } else {
                
                return 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        headerView.backgroundColor = UIColor.clear
        
        let titleLabel = UILabel(frame: CGRect(x: headerView.center.x, y: headerView.center.y, width: 140, height: 30))
        titleLabel.font = UIFont(name: "PingFangTC", size: 18)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        headerView.addSubview(titleLabel)
        
        if Auth.auth().currentUser?.uid == eventDict?.creater {
            
            if section == 1 {
                
                titleLabel.text = "目前成員 \(eventDict?.memberListUser.count ?? 0) 人"
            } else if section == 2 {
                
                titleLabel.text = "等候加入 \(eventDict?.waitingListUser.count ?? 0) 人"
            } else {
                return nil
            }
        } else {
            
            if section == 1 {
                
                titleLabel.text = "目前成員 \(eventDict?.memberListUser.count ?? 0) 人"
            }
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    // swiftlint:disable cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let event = eventDict else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as? ContentTableViewCell else {
                return UITableViewCell()
                
            }
            cell.selectionStyle = .none
            
            cell.contentTitle.text = eventDict?.title
            cell.contentLocation.text = ""
            cell.contentDate.text = "\(eventDict?.start ?? "") - \(eventDict?.end ?? "")"
            cell.contentDesc.text = eventDict?.desc
            cell.contentMember.text = "夥伴 \(eventDict?.member ?? "")"
            
            cell.contentJoin.addTarget(self, action: #selector(requestEvent), for: .touchUpInside)
            
            guard let user = Auth.auth().currentUser?.uid else {
                
                cell.contentJoin.isHidden = true
                
                return cell
            }
            
            if Auth.auth().currentUser?.uid != eventDict?.creater || Auth.auth().currentUser?.uid == nil {
                
                cell.contentJoin.isHidden = false
                
                guard let eventData = eventDict else { return UITableViewCell()}
                // swiftlint:disable control_statement
                if (eventData.requestList.contains(user)) {
                    
                    cell.contentJoin.backgroundColor = .gray
                    cell.contentJoin.setTitle("申請已送出", for: .normal)
                    cell.contentJoin.isEnabled = false
                }
                
            } else {
                cell.contentJoin.isHidden = true
            }
            
            return cell
            
        } else if indexPath.section == 1 {
            
            guard let memberCell = tableView.dequeueReusableCell(withIdentifier: "Member", for: indexPath) as? MemberTableViewCell else {
                return UITableViewCell()
                
            }
            
            guard let eventData = eventDict else {
                return UITableViewCell()
            }
            
            guard let memberList = eventDict?.memberListUser[indexPath.row] else {
                return UITableViewCell()
                
            }
            
            if Auth.auth().currentUser?.uid != eventDict?.creater {
                
                memberCell.deleteBtn.isHidden = true
            } else {
                
                memberCell.deleteBtn.isHidden = false
            }
            
            memberCell.selectionStyle = .none
            
            memberCell.memberName.text = memberList.name
            
            memberCell.memberImage.loadImage(memberList.picture)
            
            memberCell.memberHandler = {
                
                let memberUid = event.memberListUser[indexPath.row].id
                
                UploadEvent.shared.deleteMember(event: eventData, uid: memberUid) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        self.eventDict?.memberListUser.remove(at: indexPath.row)
                        
                        self.contentTableView.deleteRows(at: [indexPath], with: .right)
                        
                        self.contentTableView.reloadSections(IndexSet(1...2), with: .automatic)
                        
                        self.contentTableView.reloadData()
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
            return memberCell
            
        } else {
            
            guard let reqCell = tableView.dequeueReusableCell(withIdentifier: "Request", for: indexPath) as? RequestTableViewCell else {
                return UITableViewCell()
                
            }
            
            reqCell.selectionStyle = .none
            
            guard let eventData = eventDict else {
                
                return UITableViewCell()
            }
            
            if Auth.auth().currentUser?.uid == eventData.creater {
                
                reqCell.reqUserImage.loadImage(event.waitingListUser[indexPath.row].picture)
                
                reqCell.reqUserName.text = "\(event.waitingListUser[indexPath.row].name) 想要加入活動"
            }
            
            reqCell.requestHandler = {
                
                let reqUid = event.waitingListUser[indexPath.row].id
                
                UploadEvent.shared.acceptRequestUser(event: eventData, uid: reqUid) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        guard let object = self.eventDict?.waitingListUser.remove(at: indexPath.row) else { return }
                        
                        self.contentTableView.deleteRows(at: [indexPath], with: .right)
                        
                        self.eventDict?.memberListUser.append(object)
                        
                        self.contentTableView.reloadSections(IndexSet(1...2), with: .automatic)
                        
                        self.contentTableView.reloadData()
                        
                    case .failure(let error):
                        
                        print(error)
                    }
                }
            }
            
            reqCell.deleteHandler = {
                
                let reqUid = event.waitingListUser[indexPath.row].id
                
                UploadEvent.shared.deleteRequest(event: eventData, uid: reqUid) { (result) in
                    
                    switch result {
                        
                    case .success:
                        
                        self.eventDict?.waitingListUser.remove(at: indexPath.row)
                        
                        self.contentTableView.deleteRows(at: [indexPath], with: .right)
                        
                        //                        self.contentTableView.reloadSections(IndexSet(1...2), with: .automatic)
                        
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
