//
//  CreateCampaignViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/4.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class RecordCampaignViewController: UIViewController {
    
    private enum infoType: Int {
        
        case mainInfo = 0
        
        case otherInfo = 1
    }
    
    @IBOutlet weak var indicatorView: UIView!
    
    @IBOutlet weak var indicatorCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otherInfoContainerView: UIView!
    
    @IBOutlet weak var infoContainerView: UIView!
    
    @IBOutlet var contentBtns: [UIButton]!
    
    var containerViews: [UIView] {
        
        return [otherInfoContainerView, infoContainerView]
    }
    
    @IBAction func toChangeInfo(_ sender: UIButton) {
        
        for btn in contentBtns {
            
            btn.isSelected = false
        }
        
        sender.isSelected = true
        
        moveIndicatorView(reference: sender)
        
        guard let type = infoType(rawValue: sender.tag) else { return }
        
        updateContainer(type: type)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func moveIndicatorView(reference: UIView) {
        
        self.view.layoutIfNeeded()
        
        indicatorCenterXConstraint.isActive = false

        indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor)

        indicatorCenterXConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            
            self?.view.layoutIfNeeded()
        })
    }
    
    private func updateContainer(type: infoType) {
        
        containerViews.forEach({ $0.isHidden = true })
        
        switch type {
            
        case .mainInfo:
            infoContainerView.isHidden = false
            
        case .otherInfo:
            otherInfoContainerView.isHidden = false
        }
    }
}






