//
//  DataServices.swift
//  thisTime
//
//  Created by semih bursali on 10/22/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth
import Firebase
import MapKit

class DataService {
	static let sharedInstance = DataService()
	static var uid:String {
		if let uid = Auth.auth().currentUser?.uid {
			return uid
		}
		else {
			return "err"
		}
	}
	static var userDataModel:UserModel?
	
	init() {
		//get users info
		guard let uid1 = Auth.auth().currentUser?.uid else {return}
		Firestore.firestore().collection(USER_TABLE_REF).document(uid1).getDocument { (docSnap, error) in
			guard let err = error else {
				guard let snap = docSnap else {return}
				UserModel.dataParser(docSnap: snap) { (status, response) in
					if status {
						guard let res = response else {
							return
						}
						DataService.userDataModel = res
					}
				}
				
				return
			}
			print(err)
		}
	}
	
	
	class func firLocationConverter(latitude:Double, longitude:Double)-> GeoPoint  {
		return Firebase.GeoPoint(latitude: latitude, longitude: longitude)
	}
	
	class func logOut() {
		try! Auth.auth().signOut()
	}
	
	class func createUser(nickName:String, completion:@escaping(_ status:Bool, _ error:Error?)->()) {
		Auth.auth().signInAnonymously { (result, error) in
			if let err = error {
				completion(true, err)
			}
			else {
				guard let uid = Auth.auth().currentUser?.uid else {return}
				Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(uid).setData([TOTAL_UNSEEN_MESSAGES_REF : 0])
				Firestore.firestore().collection(USER_TABLE_REF).document(uid).setData([
					NICK_NAME_REF : nickName,
					TOTAL_EXPRESSION_REF : 0,
					ABOUT_REF : ""
				]) { (error) in
					guard let err = error else {
						DataService.userDataModel = UserModel(nickName: nickName, totalEmotionExpress: 0, about: "", lasKnownLocation: nil)
						completion(true, nil)
						
						return
					}
					completion(true, err)
				}
			}
		}
	}
	class func savePublicLocation(emotion:SaveEmotionModel, isLocationSkewed:Bool, completion:@escaping(_ status:Bool, _ error:Error?, _ docRef:DocumentReference)->()){
		DataService.sharedInstance.publicLocationDocumentReference { (status, docRef) in
			if status {
				let data:[String:Any] = [
					LOCATION_REF : emotion.location,
						   CRETAED_AT_REF: Date().timeIntervalSince1970,
						   EMOJI_NAME_REF : emotion.emojiName,
						   EMOTION_TITLE_REF : emotion.emotionTitle as Any,
						   UID_REF: DataService.uid,
						   ABOUT_REF : emotion.about as Any,
						   NICK_NAME_REF : DataService.userDataModel?.nickName as Any,
						   IS_LOCATION_SKEWED_REF: isLocationSkewed
				]
				docRef.setData(data, merge: true) { (error) in
					completion(true, error, docRef)
				}
			}
		}
	
	}
	class func saveEmotionForUser(emotion:SaveEmotionModel, isLastKnownLocLegit:Bool, isDataInCore:Bool) {
		let data:[String:Any] = [
			LOCATION_REF : emotion.location,
			EMOJI_NAME_REF : emotion.emojiName,
			EMOTION_TITLE_REF : emotion.emotionTitle as Any,
			CRETAED_AT_REF: Date().timeIntervalSince1970,
			ABOUT_REF : emotion.about as Any,
			IS_DATA_IN_CORE_REF:isDataInCore
		]
		Firestore.firestore().collection(USER_TABLE_REF).document(uid).collection(EMOTION_EXPRESS_TABLE_REF).document().setData(data)
		
		if isLastKnownLocLegit {
			Firestore.firestore().collection(USER_TABLE_REF).document(uid).updateData([
				LAST_LEGIT_LOCATION_REF : emotion.location,
				TOTAL_EXPRESSION_REF: FieldValue.increment(Int64(1))
			])
			DataService.userDataModel?.lastKnownLocation = emotion.location
		}
		else {
			Firestore.firestore().collection(USER_TABLE_REF).document(uid).updateData([
				TOTAL_EXPRESSION_REF: FieldValue.increment(Int64(1))
			])
		}
		DataService.userDataModel?.totalEmotionExpress += 1
		
		
	}
	
	class func requestLastKnowLocation(completion:@escaping(_ status:Bool, _ response:GeoPoint?)->()) {
		guard let lastKnownLoc = DataService.userDataModel?.lastKnownLocation else {
			Firestore.firestore().collection(USER_TABLE_REF).document(uid).getDocument { (docSnap, error) in
					guard error != nil else {
						completion(true, (docSnap?.data()?[LAST_LEGIT_LOCATION_REF] as? GeoPoint))
						return
					}
					completion(true, nil)
					
				}
		return
			
		}
		
