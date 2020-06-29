//
//  EmojiAnotationForHistory.swift
//  thisTime
//
//  Created by semih bursali on 11/24/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import MapKit

class EmojiAnnotationForHistory : NSObject, MKAnnotation {
	
	@objc dynamic var coordinate: CLLocationCoordinate2D
    
	var type:EmojiType?
	private(set) var emotion:Emotions
	private(set) var title: String?
	var subtitle: String?

	init(forPersonalHistory emotion:Emotions, coordinate:CLLocationCoordinate2D) {
		self.coordinate = coordinate
		self.emotion = emotion
		super.init()
		title = emotion.emotionTitle

	}
	
	
}

