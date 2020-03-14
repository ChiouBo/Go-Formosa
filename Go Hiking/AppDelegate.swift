//
//  AppDelegate.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/1/24.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import Firebase
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import GoogleSignIn
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
//    let center = UNUserNotificationCenter.current()
    
    static let shared = UIApplication.shared.delegate as? AppDelegate
    
    let locationManager = CLLocationManager()
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        if url.scheme! == "fb554466721947676" {
            
            ApplicationDelegate.shared.application(app, open: url, options: options)
            
            return true
        } else {
            
            return GIDSignIn.sharedInstance().handle(url)
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            // swiftlint:disable unused_closure_parameter
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { (state, error) in
                
            }
        } else {
            
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        locationManager.requestWhenInUseAuthorization()
        
        GMSServices.provideAPIKey("AIzaSyD9Sjc_momutj99pkja3PfeVAJbrqbuKAw")
        GMSPlacesClient.provideAPIKey("AIzaSyD9Sjc_momutj99pkja3PfeVAJbrqbuKAw")
        
        IQKeyboardManager.shared.enable = true
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Go_Hiking")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
// swiftlint:disable comma
@available(iOS 10,*)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("willPresent userInfo: \(userInfo)")
    }
                         
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("didPresent userInfo: \(userInfo)")
        
        completionHandler()
    }
                                
}

extension AppDelegate: MessagingDelegate {
    
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    
    print("Firebase registration token: \(fcmToken)")
        
    let dataDict:[String: String] = ["token": fcmToken]
    
    NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
  }
    
  func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    
    print("Received data message: \(remoteMessage.appData)")
  }
}
