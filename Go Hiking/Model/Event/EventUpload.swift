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
            
            "title": evenContent.title,
            "desc": evenContent.desc,
            "start": evenContent.start,
            "end": evenContent.end,
            "member": evenContent.amount,
            "image": image,
            "creater": uid,
            "eventID": eventDB.collection("Event").document().documentID
            
        ]) { (error) in
            
            if let error = error {
                
                print(error)
            }
        }
    }
    
    func storage(uniqueString: String, data: Data, completion: @escaping (Result<URL>) -> Void ) {
        
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
                
                completion(.success(downloadURL))
                
                print(downloadURL)
            }
        })
    }
    
    func download(completion: @escaping (Result<EventCurrent>) -> Void) {
        
        eventDB.collection("Event").getDocuments { (snapshot, error) in
            
            if error == nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    
                    do {
                        guard let data = try document.data(as: EventCurrent.self, decoder: Firestore.Decoder()) else { return }
                        
                        completion(.success(data))
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    func deleteEvent() {
        
        
    }
    
    
}

