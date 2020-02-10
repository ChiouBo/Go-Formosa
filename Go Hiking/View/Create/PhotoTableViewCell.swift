//
//  PhotoTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/8.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

protocol PressToUploadPhoto: AnyObject {
    
    func presstoUploadPhoto(_ tableViewCell: PhotoTableViewCell)
}


class PhotoTableViewCell: UITableViewCell {

    weak var delegate: PressToUploadPhoto?
    
    var photoArray: [UIImage] = [] {
        
        didSet {
            
            photoCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }

}

extension PhotoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photos", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.delegate = self
        
        if indexPath.row == photoArray.count {
           
            cell.contentView.backgroundColor = .lightGray
            
            cell.uploadBtn.isHidden = false
            
            cell.photoImage.isHidden = true
            
        } else {
            
            cell.photoImage.isHidden = false
            
            cell.photoImage.image = photoArray[indexPath.row]
            
            cell.uploadBtn.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 120, height: 120)
    }
    
    func collectionView(
        _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int ) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0, right: 20.0)
    }

    
}

extension PhotoTableViewCell: UploadPhotoDelegate {
    
    func uploadPhoto(_ collectionViewCell: PhotoCollectionViewCell) {
        
        self.delegate?.presstoUploadPhoto(self)
    }
    
}
