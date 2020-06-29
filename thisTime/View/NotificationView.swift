//
//  NotificationView.swift
//  thisTime
//
//  Created by semih bursali on 11/8/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import FirebaseFirestore

class NotificationView:NSObject {
	
	private var chatHistoryData = [chatHistoryMessageStruct]()
	private var lastChatDocRef:QueryDocumentSnapshot?
	private var combinedChatHistoryData:[chatHistoryMessageStruct]?
	private var isDataOnRequest = false
	
	static let sharedInstance = NotificationView(frame: CGRect(x: shapeSize.width1 / 2 - 25, y: height - 60, width: 50, height: 50))
	private var isTableOn = false
	
	init(frame:CGRect) {
		super.init()
		notifBtn.frame = frame
	}
	
	private lazy var notifBtn:UIButton = {
		let btn = UIButton()
		btn.setImage(#imageLiteral(resourceName: "notif"), for: .normal)
		btn.addTarget(self, action: #selector(self.notifBtnTapped), for: .touchUpInside)
		btn.addSubview(notifLbl)
		btn.addSubview(openCloseLabel)
		return btn
	}()
	lazy var notifLbl:UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: 25, y: 25, width: 20, height: 20)
		lbl.adjustsFontSizeToFitWidth = true
		lbl.backgroundColor = .clear
		lbl.oval(edge: 10)
		lbl.padding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
		lbl.font = UIFont(name: "Avenir Next", size: 11)
		lbl.textAlignment = .center
		lbl.textColor = .white
		
		return lbl
	}()
	lazy var openCloseLabel:UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: 11, y: 8, width: 25, height: 15)
		lbl.adjustsFontSizeToFitWidth = true
		lbl.font = UIFont.preferredFont(forTextStyle: .body)
		lbl.textAlignment = .center
		lbl.text = "open"
		return lbl
	}()
	 private lazy var chatPersonTableView:UITableView = {
		let table = UITableView()
		table.frame = CGRect(x: 40, y: shapeSize.height2 - 61, width: shapeSize.width1 - 80, height: shapeSize.height2)
		table.delegate = self
		table.dataSource = self
		table.register(ChatPersonCell.self, forCellReuseIdentifier: "chatPerson")
		table.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
		table.oval(edge: 5)
		table.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
		table.rowHeight = 60
		return table
	}()
	
	func prepareForDisplay()->UIButton {
		return notifBtn
	}
	
	
	@IBAction func notifBtnTapped(_ sender:UIButton) {
		if isTableOn {
			isTableOn = false
			chatPersonTableView.removeFromSuperview()
			openCloseLabel.text = "open"
			
			chatHistoryData.removeAll()
			lastChatDocRef = nil
			chatPersonTableView.reloadData()
			isDataOnRequest = false
		}
		else if !isTableOn {
			isTableOn = true
			notifBtn.superview?.addSubview(chatPersonTableView)
			openCloseLabel.text = "close"
			
		}
		
	}
	func requestChatHistoryData() {
		isDataOnRequest = false
		lastChatDocRef = nil
		chatHistoryData.removeAll()
		DataService.requestChatHistoryDocs(lastDocument: nil) { (status, response, lastDoc, error) in
			if status {
				guard let err = error,
					response?.count ?? 0 < 1
				else {
					self.lastChatDocRef = lastDoc
					self.chatHistoryData.append(contentsOf: response!)
					if let unSeenData = chatNotificationInstance?.unSeenMessageDocIds {
						self.combinedChatHistoryData = unSeenData + self.chatHistoryData
					}
					else {
						//there is no un seen data
						self.combinedChatHistoryData = self.chatHistoryData
					}
				
					self.chatPersonTableView.reloadData()
					return
				}
				print("err \(err)")
			}
		}
	}
	
	func requestPaginatedHistoryData() {
		if isDataOnRequest {
			return
		}
		isDataOnRequest = true
		print("pagination 11")
		guard let lastDoc = self.lastChatDocRef else {return}
				print("pagination 22")
		DataService.requestChatHistoryDocs(lastDocument: lastDoc) { (status, response, newLastDoc, error) in
			if status {
				if error == nil {
					self.lastChatDocRef = newLastDoc
					guard let res = response else {
						self.isDataOnRequest = false
						return}
			
					var indexPaths = [IndexPath]()
					for i in 0..<res.count {
						indexPaths.append(IndexPath(row: (self.combinedChatHistoryData?.count ?? 0) + i, section: 0))
					}
				
					self.combinedChatHistoryData?.append(contentsOf: res)
					self.chatPersonTableView.insertRows(at: indexPaths, with: .automatic)
					self.isDataOnRequest = false
				}
				else {
					self.isDataOnRequest = false
				}
			}
		}
	}
	
}

extension NotificationView: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return combinedChatHistoryData?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatPerson", for: indexPath) as? ChatPersonCell
			else {return UITableViewCell()}
		
		if let cellDataForUnSeenMessage = combinedChatHistoryData?[indexPath.row] {
			cell.configureCell(message: cellDataForUnSeenMessage)
		}
	
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == (self.combinedChatHistoryData?.count ?? 1) - 1 && (self.combinedChatHistoryData?.count ?? 1) - 1 !=  1 {
			self.requestPaginatedHistoryData()
		}
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let messagePack = self.combinedChatHistoryData?[indexPath.row] else {return}
		self.notifBtnTapped(self.notifBtn)
		if messagePack.isUnseen {
			//clicked to notified mesage
			//update notification table here
			DataService.decreaseUnseenMessages(message: messagePack)
		}
		self.notifBtn.superview?.addSubview(DirekMessageView.sharedInstance.prepareForNextDisplay(receiverUid: messagePack.crossUid, receiverNickName: messagePack.crossNickName, isComingFromMap: false))
		
	}
	
	
}


