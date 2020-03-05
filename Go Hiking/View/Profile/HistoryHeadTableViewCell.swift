//
//  HistoryHeadTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import EFCountingLabel

class HistoryHeadTableViewCell: UITableViewCell {

    @IBOutlet weak var exploreTimes: UILabel!
    
    @IBOutlet weak var exploreKM: UILabel!
    
    @IBOutlet weak var exploreHR: UILabel!
    
    @IBOutlet weak var timesLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var timesEF: EFCountingLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
