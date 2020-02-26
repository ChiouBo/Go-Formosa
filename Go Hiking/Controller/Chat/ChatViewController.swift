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
        
        let topColor = UIColor(red: 10/255, green: 80/255, blue: 80/255, alpha: 1)
        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        
        let gradientLocations:[NSNumber] = [0.4, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func customizebackground() {
        
        let topColor = UIColor(red: 51/255, green: 8/255, blue: 103/255, alpha: 1)
        let buttomColor = UIColor(red: 48/255, green: 207/255, blue: 208/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        
        let gradientLocations:[NSNumber] = [0.3, 1.0]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
 
}
