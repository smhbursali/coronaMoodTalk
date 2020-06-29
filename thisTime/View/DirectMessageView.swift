//
//  DirectMessageView.swift
//  thisTime
//
//  Created by semih bursali on 3/15/20.
//  Copyright © 2020 semih bursali. All rights reserved.
//

import UIKit
import FirebaseFirestore

class DirekMessageView:NSObject {
	
	private var messages = [MessageModel]()
	private var receiverUid:String?
	private var receiverNickName:String?
	private var messageDocId:String?
	private var lastDocumentRefForBackPagination:QueryDocumentSnapshot?
	private var isOldDataSearhing = false
	private var usersOnlineStatus:usersOnlineStatusOnMessageDoc?
	
	private var lastSendMessageIsTrueForChatHistoryUpdate:Bool?
	
	
	static let sharedInstance = DirekMessageView(frame:CGRect(x: 0, y: 0, width: shapeSize.width1, height: shapeSize.height2))
	
	private var viewCenter:CGPoint!
	
	init(frame:CGRect) {
		super.init()
		view.frame = frame
		viewCenter = view.center
	}
	
	
	lazy var view: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
		view.addGestureRecognizer(swipeDown)
		
		
		view.addSubview(messageCollectionView)
		view.addSubview(postView)
		[postFieldTxt.bottomAnchor.constraint(equalTo: postView.bottomAnchor),
		postFieldTxt.leadingAnchor.constraint(equalTo: postView.leadingAnchor),
		postFieldTxt.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor),
		postFieldTxt.heightAnchor.constraint(equalToConstant: 34)
		].forEach{$0.isActive = true}
			  
		return view
	}()
	
	private lazy var messageCollectionView: UICollectionView = {
		  let flowLayout = UICollectionViewFlowLayout()
		  flowLayout.minimumLineSpacing = 0
		  let frame = CGRect(x: 0, y: 0, width: width, height: shapeSize.height2 - 34)
		  let colView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
		  colView.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
		  let radians = atan2f(Float(colView.transform.b), Float(colView.transform.a))
		  let degrees = radians * (180 / Float.pi)
		  let transform = CGAffineTransform(rotationAngle: CGFloat((180 + degrees) * Float.pi/180))
		  colView.transform = transform
		  colView.register(MessageCell.self, forCellWithReuseIdentifier: "messageCell")
		  colView.delegate = self
		  colView.dataSource = self
	
		
		  return colView
	  }()
	
	
    private lazy var postView:UIView = {
        let viewPost = UIView()
        viewPost.frame = CGRect(x: 0, y: shapeSize.height2 - 34 , width: shapeSize.width1, height: 34)
		viewPost.backgroundColor = .clear
        viewPost.addSubview(sendBtn)
        viewPost.addSubview(postFieldTxt)
							
        return viewPost
    }()
    private lazy var  postFieldTxt: UITextView = {
        let txt = UITextView()
        txt.isScrollEnabled = false
        txt.delegate = self
        txt.oval(edge: 1)
        txt.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 3, right: 5)
		txt.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
        txt.textColor = .darkGray
        txt.keyboardAppearance = .dark
        txt.font = UIFont(name: "Avenir Next", size: 15)
        txt.layer.borderWidth = 0.5
		txt.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		txt.translatesAutoresizingMaskIntoConstraints = false
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.textviewTapped))
		txt.addGestureRecognizer(gesture)
		
        return txt
		
    }()
    private lazy var sendBtn: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: shapeSize.width1 - shapeSize.width6, y: 0, width: shapeSize.width6, height: 34)
		btn.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
		btn.layer.borderWidth = 0.5
		btn.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		btn.addTarget(self, action: #selector(self.sendBtnTapped), for: .touchUpInside)
		btn.setTitle("⇧", for: .normal)
		btn.setTitleColor(#colorLiteral(red: 0.08704058081, green: 0.3704862595, blue: 0.8124318719, alpha: 1), for: .normal)
        btn.oval(edge: 1)
       return btn
    }()
	
	@IBAction func sendBtnTapped(_ sender:UIButton) {
		if UITextView.validate(textView: self.postFieldTxt) {
			let trimmed = self.postFieldTxt.text.trimmingCharacters(in: .whitespacesAndNewlines)
			guard let receiverUid = self.receiverUid,
				let messageDociD = self.messageDocId else {return}
			DataService.sendDirectMessage(receiverUid: receiverUid, message: MessageModel(message: trimmed, createdAt: Date().timeIntervalSince1970, senderUid: DataService.uid), messageDocId: messageDociD)
			self.clearScreen()
			
			
			guard let receiverOnlineStatus = self.usersOnlineStatus?.receiverUidAndStatus,
				let status = receiverOnlineStatus[self.receiverUid ?? "err"] else {return}
			if !status {
				//send last message to chat notidication/uid doc
				DataService.increaseUnseenMessages(receiverUid: self.receiverUid ?? "err", messageDocId: self.messageDocId ?? "err", lastMessage: trimmed)
			}
			else {
				//send last message to history collection
				DataService.sendLastMessageToHistoryCollectionReceiver(messageDocId: self.messageDocId ?? "err", lastMessage: trimmed, receiverUid: self.receiverUid ?? "")
			}
			
			//write here last message into charHistory for himself
			//here is apporiate for batch writing but later
			DataService.sendLastMessageToHistoryCollectionForSender(messageDocId: self.messageDocId ?? "err", lastMessage: trimmed, receiverNickName: self.receiverNickName ?? "err nick name", receiverUid: receiverUid)
			
			self.lastSendMessageIsTrueForChatHistoryUpdate = true
		}
	}
	
	func prepareForNextDisplay(receiverUid:String, receiverNickName:String, isComingFromMap:Bool)->UIView {
		self.receiverUid = nil
		self.messageDocId = nil
		self.receiverNickName = nil
		self.lastSendMessageIsTrueForChatHistoryUpdate = nil
		self.receiverUid = receiverUid
		self.receiverNickName = receiverNickName
		self.messageDocId = DataService.generateMessageDocId(receiverUid: receiverUid, index: 0)
		self.messageDataCall(receiverUid: receiverUid)
		messages.removeAll(keepingCapacity: false)
		messageCollectionView.reloadData()
		self.clearScreen()
		view.alpha = 1
		view.center = viewCenter
		
		DataService.flagUserAsOnlineOnSpecificMessageId(messageDocId: self.messageDocId ?? "err messageDocId online")
		userOnlineStatusListener(receiverUid: self.receiverUid ?? "err")
		self.postFieldTxt.becomeFirstResponder()
		
		if isComingFromMap, let messageDocID = self.messageDocId {
			print("user already send message")
			//check here if user aldredy send the client a message
			if let exist = checkUserAlreadySendMessageIiComesTroughMap(messageDocId: messageDocID) {
				//decrease here Unssen message count
				DataService.decreaseUnseenMessages(message: exist)
			}
			else {
				print("it is not listed under notification!!!!")
			}
		}
		
		
		return view
	}
	private func checkUserAlreadySendMessageIiComesTroughMap(messageDocId:String)->chatHistoryMessageStruct? {
		return chatNotificationInstance?.unSeenMessageDocIds.filter({$0.messageDocId == messageDocId}).first
	}
	
	private func clearScreen() {
		postFieldTxt.text.removeAll()
		postFieldTxt.constraints.forEach { (const) in
			if const.firstAttribute == .height {
				const.constant = 34
			}
		}
	}
	 private func cleanDirekMessageListener() {
		if messageDatalistener != nil {
			messageDatalistener?.remove()
			messageDatalistener = nil
		}
		if userOnlineStatusListenerForDM != nil {
			//flag user as offline here
			DataService.flagUserAsOfflineOnSpecificMessageId(messageId: self.messageDocId ?? "err messageDocId offline")
			userOnlineStatusListenerForDM?.remove()
			userOnlineStatusListenerForDM = nil
		}
		lastDocumentRefForBackPagination = nil
	}
	private func localchatHistoryUpdate() {
		guard let lastMessage = self.lastSendMessageIsTrueForChatHistoryUpdate else {return}
		if lastMessage {
			NotificationView.sharedInstance.requestChatHistoryData()
		}
		
	}
	
	private func messageDataCall(receiverUid:String) {
		guard let messageDocId = self.messageDocId else {return}
		DataService.direckMessageDataListen(messageDocId: messageDocId, receiverUid: receiverUid) { (status, docSnaps, lastDoc, error) in
			if status {
				guard error != nil else {
					if self.lastDocumentRefForBackPagination == nil {
						self.lastDocumentRefForBackPagination = lastDoc
					}

					docSnaps?.documentChanges.reversed().forEach({ (change) in
						switch change.type {
						case .added:
							let parsedData = MessageModel.parseDocSnap(docSnap: change.document)
							self.messages.insert(parsedData, at: 0)
							self.messageCollectionView.insertItems(at: [IndexPath(row: 0, section: 0)])
						default:
							break
						}
					})
					return
				}
	
			
			}
		}
	}
	
	private func userOnlineStatusListener(receiverUid:String) {
		guard let messageDocID = self.messageDocId else {return}
		DataService.direkMessageUserStatusListener(messageDocId: messageDocID, receiverUid: receiverUid) { (status, docSnap, error) in
			if status {
				if error == nil {
					self.usersOnlineStatus = usersOnlineStatusOnMessageDoc.parseDocSnap(docSnap: docSnap, receiverUid: receiverUid)
				}
			}
		}
	}
	
	@IBAction func respondToSwipeGesture(_ gestureRecognizer:UIPanGestureRecognizer) {
		guard let gestureView = gestureRecognizer.view else {return}
		postFieldTxt.endEditing(true)
		let translation = gestureRecognizer.translation(in: self.view)
		
		switch gestureRecognizer.state {
		case .began, .changed:
			gestureView.center.y = gestureView.center.y + translation.y
			gestureRecognizer.setTranslation(.zero, in: self.view)
		case .ended:
			if self.view.center.y < 20.0 {
				directMessageViewClose()
			}else {
				UIView.animate(withDuration: 0.4) {
					gestureView.center = self.viewCenter
				}
			}
		default:
			break
		}
	}
	
	func directMessageViewClose(){
		UIView.animate(withDuration: 0.5) {
			self.view.alpha = 0.0
			self.cleanDirekMessageListener()
			self.localchatHistoryUpdate()
			self.postFieldTxt.resignFirstResponder()
		}
	}
	
	func oldDataRequest() {
		if isOldDataSearhing {
			return
		}
		isOldDataSearhing = true
		guard let docId = self.messageDocId,
			let lastdoc = self.lastDocumentRefForBackPagination,
			let receiverId = self.receiverUid
		    else {
				isOldDataSearhing = false
				return}
		DataService.queryOldMessageData(messageDocId: docId, receiverUid: receiverId, lastDoc: lastdoc) { (status, querySnaps, error) in
			if status {
				guard error != nil else {
					self.lastDocumentRefForBackPagination = querySnaps?.documents.last
					querySnaps?.documents.forEach({ (doc) in
						let parsedData = MessageModel.parseDocSnap(docSnap: doc)
						self.messages.append(parsedData)
						self.messageCollectionView.insertItems(at: [IndexPath(item: self.messages.count - 1, section: 0)])
						
					})
					self.isOldDataSearhing = false
					return
				}
				self.isOldDataSearhing = false
			}else {
				self.isOldDataSearhing = false
			}
		}
		
	}
	
}

