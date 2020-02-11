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
        setView()
        setLabel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setView()
        setLabel()
    }
    
    func setLabel() {
        
        campaignTitle.textColor = .white
        campaignLevel.textColor = .white
    }
    
    
    func setView() {
        
        campaignImage.layer.cornerRadius = 10
        campaignImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        campaignImage.layer.shadowOpacity = 0.7
        campaignImage.layer.shadowRadius = 5
        campaignImage.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
