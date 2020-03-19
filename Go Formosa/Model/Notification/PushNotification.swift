//
//  PushNotification.swift
//  Go Formosa
//
//  Created by Bo-Cheng Chiu on 2020/3/18.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

import Foundation
import Firebase
import UserNotifications
import FirebaseMessaging

enum NotificationStatusType {
    
    case authorized
    
    case denied
    
    case notDetermined
}

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    func checkNotificationPermissionStatus() {
        
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                
                if settings.authorizationStatus == .authorized {
                    
                } else if settings.authorizationStatus == .denied {
                    
                    self.setupPushNotification()
                } else {
                    
                    self.setupPushNotification()
                }
            }
        }
    }
    
    func setupPushNotification() {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            
            Messaging.messaging().delegate = self
        } else {
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        
        uploadFCMToken()
    }
    
    func uploadFCMToken() {
        
        if let userFCM = Messaging.messaging().fcmToken {
            
            UserManager.share.uploadUserFCMToken(userFCM: userFCM) { (result) in
                
                switch result {
                    
                case .success(let token):
                    
                    print("get FCMToken\(token)")
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        uploadFCMToken()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        guard let userInfo = notification.request.content.userInfo as? [String: Any] else {
            return
            
        }
        
        print("willPresent userInfo: \(userInfo)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        guard let userInfo = response.notification.request.content.userInfo as? [String: Any] else {
            return
            
        }
        
        print("didPresent userInfo: \(userInfo)")
        
        print(response)
        
        completionHandler()
    }
    
}
