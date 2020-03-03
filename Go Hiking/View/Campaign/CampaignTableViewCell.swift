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
    
    @IBOutlet weak var campaignMember: UILabel!
    
    @IBOutlet weak var campaignImage: UIImageView!
    
    @IBOutlet weak var readyRequest: UIButton!
    
    @IBAction func requestCancel(_ sender: UIButton) {
    }
    
    @IBOutlet weak var campaignDelete: UIButton!
    
    @IBAction func campaignDelete(_ sender: UIButton) {
        
        deleteEventHandler?()
    }
    
    var deleteEventHandler: (() -> Void)?
    
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
        campaignMember.textColor = .white
        campaignTitle.shadowOffset = CGSize(width: 2, height: 2)
        campaignTitle.shadowColor = .gray
        campaignLevel.shadowOffset = CGSize(width: 1, height: 1)
        campaignLevel.shadowColor = .gray
        campaignMember.shadowOffset = CGSize(width: 1, height: 1)
        campaignMember.shadowColor = .gray
    }
    
    
    func setView() {
        
        campaignImage.layer.cornerRadius = 10
        campaignImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        campaignImage.layer.shadowOpacity = 0.7
        campaignImage.layer.shadowRadius = 5
        campaignImage.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
