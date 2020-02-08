//
//  PreviewTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class PreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var attentionLabel: UILabel!
    
    @IBOutlet weak var previewBtn: UIButton!
    
    @IBAction func previewBtn(_ sender: UIButton) {
        
        
    }
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setButton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setButton() {
        
        previewBtn.layer.cornerRadius = 25
        previewBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
        previewBtn.layer.shadowOpacity = 0.7
        previewBtn.layer.shadowRadius = 5
        previewBtn.layer.shadowColor = UIColor.lightGray.cgColor
    }
}
