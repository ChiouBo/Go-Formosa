//
//  UIViewController+Extension.swift
//  Go Hiking
//
//  Created by Bo-Cheng Chiu on 2020/3/10.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setCustomBackground() {
        
        let bottomColor = UIColor(red: 9/255, green: 32/255, blue: 63/255, alpha: 1)
        let topColor = UIColor(red: 59/255, green: 85/255, blue: 105/255, alpha: 1)
        let gradientColors = [bottomColor.cgColor, topColor.cgColor]
        // swiftlint:disable colon
        let gradientLocations:[NSNumber] = [0.3, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //          gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        //          gradientLayer. endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
