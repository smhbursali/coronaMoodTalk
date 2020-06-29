//
//  UserModel.swift
//  thisTime
//
//  Created by semih bursali on 11/4/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import FirebaseFirestore

class UserModel {
	private(set) var nickName:String
	 var totalEmotionExpress:Int
	 var about:String?
	 var lastKnownLocation:GeoPoint?
	
	init(nickName:String, totalEmotionExpress:Int, about:String?, lasKnownLocation:GeoPoint?) {
		self.nickName = nickName
		self.totalEmotionExpress = totalEmotionExpress
		self.about = about
		self.lastKnownLocation = lasKnownLocation
	}
	
	class func dataParser(docSnap:DocumentSnapshot, completion:@escaping(_ status:Bool, _ respose:UserModel?)->()) {
		guard let data = docSnap.data(),
			let nickName = data[NICK_NAME_REF] as? String,
			let totalExpress = data[TOTAL_EXPRESSION_REF] as? Int
			else  {
				completion(true, nil)
				return}
		   let lastKnownLoc = data[LAST_LEGIT_LOCATION_REF] as? GeoPoint
		   let about = data[ABOUT_REF] as? String
		
		completion(true, UserModel(nickName: nickName, totalEmotionExpress: totalExpress, about: about, lasKnownLocation: lastKnownLoc))
	}
	
	
}
