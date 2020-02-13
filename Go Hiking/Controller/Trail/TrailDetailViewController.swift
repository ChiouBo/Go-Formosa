//
//  TrailDetailViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/5.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailDetailViewController: UIViewController {

    var trailDict: EventContent?
    
    lazy var trailImage: UIImageView = {
       let trailImage = UIImageView()
        trailImage.translatesAutoresizingMaskIntoConstraints = false
        trailImage.image = UIImage(named: "M001")
        trailImage.contentMode = .scaleAspectFill
        trailImage.clipsToBounds = true
        return trailImage
    }()
    
    lazy var TrailContentTableView: UITableView = {
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
        view.addSubview(TrailContentTableView)
        TrailContentTableView.addSubview(backtoList)
        
        trailImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        imageHeight = trailImage.heightAnchor.constraint(equalToConstant: 400)
        imageHeight?.isActive = true
        
        TrailContentTableView.contentInset = UIEdgeInsets(top: imageOriginHeight, left: 0, bottom: 0, right: 0)
        TrailContentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        TrailContentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        TrailContentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        TrailContentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        backtoList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backtoList.topAnchor.constraint(equalTo: view.topAnchor, constant: 33).isActive = true
        backtoList.widthAnchor.constraint(equalToConstant: 44).isActive = true
        backtoList.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupElement()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let originOffsetY = -imageOriginHeight
        let moveDistance = abs(scrollView.contentOffset.y - originOffsetY)
        
        if scrollView.contentOffset.y < originOffsetY {
            
            imageHeight?.constant = imageOriginHeight + moveDistance
            
            TrailContentTableView.backgroundColor = UIColor.clear
        } else {
            
            imageHeight?.constant = imageOriginHeight
            
            TrailContentTableView.backgroundColor = UIColor(white: 0, alpha: moveDistance / imageOriginHeight)
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
            TrailContentTableViewCell else { return UITableViewCell() }
            
            contentCell.trailTitle.text = trailDict?.title
            contentCell.trailLocation.text = trailDict?.location
            contentCell.trailDescription.text = trailDict?.desc
            
            return contentCell
            
        case 1:
            
            guard let createCell = tableView.dequeueReusableCell(withIdentifier: "TrailCreate", for: indexPath) as?
            TrailLocationTableViewCell else { return UITableViewCell() }
            
            createCell.createTrailEvent.addTarget(self, action: #selector(trailCreate), for: .touchUpInside)
            
            return createCell
            
        default:
            return UITableViewCell()
        }
    }
    
    @objc func trailCreate() {
        
        let createEvent = UIStoryboard(name: "Create", bundle: nil)
        guard let createVC = createEvent.instantiateViewController(withIdentifier: "CREATE") as? CreateViewController else { return }
        
        var currentImage: [UIImage] = []
        guard let image = trailImage.image else { return }
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
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let spring = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: CGVector(dx: 1.0, dy: 0.2))
        
        let animator = UIViewPropertyAnimator(duration: 1.0, timingParameters: spring)
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: 100 * 0.6)
        
        animator.addAnimations {
            
            cell.alpha = 1
            cell.transform = .identity
            self.TrailContentTableView.layoutIfNeeded()
        }
        animator.startAnimation(afterDelay: 0.3 * Double(indexPath.item))
    }
}
