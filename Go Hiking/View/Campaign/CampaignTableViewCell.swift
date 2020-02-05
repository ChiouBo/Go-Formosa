//
//  CampaignTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class CampaignTableViewCell: UITableViewCell {

    @IBOutlet weak var campaignTitle: UILabel!
    
    @IBOutlet weak var campaignLevel: UILabel!
    
    @IBOutlet weak var campaignImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
