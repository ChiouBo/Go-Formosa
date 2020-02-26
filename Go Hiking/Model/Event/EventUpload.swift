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
    
    // MARK: - Upload Event Data
    func uploadEventData(evenContent: EventContent, image: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentID = eventDB.collection("Event").document().documentID
        
        eventDB.collection("Event").document(documentID).setData([
            
            "title": evenContent.title,
            "desc": evenContent.desc,
            "location": evenContent.location,
            "start": evenContent.start,
            "end": evenContent.end,
            "member": evenContent.amount,
            "image": image,
            "creater": uid,
            "eventID": documentID,
            "waitingList": [],
            "memberList": [],
            "requestList": []
            
        ]) { (error) in
            
            if let error = error {
                
                print(error)
            }
        }
    }
    
    // MARK: - Download Photo URL
    func storage(uniqueString: String, data: Data, completion: @escaping (Result<URL>) -> Void ) {
        
        let uploadData = data
        
        let storageRef = Storage.storage().reference().child("GHEventPhotoUpload").child("\(uniqueString).jpg")
        
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
    
    // MARK: - Download Event Data
    func download(completion: @escaping (Result<EventCurrent>) -> Void) {
        
        eventDB.collection("Event").order(by: "start", descending: true).getDocuments { (snapshot, error) in
            
            if error == nil && snapshot?.documents.count != 0 {
                
                for document in snapshot!.documents {
                    
                    do {
                        
                        guard let data = try document.data(as: EventCurrent.self) else { return }
                        
                        completion(.success(data))
                        
                    } catch {
                        
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Remove Event Data
    func removePost() {
        
        
    }
    
    // MARK: - Request Event
    func requestEvent(userRequest: User, event: EventCurrent, completion: @escaping (Result<String>) -> Void ) {

        guard let userUid = Auth.auth().currentUser?.uid else { return }
        
        let ref: DocumentReference = eventDB.collection("Event").document(userUid)
        
        do{
            try eventDB.collection("Event").document(event.eventID).collection("Request").document(userUid).setData(from: userRequest)

            eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayUnion([ref])])
            
            eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayUnion([userUid])])
        } catch {
            
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Upload Request to Event
    func loadRequestUserInfo(event: EventCurrent, completion: @escaping (Swift.Result<User, Error>) -> Void) {

        eventDB.collection("Event").document(event.eventID).collection("Request").getDocuments { (snapshots, error) in
            
            guard let snapShots = snapshots else { return }
            
            for req in snapShots.documents {
                
                do {
                    guard let users = try req.data(as: User.self, decoder: Firestore.Decoder()) else { return }
  
                    completion(.success(users))
                    
                } catch {
                    
                    print(error)
                    
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    // MARK: - Bring User to Event Mamber
    func acceptRequestUser(event: EventCurrent, uid: String, completion: @escaping (Result<Void>) -> Void ) {
        
        let ref = eventDB.collection("Event").document(uid)
        
        do {
            try
            eventDB.collection("Event").document(event.eventID).updateData(["waitingList": FieldValue.arrayRemove([ref])])
            
            eventDB.collection("Event").document(event.eventID).updateData(["requestList": FieldValue.arrayRemove([ref])])
            
            eventDB.collection("Event").document(event.eventID).updateData(["memberList": FieldValue.arrayUnion([ref])])
            
            eventDB.collection("Event").document(event.eventID).collection("Request").document(uid).delete()
            
            completion(.success(()))
        } catch {
            
            print(error)
            
            completion(.failure(error))
        }
    }
}

