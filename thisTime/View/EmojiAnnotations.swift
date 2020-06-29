//
//  EmojiAnnotations.swift
//  thisTime
//
//  Created by semih bursali on 11/1/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import MapKit

class EmojiAnnotation : NSObject, MKAnnotation {
	
	@objc dynamic var coordinate: CLLocationCoordinate2D
    
	var type:EmojiType?
	private(set) var activeUser:ActiveUsers
	private(set) var title: String?
	var subtitle: String?

	init(coordinate: CLLocationCoordinate2D, activeUser:ActiveUsers) {
        self.coordinate = coordinate
		self.activeUser = activeUser
        super.init()
		title = activeUser.emotionTitle
		
    }
	
	
}