		completion(true, lastKnownLoc)
		
	
	}
	class func saveAboutText(about:String?) {
		Firestore.firestore().collection(USER_TABLE_REF).document(uid).updateData([
				ABOUT_REF : about as Any
		])
		DataService.userDataModel?.about = about
	}
	class func getAboutInfo(completion:@escaping(_ status:Bool, _ response:String?, _ error:Error?)->()) {
		if let localAbout = DataService.userDataModel?.about {
			completion(true, localAbout, nil)
		}else {
			Firestore.firestore().collection(USER_TABLE_REF).document(uid).getDocument { (docSnap, error) in
				guard let err = error else {
					completion(true, docSnap?.data()?[ABOUT_REF] as? String, nil)
					return
				}
				completion(true, nil, err)
			}
		}
		
	}

	private func publicLocationDocumentReference(completion:@escaping(_ status:Bool, _ docReference:DocumentReference)->()) {
		Locator.sharedInstance.getCityAndStateName { (status, placeMark, error) in
				if status {
					if error == nil {
						if let country = placeMark?.first?.country {
							if let administrativeArea = placeMark?.first?.administrativeArea {
								if let subAdministrativeArea = placeMark?.first?.subAdministrativeArea {
									if let postalCode = placeMark?.first?.postalCode {
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(POSTAL_CODE_REF).document(postalCode).collection(ACTIVE_USERS_REF).document(DataService.uid))
									}
									else {
										//contry, state , city, no zip
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(ACTIVE_USERS_REF).document(DataService.uid))
									}
								}
								else {
									//contry, state , no city
									completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(ACTIVE_USERS_REF).document(DataService.uid))
								}
							}
							else {
								// country no state
								completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ACTIVE_USERS_REF).document(DataService.uid))
							}
						}
						else {
							//no country
							completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry").collection(ACTIVE_USERS_REF).document(DataService.uid))
						}

					}
					else {
						completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry2").collection(ACTIVE_USERS_REF).document(DataService.uid))
					}
				
				}
			}

	}
	
	class func deletePublicLocation() {
		lastpublicDocRef.forEach({$0.delete()})
		lastpublicDocRef.removeAll()

	}
	
	class func listenActiveUsersAroundClientArea(completion:@escaping(_ status:Bool, _ response:QuerySnapshot?, _ error:Error?)->()) {
		DataService.sharedInstance.listenPublicLocationActiveUsersCollection { (status, collectionRef) in
			if status {
				activeUserlistener =  collectionRef.addSnapshotListener { (querySnapShot, error) in
					if let err = error {
						//handle err here
						completion(true, nil, err)
					}
					else {
						//parse active User Data here
						completion(true, querySnapShot, nil)
					}
				}
			}
		}
	}
	
	class func listenCustomZipCodeArea(zipCode:String, completion:@escaping(_ status:Bool, _ response:QuerySnapshot?, _ error:Error?)->()) {
		DataService.sharedInstance.test123(zipCode: zipCode) { (status, collection, error) in
				if status {
					if error != nil {
						completion(true, nil, error)
					}
					else {
						activeUserlistener = collection?.addSnapshotListener({ (querySnapShot, error) in
							if let err = error {
								completion(true, nil, err)
							}
							else {
								completion(true, querySnapShot, nil)
							}
						})
					}
				}
			}
	}
	
	class func listenChatNotificationTable(completion:@escaping(_ status:Bool, _ response:DocumentSnapshot?, _ error:Error?)->()) {
		chatNotificationListener = Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(DataService.uid).addSnapshotListener({ (docSnap, error) in
			completion(true, docSnap, error)
		})
	}
	class func sendLastMessageToHistoryCollectionForSender(messageDocId:String, lastMessage:String, receiverNickName:String,receiverUid:String){
	Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(DataService.uid).collection(CHAT_HISTORY_COLLECTION_REF).document(messageDocId).setData([
			LAST_MESSAGE_REF: lastMessage,
			CROSS_NICK_NAME_REF : receiverNickName,
			IS_MESSAGE_UN_SEEN_REF: false,
			TIME_LAST_MESSAGE_SEND_REF: Date().timeIntervalSince1970,
			CROSS_UID_REF : receiverUid
		])
	}
	class func sendLastMessageToHistoryCollectionReceiver(messageDocId:String, lastMessage:String, receiverUid:String) {
	//this function over-writes the hisyory doc if it exists
	Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(receiverUid).collection(CHAT_HISTORY_COLLECTION_REF).document(messageDocId).setData([
			LAST_MESSAGE_REF: lastMessage,
			CROSS_NICK_NAME_REF : DataService.userDataModel?.nickName as Any,
			IS_MESSAGE_UN_SEEN_REF: false,
			TIME_LAST_MESSAGE_SEND_REF: Date().timeIntervalSince1970,
			CROSS_UID_REF: DataService.uid
		])
		
	}
	
	func test123(zipCode:String, completion:@escaping(_ status:Bool, _ docReference:CollectionReference?, _ error:Error?)->()){
		Locator.sharedInstance.getAdressDetailsFromZip(zipCode: zipCode) { (status, placeMark, error) in
			if status {
				if error != nil {
					completion(true, nil, error)
				}
				else {
					if let country = placeMark?.first?.country {
										if let administrativeArea = placeMark?.first?.administrativeArea {
											if let subAdministrativeArea = placeMark?.first?.subAdministrativeArea {
												if let postalCode = placeMark?.first?.postalCode {
													completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(POSTAL_CODE_REF).document(postalCode).collection(ACTIVE_USERS_REF),
															   nil)
												}
												else {
													//contry, state , city, no zip
													completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(ACTIVE_USERS_REF), nil)
												}
											}
											else {
												//contry, state , no city
												completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(ACTIVE_USERS_REF) , nil)
											}
										}
										else {
											// country no state
											completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ACTIVE_USERS_REF), nil)
										}
									}
									else {
										//no country
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry").collection(ACTIVE_USERS_REF), nil)
									}
					//change info lbl 2 here
					let count = DataService.getCountryForCorona(placeMark: placeMark)
					let state = DataService.getStateNameForCorona(placeMark: placeMark)
					CoronaInfoView.sharedInstace?.changeInfoLbl2(country: count, state: state ?? count)

					}
				}
			}
		}
	
	class func getCountryForCorona(placeMark:[CLPlacemark]?)->String {
		if let count = placeMark?.first?.country {
			if count == "United States" {
				return "US"
			}
			else {
				return count
			}
		}
		else {
			return "US"
		}
	}
	class func getStateNameForCorona(placeMark:[CLPlacemark]?)->String? {
		if let state  = placeMark?.first?.administrativeArea {
			if DataService.sharedInstance.statecAbbreviations[state] != nil {
				return DataService.sharedInstance.statecAbbreviations[state]
			}
			else {
				return state
			}
		}
		else {
			return nil
		}
	}
		
	
	class func callCoronaData(country:String, state:String?, completion:@escaping(_ status:Bool, _ response:[String:Any]?, _ error:Error?)->()) {
		//first get country data
		Firestore.firestore().collection(CORONA_REF).whereField(CORONA_COUNTRY_REF, isEqualTo: country).getDocuments { (querySnap, error) in
					if error == nil {
						CoronaDataModel.init(querSnapShot: querySnap, country: country, state: state ?? country) { (status) in
							if status {
								completion(true, CoronaDataModel.sharedInstance?.data, nil)
							}
						}
					}
					else {
						completion(true, nil, error)
			}
				}
		
	}
	
	private func listenPublicLocationActiveUsersCollection(completion:@escaping(_ status:Bool, _ docReference:CollectionReference)->()) {
		Locator.sharedInstance.getCityAndStateName { (status, placeMark, error) in
				if status {
					if error == nil {
						if let country = placeMark?.first?.country {
							if let administrativeArea = placeMark?.first?.administrativeArea {
								if let subAdministrativeArea = placeMark?.first?.subAdministrativeArea {
									if let postalCode = placeMark?.first?.postalCode {
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(POSTAL_CODE_REF).document(postalCode).collection(ACTIVE_USERS_REF))
									}
									else {
										//contry, state , city, no zip
										completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(SUB_ADMINISTRATIVE_AREA_REF).document(subAdministrativeArea).collection(ACTIVE_USERS_REF))
									}
								}
								else {
									//contry, state , no city
									completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ADMINISTRATIVE_AREA_REF).document(administrativeArea).collection(ACTIVE_USERS_REF))
								}
							}
							else {
								// country no state
								completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document(country).collection(ACTIVE_USERS_REF))
							}
						}
						else {
							//no country
							completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry").collection(ACTIVE_USERS_REF))
						}

					}
					else {
						completion(true, Firestore.firestore().collection(PUBLIC_LOCATION_REF).document("noCountry2").collection(ACTIVE_USERS_REF))
					}

				}
			}

	}
	
	class func sendDirectMessage(receiverUid:String, message:MessageModel, messageDocId:String) {
	Firestore.firestore().collection(CHAT_TABLE_REF).document(messageDocId).collection(MESSAGES_REF).document().setData(MessageModel.parseDataAsJson(data: message))
	}
	class func flagUserAsOfflineOnSpecificMessageId(messageId:String) {
		Firestore.firestore().collection(CHAT_TABLE_REF).document(messageId).updateData([
			DataService.uid: false
		])
	}
	class func flagUserAsOnlineOnSpecificMessageId(messageDocId:String) {
		Firestore.firestore().collection(CHAT_TABLE_REF).document(messageDocId).setData([
			DataService.uid : true
		], merge: true)
	}
	class func direckMessageDataListen(messageDocId:String, receiverUid:String, completion:@escaping(_ status:Bool, _ response:QuerySnapshot?, _ lastDocumentRef:QueryDocumentSnapshot?, _ error:Error?)->()) {
		messageDatalistener = Firestore.firestore().collection(CHAT_TABLE_REF).document(messageDocId).collection(MESSAGES_REF)
			.order(by: CRETAED_AT_REF, descending: true)
			.limit(to: 20)
			.addSnapshotListener { (docSnaps, error) in
				guard let err = error else {
				completion(true, docSnaps, docSnaps?.documents.last, nil)
				return
			 }
			completion(true, nil, nil, err)
		}
		
	}
	class func direkMessageUserStatusListener(messageDocId:String, receiverUid:String, completion:@escaping(_ status:Bool, _ response: DocumentSnapshot?, _ error:Error?)->()){
		userOnlineStatusListenerForDM = Firestore.firestore().collection(CHAT_TABLE_REF).document(messageDocId).addSnapshotListener({ (docSnap, error) in
			guard let err = error else {
				completion(true, docSnap, nil)
				return
			}
			completion(true, nil, err)
		})
	}
	

	
	class func requestChatHistoryDocs(lastDocument:QueryDocumentSnapshot?,completion:@escaping(_ status:Bool, _ response:[chatHistoryMessageStruct]?, _ lastDocRef:QueryDocumentSnapshot?, _ error:Error?)->()){
	let ref = Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(DataService.uid).collection(CHAT_HISTORY_COLLECTION_REF)
		if lastDocument == nil {
			ref.whereField(IS_MESSAGE_UN_SEEN_REF, isEqualTo: false)
					.order(by: TIME_LAST_MESSAGE_SEND_REF, descending: true)
					.limit(to: 10)
					.getDocuments { (querySnaps, error) in
						if error == nil {
							completion(true, chatHistoryMessageStruct.parseDataForHistoryCollection(docSnaps: querySnaps), querySnaps?.documents.last, nil)
						}
						else {
							
							completion(true, nil, nil, error)
						}
				}
		}
		else {
			//paginate data
			ref.whereField(IS_MESSAGE_UN_SEEN_REF, isEqualTo: false)
				.order(by: TIME_LAST_MESSAGE_SEND_REF, descending: true)
				.start(afterDocument: lastDocument!)
				.limit(to: 10)
				.getDocuments { (querySnaps, error) in
					if error == nil {
						completion(true, chatHistoryMessageStruct.parseDataForHistoryCollection(docSnaps: querySnaps), querySnaps?.documents.last, nil)
					}
					else {
			
						completion(true, nil, nil, error)
					}
			}
		}
	
	}
	class func increaseUnseenMessages(receiverUid:String, messageDocId:String, lastMessage:String) {
		Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(receiverUid).updateData([
			TOTAL_UNSEEN_MESSAGES_REF: FieldValue.increment(Int64(1)),
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(messageDocId).\(SUB_TOTAL_UNSEEN_MESSAGE_REF)" : FieldValue.increment(Int64(1)),
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(messageDocId).\(LAST_MESSAGE_REF)" : lastMessage,
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(messageDocId).\(TIME_LAST_MESSAGE_SEND_REF)" : Date().timeIntervalSince1970,
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(messageDocId).\(CROSS_NICK_NAME_REF)" : DataService.userDataModel?.nickName ?? "Sss",
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(messageDocId).\(CROSS_UID_REF)" : DataService.uid
		])
		
		//update chat history doc here unseen as true
		Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(receiverUid).collection(CHAT_HISTORY_COLLECTION_REF).document(messageDocId).updateData([
			IS_MESSAGE_UN_SEEN_REF : true
		])
		
	}
	class func decreaseUnseenMessages(message:chatHistoryMessageStruct) {
		Firestore.firestore().collection(CHAT_NOTIFICATION_TABLE_REF).document(DataService.uid).updateData([
			TOTAL_UNSEEN_MESSAGES_REF: FieldValue.increment(Int64(-message.subTotalUnSeen)),
			"\(UNSEEN_MESSAGE_DOC_IDS_REF).\(message.messageDocId)" : FieldValue.delete()
		])
		
		DataService.sendLastMessageToHistoryCollectionForSender(messageDocId: message.messageDocId, lastMessage: message.lastMessage, receiverNickName: message.crossNickName, receiverUid: message.crossUid)
		
	}
	class func queryOldMessageData(messageDocId:String, receiverUid:String, lastDoc:QueryDocumentSnapshot, completion:@escaping(_ status:Bool, _ response: QuerySnapshot?, _ error:Error?)->()) {
	
		Firestore.firestore().collection(CHAT_TABLE_REF).document(messageDocId).collection(MESSAGES_REF)
		.order(by: CRETAED_AT_REF, descending: true)
		.start(afterDocument: lastDoc)
		.limit(to: 20)
			.getDocuments { (querySnapShot, error) in
				guard let err = error else {
					completion(true, querySnapShot, nil)
					return
				}
				completion(true, nil, err)
		}
	}
	
	class func generateMessageDocId (receiverUid:String, index:Int)->String? {
		let character1 = DataService.uid[DataService.uid.index(DataService.uid.startIndex, offsetBy: index)].lowercased()
		let character2 = receiverUid[receiverUid.index(receiverUid.startIndex, offsetBy: index)].lowercased()

		if character1 ==  character2 {
			return DataService.generateMessageDocId(receiverUid: receiverUid, index: index + 1)
		}
		else if character1 > character2 {
			return DataService.uid + receiverUid
		}
		else if character1 < character2 {
			return receiverUid + DataService.uid
		}
		else {
			return nil
		}

	}
	//pushNotification
	class func getDeviceTOkens(uid:String, completion:@escaping(_ status:Bool, _ result:String)->()) {
		   let ref = Firestore.firestore().collection(TOKENS_TABLE_REF).document(uid)
		   ref.getDocument { (documentSnap, error) in
			   if error == nil {
				   guard let data = documentSnap?.data() else {
					//first time token doc creation here
					DataService.sendTokens()
					return}
				   let token = data[FCT_REF] as? String ?? ""
				   completion(true, token)
			   }
		   }
		   
	   }
	
	class func sendTokens() {
		guard let delegate = UIApplication.shared.delegate as? AppDelegate else {return}
		let ref = Firestore.firestore().collection(TOKENS_TABLE_REF).document(DataService.uid)
		   ref.setData([
			   DEVICE_TOKEN_REF: delegate.sharedTokenData[DEVICE_TOKEN_REF] as Any,
			   FCT_REF: delegate.sharedTokenData[FCT_REF] as Any
			   ])
	   }
	
	let statecAbbreviations = [
		"AL":"Alabama",
		"AK":"Alaska",
		"AZ":"Arizona",
		"AR":"Arkansas",
		"CA":"California",
		"CO":"Colorado",
		"CT":"Connecticut",
		"DE":"Delaware",
		"FL":"Florida",
		"GA":"Georgia",
		"HI":"Hawaii",
		"ID":"Idaho",
		"IL":"Illinois",
		"IN":"Indiana",
		"IA":"Iowa",
		"KS":"Kansas",
		"KY":"Kentucky",
		"LA":"Louisiana",
		"ME":"Maine",
		"MD":"Maryland",
		"MA":"Massachusetts",
		"MI":"Michigan",
		"MN":"Minnesota",
		"MS":"Mississippi",
		"MO":"Missouri",
		"MT":"Montana",
		"NE":"Nebraska",
		"NV":"Nevada",
		"NH":"New Hampshire",
		"NJ":"New Jersey",
		"NM":"New Mexico",
		"NY":"New York",
		"NC":"North Carolina",
		"ND":"North Dakota",
		"OH":"Ohio",
		"OK":"Oklahoma",
		"OR":"Oregon",
		"PA":"Pennsylvania",
		"RI":"Rhode Island",
		"SC":"South Carolina",
		"SD":"South Dakota",
		"TN":"Tennessee",
		"TX":"Texas",
		"UT":"Utah",
		"VT":"Vermont",
		"VA":"Virginia",
		"WA":"Washington",
		"WV":"West Virginia",
		"WI":"Wisconsin",
		"WY":"Wyoming",
		"DC":"District of Columbia",
		"PR":"Puerto Rico",
		"VI":"Virgin Islands, U.S."
	]
}
