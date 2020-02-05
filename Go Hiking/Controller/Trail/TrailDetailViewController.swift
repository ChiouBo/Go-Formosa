//
//  TrailDetailViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/5.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailDetailViewController: UIViewController {

    lazy var trailImage: UIImageView = {
       let trailImage = UIImageView()
        trailImage.translatesAutoresizingMaskIntoConstraints = false
        
//        trailImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: )
        trailImage.image = UIImage(named: "M001")
        trailImage.contentMode = .scaleAspectFill
        trailImage.clipsToBounds = true
        return trailImage
    }()
    
    lazy var TrailContentTableView: UITableView = {
        let tcTV = UITableView()
        let tCell = UINib(nibName: "TrailContentTableViewCell", bundle: nil)
        tcTV.translatesAutoresizingMaskIntoConstraints = false
        tcTV.delegate = self
        tcTV.dataSource = self
        tcTV.register(tCell, forCellReuseIdentifier: "TrailContent")
        tcTV.rowHeight = UITableView.automaticDimension
        return tcTV
    }()
    
    let imageOriginHeight: CGFloat = 400
    
    var imageHeight: NSLayoutConstraint?
    
    func setupElement() {
        
        
        view.addSubview(trailImage)
        view.addSubview(TrailContentTableView)
        
        trailImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        trailImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        trailImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
        imageHeight = trailImage.heightAnchor.constraint(equalToConstant: 400)
        imageHeight?.isActive = true
        TrailContentTableView.contentInset = UIEdgeInsets(top: imageOriginHeight, left: 0, bottom: 0, right: 0)
        TrailContentTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        TrailContentTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        TrailContentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        TrailContentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElement()
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrailContent", for: indexPath) as?
        TrailContentTableViewCell else { return UITableViewCell() }
        
        return cell
    }
}
