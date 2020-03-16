//
//  TrailLocationTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/5.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var createTrailEvent: UIButton!
    
    @IBOutlet weak var otherTrailEvent: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setButton()
    }
    
    func setButton() {
        
        createTrailEvent.layer.cornerRadius = 25
        createTrailEvent.layer.shadowOffset = CGSize(width: 0, height: 3)
        createTrailEvent.layer.shadowOpacity = 0.7
        createTrailEvent.layer.shadowRadius = 5
        createTrailEvent.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
}
