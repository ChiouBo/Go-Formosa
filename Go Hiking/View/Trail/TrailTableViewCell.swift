//
//  TrailTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/3.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailTableViewCell: UITableViewCell {

    @IBOutlet weak var trailImage: UIImageView!
    
    @IBOutlet weak var trailTitle: UILabel!
    
    @IBOutlet weak var trailPosition: UILabel!
    
    @IBOutlet weak var trailLevel: UILabel!
    
    @IBOutlet weak var trailLength: UILabel!
    
    @IBOutlet weak var trailStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setTrailType()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setTrailType()
    }
    
    
    func setTrailType() {
        
        trailStatus.layer.cornerRadius = 5
        trailStatus.layer.borderWidth = 1
        trailStatus.font = UIFont(name: "PingangTC", size: 16)
        trailStatus.layer.borderColor = UIColor.red.cgColor
        trailStatus.tintColor = .red
        trailStatus.textColor = .red
    }
}
