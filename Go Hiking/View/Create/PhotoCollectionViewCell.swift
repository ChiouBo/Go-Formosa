//
//  PhotoCollectionViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol UploadPhotoDelegate: AnyObject {
    
    func uploadPhoto(_ collectionViewCell: PhotoCollectionViewCell)
}

class PhotoCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: UploadPhotoDelegate?
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBAction func uploadBtn(_ sender: UIButton) {
        
        self.delegate?.uploadPhoto(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
