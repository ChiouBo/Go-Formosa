//
//  TrailTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIView!
    
    @IBOutlet weak var trailImage: UIImageView!
    
    @IBOutlet weak var trailTitle: UILabel!
    
    @IBOutlet weak var trailPosition: UILabel!
    
    @IBOutlet weak var trailLevel: UILabel!
    
    @IBOutlet weak var trailLength: UILabel!
    
    @IBOutlet weak var trailStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCellType()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setCellType()
    }
    
    
    func setTrailType(content: String) {
        
        trailStatus.text = content
        trailStatus.layer.cornerRadius = 3
        trailStatus.layer.borderWidth = 1.5
        trailStatus.font = UIFont(name: "PingangTC", size: 16)
        trailStatus.layer.borderColor = UIColor.red.cgColor
        trailStatus.tintColor = .red
        trailStatus.textColor = .red
    }
    
    func setCellType() {
        
        cellImage.layer.cornerRadius = 5
        trailImage.clipsToBounds = true
        trailImage.layer.cornerRadius = 5
        trailImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
}
