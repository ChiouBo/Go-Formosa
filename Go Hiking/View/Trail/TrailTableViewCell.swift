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

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
