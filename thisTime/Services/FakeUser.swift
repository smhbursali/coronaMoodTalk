//
//  FakeUser.swift
//  thisTime
//
//  Created by semih bursali on 10/30/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import FirebaseFirestore
import CoreLocation

class FakeUser {
	//static let sharedInstance = FakeUser()
	
	func savePublicLocation(nick:String, emojiName:String, emotionTitle:String?, completion:@escaping(_ status:Bool, _ error:Error?, _ docRef:DocumentReference)->()){
		self.publicLocationDocumentReferenceForFakeUser { (status, docRef, fakeUid) in
			if status {
				let location = CLLocation().generateRandomCoordinates(fakeUser: true).coordinate
				let data:[String:Any] = [
						   LOCATION_REF : DataService.firLocationConverter(latitude: location.latitude, longitude: location.longitude),
						   CRETAED_AT_REF: Date().timeIntervalSince1970,
						   EMOJI_NAME_REF : emojiName,
						   EMOTION_TITLE_REF : emotionTitle as Any,
						   UID_REF: fakeUid,
						   ABOUT_REF: "\(String(describing: emotionTitle))\n\(fakeUid)" as Any,
						   NICK_NAME_REF : nick
				]
				docRef.setData(data, merge: true) { (error) in
					completion(true, error, docRef)
			}
		}
		
		}
	}
	func generateFakeUser(howMany:Int, emojiName:String, title:String){
		for i in 0...howMany {
			self.savePublicLocation(nick: "\(emojiName)  + \(i)", emojiName: emojiName, emotionTitle: "\(title)") { (status, error, docref) in
				print("fake\(i) created")
			}
		}
		
	}
	private func publicLocationDocumentReferenceForFakeUser(completion:@escaping(_ status:Bool, _ docReference:DocumentReference, _ fakeUid:String)->()) {
		Locator.sharedInstance.getCityAndStateName { (status, placeMark, error) in
				if status {
				let fakeUid = self.randomString(length: 28)
				Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(fakeUid).setData([TOTAL_UNSEEN_MESSAGES_REF : 0])
					if error == nil {
						if let country = placeMark?.first?.country {
							if let administrativeArea = placeMark?.first?.administrativeArea {
								if let subAdministrativeArea = placeMark?.first?.subAdministrativeArea {
									if let postalCode = placeMark?.first?.postalCode {
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(POSTAL_CODE_REF).document(postalCode).collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
									}
									else {
										//contry, state , city, no zip
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
									}
								}
								else {
									//contry, state , no city
									completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
								}
							}
							else {
								// country no state
								completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
							}
						}
						else {
							//no country
							completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry").collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
						}

					}
					else {
						completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry2").collection(ACTIVE_USERS_REF).document(fakeUid), fakeUid)
					}
				
				}
			}
	}
	 func randomString(length: Int) -> String {
	  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	  return String((0..<length).map{ _ in letters.randomElement()! })
	}

}
