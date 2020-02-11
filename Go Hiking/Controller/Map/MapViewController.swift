//
//  MapViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/30.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        createGradientLayer()
        
        setbackground()
    }
    
    func createGradientLayer() {
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = background.bounds
        
        gradientLayer.colors = [UIColor.orange.cgColor, UIColor.blue.cgColor]
        
        view.layer.addSublayer(gradientLayer)
    }
    
    func setbackground() {
        
        let bgMap = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        let bgImage = UIImageView()
        
        bgImage.image = UIImage(named: "Map001")
        
        bgMap.addSubview(bgImage)
        
        view.addSubview(bgMap)
    }

}
