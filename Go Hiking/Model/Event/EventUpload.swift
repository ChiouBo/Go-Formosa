//
//  EventUpload.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/2/9.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreSwift

class UploadEvent {
    
    private init() {}
    
    static let shared = UploadEvent()
    
    let storageReference = Storage.storage().reference()
    
    let eventDB = Firestore.firestore()
    
    func uploadEventData(evenContent: EventContent, image: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        eventDB.collection("Event").document().setData([
            
            "Title": evenContent.title,
            "Desc": evenContent.desc,
            "Start": evenContent.start,
            "End": evenContent.end,
            "Member": evenContent.amount,
            "Image": image,
            "Creater": uid,
            "EventID": eventDB.collection("Event").document().documentID
            
        ]) { (error) in
            
            if let error = error {
                
                print(error)
            }
        }
    }
    
    func storage(uniqueString: String, data: Data, complation: @escaping (Result<URL>) -> Void ) {
        
        let uploadData = data
        
        let storageRef = Storage.storage().reference().child("GHEventPhotoUpload").child("\(uniqueString).png")
        
        storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
            
            if error != nil {
                
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { (url, error) in
                
                guard let downloadURL = url else {
                    return
                }
                
                complation(.success(downloadURL))
                
                print(downloadURL)
            }
        })
    }
    
    
    
}

