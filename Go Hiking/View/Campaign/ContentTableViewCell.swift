//
//  ContentTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/24.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var contentTitle: UILabel!
    
    @IBOutlet weak var contentDate: UILabel!
    
    @IBOutlet weak var contentLocation: UILabel!
    
    @IBOutlet weak var contentMember: UILabel!
    
    @IBOutlet weak var contentDesc: UILabel!
    
    @IBOutlet weak var contentJoin: UIButton!
    
    @IBAction func joinEvent(_ sender: UIButton) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setButton()
    }

    func setButton() {
        
        contentJoin.layer.cornerRadius = 25
        contentJoin.layer.shadowOffset = CGSize(width: 0, height: 3)
        contentJoin.layer.shadowOpacity = 0.7
        contentJoin.layer.shadowRadius = 5
        contentJoin.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    
}
