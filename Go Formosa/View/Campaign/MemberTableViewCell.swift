//
//  MemberTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/29.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class MemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    
    @IBOutlet weak var memberName: UILabel!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        
        memberHandler?()
    }
    
    var memberHandler: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setElement()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        setElement()
    }
    
    func setElement() {
        
        memberImage.layer.cornerRadius = 25
        memberImage.layer.borderWidth = 1.5
        memberImage.layer.borderColor = UIColor.white.cgColor
    }
    
}
