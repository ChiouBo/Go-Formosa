//
//  MessageViewController.swift
//  Go Hiking
//
//  Created by 邱博晟 on 2020/3/1.
//  Copyright © 2020 Chioubo. All rights reserved.
//

import UIKit
import Photos
import Firebase
import MessageKit
import InputBarAccessoryView
import FirebaseFirestore
import UserNotifications

class MessageViewController: MessagesViewController {
    
    var userInfo: EventCurrent?
    
    let chatDB = Firestore.firestore()
    
    var memberFCM: [String] = []
    
    var userPhoto = ""
    
    var otherUserPhoto: String = ""
    
    var user: UserInfo?
    
    let uid = Auth.auth().currentUser?.uid
    
    private let dbChat = Firestore.firestore()
    
    private var reference: CollectionReference?
    
    private let storage = Storage.storage().reference()
    
    private var messages: [Message] = []
    
    private var messageListener: ListenerRegistration?
    
    deinit {
        messageListener?.remove()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChatUI()
        
        setListener()
        
        setMessage()
        
        setUser()
        
        getMemberFCmToken()
        
        messageInputBar.leftStackView.alignment = .center
        
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
    
    }
     // swiftlint:disable unused_closure_parameter
    func getMemberFCmToken() {
        
        guard let member = userInfo,
              let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let uidRef = chatDB.collection("Users").document(currentUid)
        
        for ref in member.memberList where ref != uidRef {
            
            ref.getDocument { (snapshot, error) in
                
                guard let snapShot = snapshot else { return }
                
                guard let fcmToken = snapShot.data()?["userFCM"] as? String else { return }
                
                self.memberFCM.append(fcmToken)
            }
        }
    }
    
    func addLongPressGesture() {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
       
        longPress.minimumPressDuration = 1.5
    }
    
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == UIGestureRecognizer.State.began {
        
            print("Long Press")
        }
    }
    
    func setUser() {
        
        guard let name = Auth.auth().currentUser?.displayName else { return }
        AppSettings.displayName = name
    }
    
    func setListener() {
        
        guard let charRoomID = userInfo?.chatroomID else { return }
        
        reference = dbChat.collection(["Chatroom", charRoomID, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
            
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                
                return
            }
            snapshot.documentChanges.forEach { change in
                
                self.handleDocumentChange(change)
            }
        }
    }
    
    func setMessage() {
        
        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.sendButton.addTarget(self, action: #selector(tapSend), for: .touchUpInside)
    }
    
    private func save(_ message: Message) {
        
        reference?.addDocument(data: message.representation) { error in
        
            if let error = error {
            
                print("Error sending message: \(error.localizedDescription)")
                
                return
            }
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            
            DispatchQueue.main.async {
            
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }
        switch change.type {
            
        case .added:
            
            insertNewMessage(message)
        default:
            
            break
        }
    }
    
    func setChatUI() {
        
        messagesCollectionView.backgroundColor = UIColor.MapSea
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.toolbar.tintColor = .white
    }
    
}

// MARK: - MessagesDisplayDelegate
extension MessageViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return isFromCurrentSender(message: message) ? .darkGray : .black
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .pointedEdge)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .white
    }
    
}

// MARK: - MessagesLayoutDelegate

extension MessageViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
}

// MARK: - MessagesDataSource

extension MessageViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        
        return Sender(id: uid ?? "", displayName: AppSettings.displayName)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: message.sender.displayName,
                                  attributes: [.font: UIFont.systemFont(ofSize: 12),
                                               .foregroundColor: UIColor.white
            ]
        )
    }
    
    func cellTopLabelAttributedText(for message: MessageType,
                                    at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        return NSAttributedString(
            string: name,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
            ]
        )
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        guard let currentUser = self.user,
            let message = message as? Message else {
                return
                
        }
        
        if message.sender.senderId == currentUser.id {
            
            avatarView.loadImage(currentUser.picture)
        } else {
            
            avatarView.loadImage(message.photo)
        }
    }
    
}

// MARK: - MessageInputBarDelegate

extension MessageViewController: InputBarAccessoryViewDelegate {
    
    @objc func tapSend() {
        guard let text = messageInputBar.inputTextView.text,
            let user = Auth.auth().currentUser else { return }
        if let photo = Auth.auth().currentUser?.photoURL {
            userPhoto = "\(photo)"
        } else {
            userPhoto = ""
        }
        
        let message = Message(user: user, content: text, photo: userPhoto)
        save(message)
        messageInputBar.inputTextView.resignFirstResponder()
        self.view.endEditing(true)
        messageInputBar.inputTextView.text = ""
        
        guard let chatroom = userInfo else { return }
        
        for members in memberFCM {
            
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: members, title: chatroom.title, body: message.content)
        }
        
    }

}
