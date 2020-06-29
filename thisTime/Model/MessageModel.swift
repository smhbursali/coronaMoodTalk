//
//  MessageModel.swift
//  thisTime
//
//  Created by semih bursali on 11/5/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import FirebaseFirestore

class MessageModel {
	private(set) var message:String
	private(set) var createdAt:TimeInterval
	private(set) var senderUID:String
	init(message:String,createdAt:TimeInterval, senderUid:String ) {
		self.message = message
		self.createdAt = createdAt
		self.senderUID = senderUid
	}
	
	class func parseDataAsJson(data:MessageModel)->[String:Any] {
		return [
			MESSAGES_REF: data.message,
			CRETAED_AT_REF : data.createdAt,
			SENDER_UID_REF : data.senderUID
		]
	}
	
	class func parseDocSnap(docSnap:DocumentSnapshot)->MessageModel {
		let data = docSnap.data()
		return MessageModel(message: data?[MESSAGES_REF] as? String ?? "", createdAt: data?[CRETAED_AT_REF] as? TimeInterval ?? Date().timeIntervalSince1970, senderUid: data?[SENDER_UID_REF] as? String ?? "err")
	}
}

struct usersOnlineStatusOnMessageDoc {
	var receiverUidAndStatus: [String:Bool]
	var yourSelf: [String:Bool]
	init(receiverUidAndStatus:[String:Bool], yourSelf:[String:Bool]) {
		self.receiverUidAndStatus = receiverUidAndStatus
		self.yourSelf = yourSelf
	}
	
	static func parseDocSnap(docSnap:DocumentSnapshot?, receiverUid:String)->usersOnlineStatusOnMessageDoc {
		guard let data = docSnap?.data()?[receiverUid] as? Bool else {return usersOnlineStatusOnMessageDoc(receiverUidAndStatus: [receiverUid:false], yourSelf: [DataService.uid: true])}
		
		return usersOnlineStatusOnMessageDoc(receiverUidAndStatus: [receiverUid:data], yourSelf: [DataService.uid: true])
	}
}

struct chatNotification {
	var totalUnSeenMessages:Int
	var unSeenMessageDocIds:[chatHistoryMessageStruct]
	
	init(totalUnseenMessage:Int, unSeenMessageDocIds:[chatHistoryMessageStruct]) {
		self.totalUnSeenMessages = totalUnseenMessage
		self.unSeenMessageDocIds = unSeenMessageDocIds
	}
	
	static func parseSnapDoc(docSnap:DocumentSnapshot?) -> chatNotification {
		return chatNotification(totalUnseenMessage: docSnap?[TOTAL_UNSEEN_MESSAGES_REF] as? Int ?? 0, unSeenMessageDocIds:chatHistoryMessageStruct.parseDataForUnseenDoc(docSnap: docSnap) ?? [chatHistoryMessageStruct]())
	}
}


struct chatHistoryMessageStruct {
	//first comes unSeen messages then history collection docs
	var messageDocId:String
	var lastMessage:String
	var subTotalUnSeen:Int
	var lastMessageTime:TimeInterval
	var crossNickName:String
	var isUnseen:Bool
	var crossUid:String
	
	init(messageDocID:String, lastMessage:String, subTotalUnseen:Int, lastMessageTime:TimeInterval, senderNickName:String, isUnseen:Bool, receiverUid:String) {
		self.messageDocId = messageDocID
		self.lastMessage = lastMessage
		self.subTotalUnSeen = subTotalUnseen
		self.lastMessageTime = lastMessageTime
		self.crossNickName = senderNickName
		self.isUnseen = isUnseen
		self.crossUid = receiverUid
	}
	
	static func parseDataForUnseenDoc(docSnap:DocumentSnapshot?)->[chatHistoryMessageStruct]? {
		guard let data = docSnap?.data()?[UNSEEN_MESSAGE_DOC_IDS_REF] as? [String:Any] else {return [chatHistoryMessageStruct]()}
		var result = [chatHistoryMessageStruct]()
		for signleBatch in data {
			guard let ttt = signleBatch.value as? [String:Any] else {return result}
			result.append(chatHistoryMessageStruct(messageDocID: signleBatch.key, lastMessage: ttt[LAST_MESSAGE_REF] as? String ?? "", subTotalUnseen: ttt[SUB_TOTAL_UNSEEN_MESSAGE_REF] as? Int ?? 0, lastMessageTime: ttt[TIME_LAST_MESSAGE_SEND_REF] as? TimeInterval ?? Date().timeIntervalSince1970, senderNickName: ttt[CROSS_NICK_NAME_REF] as? String ?? "S", isUnseen: true, receiverUid: ttt[CROSS_UID_REF] as? String ?? "err uid"))
		}
		return result
	}
	
	static func parseDataForHistoryCollection(docSnaps:QuerySnapshot?)->[chatHistoryMessageStruct] {
		guard let data = docSnaps?.documents else {return [chatHistoryMessageStruct]() }
		var result = [chatHistoryMessageStruct]()
		for doc in data {
			result.append(chatHistoryMessageStruct(messageDocID: doc.documentID, lastMessage: doc[LAST_MESSAGE_REF] as? String ?? "no content", subTotalUnseen: 0, lastMessageTime: doc[TIME_LAST_MESSAGE_SEND_REF] as? TimeInterval ?? Date().timeIntervalSince1970, senderNickName: doc[CROSS_NICK_NAME_REF] as? String ?? "E", isUnseen: doc[IS_MESSAGE_UN_SEEN_REF] as? Bool ?? false, receiverUid: doc[CROSS_UID_REF] as? String ?? "err uid"))
		}
		return result
	}
}
