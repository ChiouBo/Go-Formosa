//
//  NotificationManager.swift
//  Go Formosa
//
//  Created by Bo-Cheng Chiu on 2020/3/19.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit

class PushNotificationSender {
    
    func sendPushNotification(to token: String, title: String, body: String) {
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.setValue("key=AAAAS7pTw_g:APA91bHxS7M0ewr_Pzy49HP1fzQ7w3c6JP9VsNv2Npfl93lApvpEEQ55JQ_VwiroSFGFiGPewRQjQWA878uFaT3gpFwD9QQ6g32euFWgWaKeSeNG52iIQhHrCjQ_MI3TTi4Deq7pU0yK",
                         forHTTPHeaderField: "Authorization")
        
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            
            do {
                if let jsonData = data {
                    
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
