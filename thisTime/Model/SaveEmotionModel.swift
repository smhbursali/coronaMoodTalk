//
//  SaveEmotionModel.swift
//  thisTime
//
//  Created by semih bursali on 10/26/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import FirebaseFirestore

public var lastpublicDocRef = [DocumentReference]()

struct SaveEmotionModel {
	private(set) var location: GeoPoint
	private(set) var emojiName:String
	private(set) var emotionTitle:String?
	private(set) var isLocationLegit:Bool
	private(set) var about:String?
	
	init(location:GeoPoint, emojiName:String, emotionTitle:String?, isLocationLegit:Bool, about:String?) {
		self.location = location
		self.emojiName = emojiName
		self.emotionTitle = emotionTitle
		self.isLocationLegit = isLocationLegit
		self.about = about
		
	}
}


