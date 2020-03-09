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
    var userPhoto = ""
    var otherUserPhoto: String = ""
    var user: UserInfo?
    //Notification
    let app = UIApplication.shared.delegate as! AppDelegate
    var center: UNUserNotificationCenter?
    //Notification
    let snoozeAction = UNNotificationAction(identifier: "SnoozeAction", title: "Snooze", options: [.authenticationRequired])
    let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
    
    let uid = Auth.auth().currentUser?.uid
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    
    private var messages: [Message] = []
    private var messageListener: ListenerRegistration?
    
    deinit {
        messageListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChatUI()
        setListener()
        setMessage()
        setUser()
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        //Notification
        let category = UNNotificationCategory(identifier: "123", actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
//        center =
        
    }
    
    func setUser() {
        
        guard let name = Auth.auth().currentUser?.displayName else { return }
        AppSettings.displayName = name
    }
    
    
    func setListener() {
        
        guard let charRoomID = userInfo?.chatroomID else { return }
        
        reference = db.collection(["Chatroom", charRoomID, "thread"].joined(separator: "/"))
        
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
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
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
        
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
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
//        navigationController?.navigationBar.backgroundColor = UIColor.DarkBlue
        navigationController?.toolbar.tintColor = .white
        
        let image = UIImage()
        navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        navigationController?.navigationBar.shadowImage = image
        navigationController?.navigationBar.isTranslucent = true
        
        let backImage = UIImage(named: "Icons_44px_Back01")?.withRenderingMode(.alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
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
              let event = userInfo else {
            return
            
        }
        
        if message.sender.senderId == currentUser.id {
            
            avatarView.loadImage(currentUser.picture)
        } else {
            
            
            
            event.memberList.forEach { docRef in
                
                
            }
            
            avatarView.loadImage(otherUserPhoto)
        }
    }
    
}

// MARK: - MessageInputBarDelegate

extension MessageViewController: MessageInputBarDelegate {
    
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
        
        //Notification
        center?.getNotificationSettings(completionHandler: { (settings) in
            
            if settings.authorizationStatus == .authorized {
                
                self.sendNotification()
            } else if settings.authorizationStatus == .denied {
                
                self.deniedAlert()
            } else {
                return
            }
        })
    }
    
    func sendNotification() {
        
        DispatchQueue.main.async {
            
            let titleText = Auth.auth().currentUser?.displayName
            let bodyText = "您有新訊息"
            
            if titleText != nil && bodyText != nil {
                
                let customID = titleText!
                let identifier = "Message" + customID
                let content = UNMutableNotificationContent()
                content.title = titleText!
                content.body = bodyText
                content.sound = UNNotificationSound.default
                content.badge = NSNumber(integerLiteral: UIApplication.shared.applicationIconBadgeNumber + 1)
                content.categoryIdentifier = "123"
                
            }
        }
    }
    
    func deniedAlert() {
        let useNotificationsAlertController = UIAlertController(title: "Turn on notifications",
                                                                message: "This app needs notifications turned on for the best user experience \n ",
                                                                preferredStyle: .alert)
        
        let goToSettingsAction = UIAlertAction(title: "Go to settings", style: .default, handler: { (action) in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingURL) {
                UIApplication.shared.open(settingURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        useNotificationsAlertController.addAction(goToSettingsAction)
        useNotificationsAlertController.addAction(cancelAction)
        
        self.present(useNotificationsAlertController, animated: true)
    }
}
