//
//  FilterCollectionViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var filterBtnItem: UIButton!
    
    func layoutCell(title: String) {
        
        filterBtnItem.setTitle(title, for: .normal)
        filterBtnItem.layer.cornerRadius = 5
        filterBtnItem.layer.borderWidth = 1
        filterBtnItem.layer.borderColor = UIColor.T1?.cgColor
        filterBtnItem.tintColor = UIColor.T1
        filterBtnItem.backgroundColor = UIColor.T4
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

}
