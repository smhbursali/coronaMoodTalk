//
//  ActiveUsersDataModel.swift
//  thisTime
//
//  Created by semih bursali on 10/30/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit

class ActiveUsers {
	private(set) var emotionTitle:String
	private(set) var createdAt:TimeInterval
	private(set) var emojiName:String
	private(set) var location: GeoPoint
	private(set) var activeUserUid:String
	private(set) var about:String?
	private(set) var nickName:String
	
	var annotationInstance:MKAnnotation?
	
	init(emotionTitle:String, createdAt:TimeInterval, emojiName:String, location:GeoPoint, activeUserId:String, about:String?, nickName:String) {
		self.emotionTitle = emotionTitle
		self.createdAt = createdAt
		self.emojiName = emojiName
		self.location = location
		self.activeUserUid = activeUserId
		self.about = about
		self.nickName = nickName
	}
	
	class func parseActiveUserQuerySnapsots(querySnapshots:QuerySnapshot?)->[ActiveUsers]? {
		var data = [ActiveUsers]()
		guard let snaps = querySnapshots else {
			return data
		}
		for docData in snaps.documents {
			let singleDocData = docData.data()
			let emotionTitle  = singleDocData[EMOTION_TITLE_REF] as? String ?? ""
			let emojiName = singleDocData[EMOJI_NAME_REF] as? String ?? ""
			let createdAt = singleDocData[CRETAED_AT_REF] as? TimeInterval ?? 0.0
			let location = singleDocData[LOCATION_REF] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
			let activeUserid = singleDocData[UID_REF] as? String ?? ""
			let about = singleDocData[ABOUT_REF] as? String
			let nickName = singleDocData[NICK_NAME_REF] as? String ?? ""
		
			data.append(ActiveUsers(emotionTitle: emotionTitle, createdAt: createdAt, emojiName: emojiName, location: location, activeUserId: activeUserid, about: about, nickName: nickName))
		}
		return data
	}
	
	class func parseActiveUserDocumentSnapsots(documentSnap:DocumentSnapshot?)->ActiveUsers? {
		var data: ActiveUsers?
		guard let snaps = documentSnap,
		let singleDocData = snaps.data() else {
			return data
		}
			let emotionTitle  = singleDocData[EMOTION_TITLE_REF] as? String ?? ""
			let emojiName = singleDocData[EMOJI_NAME_REF] as? String ?? ""
			let createdAt = singleDocData[CRETAED_AT_REF] as? TimeInterval ?? 0.0
			let location = singleDocData[LOCATION_REF] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
			let activeUserid = singleDocData[UID_REF] as? String ?? ""
			let about = singleDocData[ABOUT_REF] as? String
			let nickName = singleDocData[NICK_NAME_REF] as? String ?? ""
			data = ActiveUsers(emotionTitle: emotionTitle, createdAt: createdAt, emojiName: emojiName, location: location, activeUserId: activeUserid, about: about, nickName: nickName)
		return data
	}
}
