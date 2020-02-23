//
//  ChatViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
//        customizebackground()
        customizebackgroundView()
    }
    
    func setNavBar() {
        navigationController?.navigationBar.barStyle = .black
        let navBarNude = UIImage()
        navigationController?.navigationBar.setBackgroundImage(navBarNude, for: .default)
        self.navigationController?.navigationBar.shadowImage = navBarNude
    }
    
    func customizebackgroundView() {
        //定義漸層的顏色（yellow to green）
        let topColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        //定義每種顏色的位置
        let gradientLocations:[NSNumber] = [0.4, 1.0]
        //創建CAGradientLayer對象並設置參數
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //設置其CAGradientLayer對象的frame，And 加入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func customizebackground() {
        //定義漸層的顏色（yellow to green）
        let topColor = UIColor(red: 51/255, green: 8/255, blue: 103/255, alpha: 1)
        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        //定義每種顏色的位置
        let gradientLocations:[NSNumber] = [0.3, 1.0]
        //創建CAGradientLayer對象並設置參數
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        //設置其CAGradientLayer對象的frame，And 加入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
 
}
