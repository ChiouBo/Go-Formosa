//
//  TrailContentTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/5.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class TrailContentTableViewCell: UITableViewCell {

    @IBOutlet weak var trailTitle: UILabel!
    
    @IBOutlet weak var trailLocation: UILabel!
    
    @IBOutlet weak var trailFavorite: UIButton!
    
    @IBOutlet weak var trailDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
