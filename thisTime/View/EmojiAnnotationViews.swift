//
//  EmojiAnnotationViews.swift
//  thisTime
//
//  Created by semih bursali on 11/1/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import MapKit

class HappyAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "happyAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "happy"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
		glyphText =  "😀"
	}
}

class AngryAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "angryAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "angry"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.8044856191, green: 0.1853864193, blue: 0.1659093201, alpha: 1)
		glyphText = "😠"
	}
}

class MMMAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "mmmAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "mmm"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
		glyphText = "😏"
	}
}
class AaaAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "aaaAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "aaa"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
		glyphText = "😯"
	}
}
class CryAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "cryAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "cry"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
		glyphText = "😭"
	}
}
class SssAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "sssAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "sss"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.8873460889, green: 0.5229536295, blue: 0.9359019399, alpha: 1)
		glyphText = "😥"
	}
}
class XxAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "xxAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "xx"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		glyphText = "😵"
	}
}

class ZzzAnnotationView: MKMarkerAnnotationView {
	static let ReuserId = "zzzAnnotation"
	
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		clusteringIdentifier = "zzz"
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForDisplay() {
		super.prepareForDisplay()
		displayPriority = .defaultHigh
		markerTintColor = #colorLiteral(red: 0.2433976531, green: 0.9946611524, blue: 0.9004766345, alpha: 1)
		glyphText = "😴"
	}
}