extension DirekMessageView: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let size = CGSize(width: postView.frame.size.width - shapeSize.width6 - 10, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach {(constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 200
    }
	@IBAction func textviewTapped(_ gesture:UITapGestureRecognizer) {
		guard let gestureView = gesture.view else {return}
		if !gestureView.isFirstResponder {
			gestureView.becomeFirstResponder()
		}
	}
}
extension DirekMessageView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messageCell", for: indexPath) as? MessageCell {
            var estimatedSize:CGFloat = 0.0
            let estimatedTextHeight = messages[indexPath.row].message
            estimatedSize = estimatedTextHeight.height(withConstrainedWidth: (shapeSize.width1 * 2) / 3, font: DIRECT_MESSAGE_TEXT_FONT!)
            let widthCell = messages[indexPath.row].message.widthOfString(usingFont: DIRECT_MESSAGE_TEXT_FONT!)
            cell.configureCell(messege: messages[indexPath.row], heightCell: estimatedSize, widthCell: widthCell)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var estimatedSize:CGFloat = 0.0
        let estimatedTextHeight = messages[indexPath.row].message
		estimatedSize = estimatedTextHeight.height(withConstrainedWidth: (shapeSize.width1 * 2) / 3, font: DIRECT_MESSAGE_TEXT_FONT!)
        return CGSize(width: shapeSize.width1, height: estimatedSize + 15)
    }
   
 
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if indexPath.row == messages.count - 1 && messages.count != 1 {
			self.oldDataRequest()
        }

    }
    
  
}


