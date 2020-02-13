//
//  GradientColor+Extension.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit

struct Style {
    
    private init() { }
    
    static let gradient = Gradient()
}

struct Gradient {
    
    let gradientLayer = [UIColor.red.cgColor, UIColor.yellow.cgColor]
    
}
//
//func customizebackgroundView() {
//      //定義漸層的顏色（yellow to green）
//      let topColor = UIColor(red: 0xf9/255, green: 0xf5/255, blue: 0x86/255, alpha: 1)
//      let buttomColor = UIColor(red: 0x89/255, green: 0xfb/255, blue: 0xde/255, alpha: 1)
//      let gradientColors = [topColor.cgColor, buttomColor.cgColor]
//      //定義每種顏色的位置
//      let gradientLocations:[NSNumber] = [0.4, 1.0]
//      //創建CAGradientLayer對象並設置參數
//      let gradientLayer = CAGradientLayer()
//      gradientLayer.colors = gradientColors
//      gradientLayer.locations = gradientLocations
//      //設置其CAGradientLayer對象的frame，And 加入view的layer
//      gradientLayer.frame = self.view.frame
//      self.view.layer.insertSublayer(gradientLayer, at: 0)
//  }

//func createGradientLayer() {
//    
//    let background = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//    
//    let gradientLayer = CAGradientLayer()
//    
//    gradientLayer.frame = background.bounds
//    
//    gradientLayer.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor]
//    
//    view.layer.addSublayer(gradientLayer)
//}
