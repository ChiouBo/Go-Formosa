//
//  JGProgressHUDWrapper.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/29.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import JGProgressHUD

enum HUDType {
    
    case success(String)
    
    case waitinglist(String)
}

class LKProgressHUD {
    
    static let shared = LKProgressHUD()
    
    private init() { }
    
    let hud = JGProgressHUD(style: .dark)
    
    var view: UIView {
        
        return (AppDelegate.shared?.window?.rootViewController!.view)!
    }
    
    static func show(type: HUDType) {
        
        switch type {
            
        case .success(let text):
            
            showSuccess(text: text)
            
        case .waitinglist(let text):
            
            showWaitingList(text: text)
        }
    }
    
    static func showSuccess(text: String = "Success") {
        
        if Thread.isMainThread {
            
            DispatchQueue.main.async {
                showSuccess(text: text)
            }
            
            return
        }
        
        shared.hud.textLabel.text = text
        
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        shared.hud.show(in: shared.view)
        
        shared.hud.dismiss(afterDelay: 1)
    }
    
    static func showWaitingList(text: String = "Waiting List") {
        
        if Thread.isMainThread {
            
            DispatchQueue.main.async {
                showWaitingList(text: text)
            }
            
            return
        }
        
        shared.hud.textLabel.text = text
        
        shared.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        
        shared.hud.show(in: shared.view)
        
        shared.hud.dismiss(afterDelay: 1)
    }
    
    static func show() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                show()
            }

            return
        }

        shared.hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()

        shared.hud.textLabel.text = "Loading"

        shared.hud.show(in: shared.view)
    }

    static func dismiss() {

        if !Thread.isMainThread {

            DispatchQueue.main.async {
                dismiss()
            }

            return
        }

        shared.hud.dismiss()
    }
}
