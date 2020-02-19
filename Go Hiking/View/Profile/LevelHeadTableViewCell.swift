//
//  LevelHeadTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class LevelHeadTableViewCell: UITableViewCell {

    @IBOutlet weak var currentLevelImage: UIImageView!
    
    @IBOutlet weak var nextLevelTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
