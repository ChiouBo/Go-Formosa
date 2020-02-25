//
//  RequestTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/25.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var reqUserImage: UIImageView!
    
    @IBOutlet weak var reqUserName: UILabel!
    
    @IBOutlet weak var reqRejectBtn: UIButton!
    
    @IBOutlet weak var reqAcceptBtn: UIButton!
    
    @IBAction func rejectBtn(_ sender: UIButton) {
    }
    
    @IBAction func acceptBtn(_ sender: UIButton) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setElement()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setElement()
    }
    
    func setElement() {
        
        reqUserImage.layer.cornerRadius = 25
        reqUserImage.layer.borderWidth = 1.5
        reqUserImage.layer.borderColor = UIColor.white.cgColor
        
    }
}
