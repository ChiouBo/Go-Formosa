//
//  TrailDetailViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/5.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Firebase

class TrailDetailViewController: UIViewController {
    
    var trailDict: EventContent?
    
    var trailPhoto: String?
    
    lazy var trailImage: UIImageView = {
        let trailImage = UIImageView()
        trailImage.translatesAutoresizingMaskIntoConstraints = false
        trailImage.contentMode = .scaleAspectFill
        trailImage.clipsToBounds = true
        return trailImage
    }()
    
    lazy var trailContentTableView: UITableView = {
        let tcTV = UITableView()
        let tCell = UINib(nibName: "TrailContentTableViewCell", bundle: nil)
        let cCell = UINib(nibName: "TrailLocationTableViewCell", bundle: nil)
        tcTV.translatesAutoresizingMaskIntoConstraints = false
        tcTV.delegate = self
        tcTV.dataSource = self
        tcTV.register(tCell, forCellReuseIdentifier: "TrailContent")
        tcTV.register(cCell, forCellReuseIdentifier: "TrailCreate")
        tcTV.rowHeight = UITableView.automaticDimension
        tcTV.separatorStyle = .none
        return tcTV
    }()
    
    lazy var backtoList: UIButton = {
        let back = UIButton()
        let backImage = UIImage(named: "Icons_44px_Back01")
        back.setImage(backImage, for: .normal)
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action: #selector(backtoTList), for: .touchUpInside)
        return back
    }()
    
    @objc func backtoTList() {
        navigationController!.popViewController(animated: true)
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    let imageOriginHeight: CGFloat = 400
    
    var imageHeight: NSLayoutConstraint?
    
    func setupElement() {
        
        view.addSubview(trailImage)
        view.addSubview(trailContentTableView)
        trailContentTableView.addSubview(backtoList)
        
        trailImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageHeight = trailImage.heightAnchor.constraint(equalToConstant: 400)
        imageHeight?.isActive = true
        
        trailContentTableView.backgroundColor = .clear
        trailContentTableView.contentInset = UIEdgeInsets(top: imageOriginHeight, left: 0, bottom: 0, right: 0)
        trailContentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailContentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trailContentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailContentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        backtoList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backtoList.topAnchor.constraint(equalTo: view.topAnchor, constant: 33).isActive = true
        backtoList.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backtoList.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleImage()
        
        setupElement()
        
        setCustomBackground()
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func titleImage() {
        
        guard let photo = trailPhoto else { return }
        
        trailImage.loadImage(photo)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let originOffsetY = -imageOriginHeight
        
        let moveDistance = abs(scrollView.contentOffset.y - originOffsetY)
        
        if scrollView.contentOffset.y < originOffsetY {
            
            imageHeight?.constant = imageOriginHeight + moveDistance
            
            trailContentTableView.backgroundColor = UIColor.clear
        } else {
            
            imageHeight?.constant = imageOriginHeight
            
            trailContentTableView.backgroundColor = UIColor(white: 0, alpha: moveDistance / imageOriginHeight)
        }
    }
}

extension TrailDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            
        case 0:
            
            guard let contentCell = tableView.dequeueReusableCell(withIdentifier: "TrailContent", for: indexPath) as?
                TrailContentTableViewCell else {
                    return UITableViewCell()
                    
            }
            
            contentCell.backgroundColor = .clear
            contentCell.selectionStyle = .none
            
            contentCell.trailTitle.text = trailDict?.title
            contentCell.trailLocation.text = trailDict?.location
            contentCell.trailDescription.text = trailDict?.desc
            
            return contentCell
            
        case 1:
            
            guard let createCell = tableView.dequeueReusableCell(withIdentifier: "TrailCreate", for: indexPath) as?
                TrailLocationTableViewCell else {
                    return UITableViewCell()
                    
            }
            
            createCell.backgroundColor = .clear
            createCell.selectionStyle = .none
            
            createCell.createTrailEvent.addTarget(self, action: #selector(trailCreate), for: .touchUpInside)
            createCell.otherTrailEvent.addTarget(self, action: #selector(sameEvent), for: .touchUpInside)
            return createCell
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func trailCreate() {
        
        if Auth.auth().currentUser != nil {
            
            let createEvent = UIStoryboard(name: "Create", bundle: nil)
            
            guard let createVC = createEvent.instantiateViewController(withIdentifier: "CREATE") as? CreateViewController else {
                return
                
            }
            
            var currentImage: [UIImage] = []
            
            guard let image = trailImage.image else {
                return
                
            }
            
            currentImage.append(image)
            
            let trailInfo = EventContent(image: currentImage,
                                         title: trailDict?.title ?? "",
                                         desc: trailDict?.desc ?? "",
                                         start: "",
                                         end: "",
                                         amount: "",
                                         location: trailDict?.location ?? "")
            
            createVC.data = trailInfo
            
            createVC.loadViewIfNeeded()
            
            createVC.imageArray.append(trailImage.image!)
            
            createVC.modalPresentationStyle = .custom
            
            present(createVC, animated: true, completion: nil)
            
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
    
    @objc func sameEvent() {
        // swiftlint:disable force_cast
        ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! GHTabBarViewController).selectedIndex = 2
        // swiftlint:enable force_cast
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        cell.backgroundColor = .clear
        
        animator.addAnimations {
            
            cell.alpha = 1
            
            cell.transform = .identity
            
            self.trailContentTableView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.3 * Double(indexPath.item))
    }
}
