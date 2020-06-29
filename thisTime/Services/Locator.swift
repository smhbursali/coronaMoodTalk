//
//  Locator.swift
//  thisTime
//
//  Created by semih bursali on 10/22/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import MapKit

class Locator:NSObject, CLLocationManagerDelegate {

	
	let mapView:MKMapView
	var location:CLLocation
	var locationManager: CLLocationManager
	
	private(set) var isLocationLegit:Bool
	
	private var randomLocation:CLLocation?
	
	static let sharedInstance = Locator()
	
	override init() {
		mapView =  MKMapView(frame: CGRect(x: 0, y: 0, width: width, height: height))
		location = CLLocation()
		locationManager = CLLocationManager()
		isLocationLegit = false
		super.init()
	}
	
	func setLocationWithCurrentLocation()->MKMapView {
		self.location = getLocationAsCLlocation()
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: location.coordinate, span: span)
		Locator.sharedInstance.mapView.setRegion(region, animated: true)
		return Locator.sharedInstance.mapView
	}
	func setLocationWithRandomLocation()->MKMapView {
		self.location = generateRandomLocation()
		let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		let region = MKCoordinateRegion(center: location.coordinate, span: span)
		Locator.sharedInstance.mapView.setRegion(region, animated: true)
		return Locator.sharedInstance.mapView
	}

	func setActiveUserAnnotationOnMap(activeUser:ActiveUsers) {
	
		let emojiAnnotation = createEmojiAnnotation(activeUser: activeUser)
		activeUser.annotationInstance = emojiAnnotation
		Locator.sharedInstance.mapView.addAnnotation(emojiAnnotation)
	}
	
	func setYourSelfasActiveUser(activeUser:ActiveUsers) {
		let emojiAnnotation = createEmojiAnnotation(activeUser: activeUser)
	
		let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
		let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: activeUser.location.latitude, longitude: activeUser.location.longitude), span: span)
		activeUser.annotationInstance = emojiAnnotation
		Locator.sharedInstance.mapView.addAnnotation(emojiAnnotation)
		Locator.sharedInstance.mapView.setRegion(region, animated: true)
		
		
	}
	func removeSingleAnnodation(activeUser:ActiveUsers) {
		guard let annotation = activeUser.annotationInstance else {return}
		Locator.sharedInstance.mapView.removeAnnotation(annotation)
	}
	
	private func createEmojiAnnotation(activeUser:ActiveUsers)->MKAnnotation {
		let location = CLLocationCoordinate2D(latitude: activeUser.location.latitude, longitude: activeUser.location.longitude)
		let emojiAnnototation = EmojiAnnotation(coordinate: location, activeUser: activeUser)
		emojiAnnototation.type = EmojiType(rawValue: activeUser.emojiName)

		return emojiAnnototation
	}
	private func generateRandomLocation()->CLLocation {
		let loc = CLLocation().generateRandomCoordinates(fakeUser: nil)
		self.randomLocation = loc
		return loc
		
	}
	
	//if location do not authurzied return random location
	func getLocationAsCLlocation()->CLLocation {
		var location = CLLocation()
		if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse) || (CLLocationManager.authorizationStatus() == .authorizedAlways){
			location = locationManager.location ?? CLLocation(latitude: 42.6875, longitude: -73.82518176426)
			isLocationLegit = true
		}
		else {
			isLocationLegit = false
			if let loc = self.randomLocation {
				location = loc
			}
			else {
				//generate random
				location = generateRandomLocation()
				self.randomLocation = location
			}
			
			
		}
		return location
	}

	func getCityAndStateName(completion:@escaping(_ status:Bool, _ placeMark:[CLPlacemark]?, _ error:Error?)->()){
		CLGeocoder().reverseGeocodeLocation(self.getLocationAsCLlocation()) { (placeMark, error) in
			completion(true, placeMark, error)
		}
	}
	
	func getAdressDetailsFromZip(zipCode:String, completion:@escaping(_ status:Bool, _ placeMark:[CLPlacemark]?, _ error:Error?)->()) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(zipCode) {
			(placemarks, error) -> Void in
			// Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
			if error != nil {
				print("invalid")
				completion(true, nil, error)
			}
			else {
				completion(true, placemarks, nil)
			}
		}
	}
	func zoomCustomLocation(zipCode:String) {
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(zipCode) {
					(placemarks, error) -> Void in
					// Placemarks is an optional array of CLPlacemarks, first item in array is best guess of Address
					if error != nil {
						print("invalid")
					}
					else {
						let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
						let region = MKCoordinateRegion(center: placemarks?.first?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: span)
						UIView.animate(withDuration: 0.5) {
							Locator.sharedInstance.mapView.setRegion(region, animated: true)
						}
						
					}
				}
	}
	
	
	class func skewCurrentLocation(location:CLLocation)->CLLocation {
		let currentLong:Double = location.coordinate.longitude
		let currentLat:Double = location.coordinate.latitude
		let min:UInt32 = 50
		let max:UInt32 = 50
		let meterCord = 0.00900900900901 / 1000

			//Generate random Meters between the maximum and minimum Meters
			let randomMeters = UInt(arc4random_uniform(max) + min)

			//then Generating Random numbers for different Methods
			let randomPM = arc4random_uniform(8)

			//Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
			let metersCordN = meterCord * Double(randomMeters)

			//here we generate the last Coordinates
			if randomPM == 0 {
						return CLLocation(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
					}else if randomPM == 1 {
						return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
					}else if randomPM == 2 {
						return CLLocation(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
					}else if randomPM == 3 {
						return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
					}else if randomPM == 4 {
						return CLLocation(latitude: currentLat, longitude: currentLong - metersCordN)
					}else {
						return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong)
					}
	}
	
	
}


