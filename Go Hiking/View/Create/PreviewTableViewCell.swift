//
//  PreviewTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
//
//protocol InputCheckDelegate: AnyObject {
//
//    func inputEmpty(_ tableViewCell: PreviewTableViewCell, notice: String )
//}

class PreviewTableViewCell: UITableViewCell {

//    weak var delegate: InputCheckDelegate?
    
    @IBOutlet weak var attentionLabel: UILabel!
    
    @IBOutlet weak var previewBtn: UIButton!
    
 
//    func setupNoticeLabel(notice: String) {
//
//
//    }
    
    
    
    
    
    
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
