//
//  KingFisherWrapper.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/29.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        
        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)
        
        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
