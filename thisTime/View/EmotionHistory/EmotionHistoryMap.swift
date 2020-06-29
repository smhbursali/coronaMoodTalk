//
//  EmotionHistoryMap.swift
//  thisTime
//
//  Created by semih bursali on 11/23/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import MapKit

class EmotionHistoryMap:NSObject, CLLocationManagerDelegate {
	
	let mapView:MKMapView
	
	
	static let sharedInstance = EmotionHistoryMap()
	
	override init() {
		mapView =  MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: height))
		super.init()
		mapView.addSubview(dissmissBtn)
	}
	
	private lazy var dissmissBtn:UIButton = {
	 let btn = UIButton()
		btn.frame = CGRect(x: 20, y: 100, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.dissmissTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
		return btn
	}()
	
	
	func displayHistoryMap()->MKMapView {
		guard let data = CoreDataManager.sharedInstance.localEmotions else {return EmotionHistoryMap.sharedInstance.mapView}
		for emotion in data {
			self.setAnnotationOnMap(emotion: emotion)
		}
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		
		if let firstData = data.first {
		let region = MKCoordinateRegion(center: clLocationConverter(emotion: firstData), span: span)
			EmotionHistoryMap.sharedInstance.mapView.setRegion(region, animated: true)
		}
		
		return EmotionHistoryMap.sharedInstance.mapView
	}
	
	
	private func setAnnotationOnMap(emotion:Emotions) {
		guard let anno = self.createEmojiAnnotation(emotion: emotion) else {

			return}
		EmotionHistoryMap.sharedInstance.mapView.addAnnotation(anno)
	}
	
	private func createEmojiAnnotation(emotion:Emotions)->MKAnnotation? {
		guard let type = emotion.emojiName else {return nil}
		let emojiAnnotation = EmojiAnnotationForHistory(forPersonalHistory: emotion, coordinate: clLocationConverter(emotion: emotion))
			emojiAnnotation.type = EmojiType(rawValue: type)
			return emojiAnnotation
	}
	
	private func clLocationConverter(emotion:Emotions)->CLLocationCoordinate2D {
		guard let lat = emotion.latitude,
				let long = emotion.longitude
				else {return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
		if let lat2 = Double(lat), let long2 = Double(long) {
			return CLLocationCoordinate2D(latitude: lat2, longitude: long2)
		}
		return CLLocationCoordinate2D(latitude: 0, longitude: 0)
	}
	
	@IBAction func dissmissTapped(sender:UIButton)  {
		EmotionHistoryMap.sharedInstance.mapView.removeFromSuperview()
	}
}
