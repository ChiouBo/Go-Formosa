//
//  AchieveCollectionViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class AchieveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var achieveImage: UIImageView!
    
    @IBOutlet weak var achieveTitle: UILabel!
    
    @IBOutlet weak var achieveDesc: UILabel!
    
    func layoutCell(image: UIImage?, title: String, desc: String) {
        
        achieveImage.image = image
        
        achieveTitle.text = title
        
        achieveDesc.text = desc
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
