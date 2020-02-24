//
//  AchieveHeadTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class AchieveHeadTableViewCell: UITableViewCell {

    @IBOutlet weak var achieveIcon: UIImageView!
    
    @IBOutlet weak var achieveTitle: UILabel!
    
    @IBOutlet weak var achieveDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
