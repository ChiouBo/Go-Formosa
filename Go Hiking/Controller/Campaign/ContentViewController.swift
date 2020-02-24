//
//  ContentViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/24.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var contentImage: UIImageView!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    let imageOriginHeight: CGFloat = 300
    
    var eventDict: EventCurrent?
    
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

        titleImage()
        
        setElement()
        
        customizebackgroundView()
    }
    
    func titleImage() {
        
        guard let photo = eventDict?.image else { return }
        
        contentImage.loadImage(photo)
    }
    
    func setElement() {
        
        view.addSubview(contentImage)
        view.addSubview(contentTableView)
        
        contentTableView.backgroundColor = .clear
        contentTableView.delegate = self
        contentTableView.dataSource = self
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Content", for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        cell.contentTitle.text = eventDict?.title
        cell.contentLocation.text = ""
        cell.contentDate.text = "\(eventDict?.start ?? "") - \(eventDict?.end ?? "")"
        cell.contentDesc.text = eventDict?.desc
        cell.contentMember.text = eventDict?.member
        
        
        return cell
    }
    

    
}
