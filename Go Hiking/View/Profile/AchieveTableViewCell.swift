//
//  AchieveTableViewCell.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class AchieveTableViewCell: UITableViewCell {

    @IBOutlet weak var achieveFlagCollectionView: UICollectionView! {
        
        didSet {
            
            achieveFlagCollectionView.delegate = self
            
            achieveFlagCollectionView.dataSource = self
        }
    }
    
    let manager = ProfileManager()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }

    func setCollectionView() {
        
        achieveFlagCollectionView.register(UINib(nibName: "AchieveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ACHIEVEMENT")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

extension AchieveTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return manager.profileGroup.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return manager.profileGroup[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
        guard let achieveCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ACHIEVEMENT", for: indexPath) as? AchieveCollectionViewCell else { return UICollectionViewCell() }
        
        let item = manager.profileGroup[indexPath.section].items[indexPath.row]
        
        achieveCell.layoutCell(image: item.image, title: item.title, desc: item.desc)
        
        
        
        return achieveCell
    }

}

extension AchieveTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            return CGSize(width: UIScreen.main.bounds.width / 3.0, height: 150.0)
            
        } else if indexPath.section == 1 {
            
            return CGSize(width: UIScreen.main.bounds.width / 3.0, height: 150.0)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 150.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10.0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 20.0)
    }
}
