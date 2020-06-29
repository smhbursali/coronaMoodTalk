//
//  FirstVC.swift
//  thisTime
//
//  Created by semih bursali on 10/22/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore



class FirstVC: UIViewController {
	private var mapView:MKMapView?
	private var activeUsers = [String:ActiveUsers]()
	  
	
	private lazy var emojiViewAddBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: width - 90, y: height - 90, width: 80, height: 80)
		btn.addTarget(self, action: #selector(self.emojiViewAddBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "add"), for: .normal)
		return btn
	}()
	private lazy var settingsBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: 10, y: height - 60, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.settingsBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
		return btn
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		Locator.sharedInstance.locationManager.delegate = self
		firstScreenAlingments()
		callActiveUsersListener()
		callChatNotificationTableListener()
		//fakesuer
//		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//			FakeUser().generateFakeUser(howMany: 3, emojiName: "happy", title: "I am getting creative")
//			FakeUser().generateFakeUser(howMany: 3, emojiName: "mmm", title: "Hey! I am  bored!")
//			FakeUser().generateFakeUser(howMany: 3, emojiName: "cry", title: "This gets real!")
//			FakeUser().generateFakeUser(howMany: 3, emojiName: "sss", title: "Any body there!")
//			FakeUser().generateFakeUser(howMany: 3, emojiName: "zzz", title: "politics!!!!!!!")
//			
//	}
	//	fakeuser end
		//DataService.logOut()
    }
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		NotificationCenter.default.addObserver(self, selector: #selector(self.pauseApp) , name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.startApp), name: UIApplication.didBecomeActiveNotification, object: nil)
		
	}
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
	}

	func firstScreenAlingments() {
		if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
			return
			}
		//addMapViewWithCurrentLocation()
		
	}
	
	func addMapViewWithCurrentLocation() {
		mapView = Locator.sharedInstance.setLocationWithCurrentLocation()
		mapView?.delegate = self
		guard let map = self.mapView else {return}
		map.addSubview(emojiViewAddBtn)
		map.addSubview(settingsBtn)
		map.addSubview(NotificationView.sharedInstance.prepareForDisplay())
		addCoronaInfo()
		self.view.addSubview(map)
		registerMapAnnotationViews(map: map)
	}
	
	func addCoronaInfo() {
		guard let map = self.mapView else {return}
		if let sharedInfo = CoronaInfoView.sharedInstace {
			sharedInfo.deinitTheClass()
			CoronaInfoView.sharedInstace = CoronaInfoView(delegate: self)
			map.addSubview(CoronaInfoView.sharedInstace!.prepareForDisplay())
		}
		else {
			CoronaInfoView.sharedInstace = CoronaInfoView(delegate: self)
			map.addSubview(CoronaInfoView.sharedInstace!.prepareForDisplay())
		}
	}
	func addMapViewWithRandomLocation() {
		mapView = Locator.sharedInstance.setLocationWithRandomLocation()
		mapView?.delegate = self
		guard let map = self.mapView else {return}
		map.addSubview(emojiViewAddBtn)
		map.addSubview(settingsBtn)
		map.addSubview(NotificationView.sharedInstance.prepareForDisplay())
		addCoronaInfo()
		self.view.addSubview(map)
		registerMapAnnotationViews(map: map)
	}
	private func registerMapAnnotationViews(map:MKMapView) {
		map.register(MMMAnnotationView.self, forAnnotationViewWithReuseIdentifier: MMMAnnotationView.ReuserId)
		map.register(HappyAnnotationView.self, forAnnotationViewWithReuseIdentifier: HappyAnnotationView.ReuserId)
		map.register(AngryAnnotationView.self, forAnnotationViewWithReuseIdentifier: AngryAnnotationView.ReuserId)
		map.register(AaaAnnotationView.self, forAnnotationViewWithReuseIdentifier: AaaAnnotationView.ReuserId)
		map.register(CryAnnotationView.self, forAnnotationViewWithReuseIdentifier: CryAnnotationView.ReuserId)
		map.register(SssAnnotationView.self, forAnnotationViewWithReuseIdentifier: SssAnnotationView.ReuserId)
		map.register(XxAnnotationView.self, forAnnotationViewWithReuseIdentifier: XxAnnotationView.ReuserId)
		map.register(ZzzAnnotationView.self, forAnnotationViewWithReuseIdentifier: ZzzAnnotationView.ReuserId)
		map.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

	   }
	
	@IBAction func emojiViewAddBtnTapped(sender:UIButton) {
		self.view.addSubview(EmojiPopUp.sharedInstance.emojiView)
	}
	@IBAction func settingsBtnTapped(sender:UIButton) {
		settingsActionSheet()
	}
	func settingsActionSheet() {
		let alert = UIAlertController(title: "Settings", message: "", preferredStyle: .actionSheet)
		alert.addAction(UIAlertAction(title: "Change Location Preference", style: .default, handler: { (action) in
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
		}))
		alert.addAction(UIAlertAction(title: "Add/Edit Profile Text", style: .default, handler: { (action) in
			self.view.addSubview(AboutPopUpView.sharedInstance.aboutView)
			AboutPopUpView.sharedInstance.aboutTxt.becomeFirstResponder()
			
		}))
		alert.addAction(UIAlertAction(title: "Personal History", style: .default, handler: { (action) in
			//request here core data if it has been requested yet
			if CoreDataManager.sharedInstance.localEmotions == nil {
				//request core data here
				CoreDataManager.sharedInstance.retrieveLocalEmotions { (status, error) in
					if status {
						if let err = error {
							//core data fetch err handle here
						}
						else {
							//successfully fetched core data here
							self.displayPersonalHistoryMap()
						}
					}
				}
			}
			else {
				// core data already fetched before
				self.displayPersonalHistoryMap()
			}
		}))
		alert.addAction(UIAlertAction(title: "Go to", style: .default, handler: { (action) in
			self.callZipCodeEntryScreen()
		}))
		alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in

		}))

		self.present(alert, animated: true, completion: nil)
	}
	@IBAction func pauseApp() {
		DataService.deletePublicLocation()
		activeUserListenerCleaner()
		chatNotifListenerCleaner()
		if DirekMessageView.sharedInstance.view.alpha == 1 {
			//if direct message screen on
			//flagg user as ofline here
			DirekMessageView.sharedInstance.directMessageViewClose()
		}
		
		
	}
	
	
	@IBAction func startApp() {
		callActiveUsersListener()
		callChatNotificationTableListener()
		addCoronaInfo()
	}
	private func activeUserListenerCleaner() {
		if activeUserlistener != nil {
			activeUserlistener?.remove()
			activeUserlistener = nil

		}
	}
	
	func locationPrivacyStatusChangedForDataListener() {
		activeUserListenerCleaner()
		callActiveUsersListener()
	}
	
	func displayPersonalHistoryMap() {
		let map = EmotionHistoryMap.sharedInstance.displayHistoryMap()
		self.view.addSubview(map)
	}
	func callZipCodeEntryScreen() {
		GoToZipCodeView.sharedInstance = GoToZipCodeView(delegate: self)
		self.view.addSubview(GoToZipCodeView.sharedInstance?.preapreForDisplay() ?? UIView())
	}
	
	private func callActiveUsersListener() {
		//remove existing annotation
		Locator.sharedInstance.mapView.removeAnnotations(Locator.sharedInstance.mapView.annotations)
		
		DataService.listenActiveUsersAroundClientArea { (status, querySnapshots, error) in
		if status {
			guard let err = error else {
				querySnapshots?.documentChanges.forEach({ (change) in
					if change.type == .added {
						//new emotion
						guard let newActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document) else {
							return}
						self.activeUsers[newActiveUser.activeUserUid] = newActiveUser
						if newActiveUser.activeUserUid == DataService.uid {
							Locator.sharedInstance.setYourSelfasActiveUser(activeUser: newActiveUser)
						} else {
						Locator.sharedInstance.setActiveUserAnnotationOnMap(activeUser: newActiveUser)
						}
						
					}
					else if change.type == .modified {
						//

						guard let modifiedActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document),
							 let spotBeforeData = self.activeUsers[modifiedActiveUser.activeUserUid]
							else {

								return}
						Locator.sharedInstance.removeSingleAnnodation(activeUser: spotBeforeData)
						self.activeUsers[modifiedActiveUser.activeUserUid] = modifiedActiveUser
						if modifiedActiveUser.activeUserUid == DataService.uid {

							Locator.sharedInstance.setYourSelfasActiveUser(activeUser: modifiedActiveUser)
						}
						else {
							Locator.sharedInstance.setActiveUserAnnotationOnMap(activeUser: modifiedActiveUser)
						}
				
					}
					else if change.type == .removed {
			
						guard let deleteActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document),
							let spotUser = self.activeUsers[deleteActiveUser.activeUserUid] else {
						
								return}
								Locator.sharedInstance.removeSingleAnnodation(activeUser: spotUser)
								self.activeUsers.removeValue(forKey: spotUser.activeUserUid)
					}
				})
			return
			}
				print("active user listener err \(err.localizedDescription)")
			}
		}
	}
	private func callActiveUsersFromCustomZipListener(zipCode:String) {
		//remove existing annotation
		activeUserListenerCleaner()
		Locator.sharedInstance.mapView.removeAnnotations(Locator.sharedInstance.mapView.annotations)
			
		DataService.listenCustomZipCodeArea(zipCode: zipCode){ (status, querySnapshots, error) in
			if status {
				guard let err = error else {
					querySnapshots?.documentChanges.forEach({ (change) in
						if change.type == .added {
							//new emotion
							guard let newActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document) else {
								return}
							self.activeUsers[newActiveUser.activeUserUid] = newActiveUser
							if newActiveUser.activeUserUid == DataService.uid {
								Locator.sharedInstance.setYourSelfasActiveUser(activeUser: newActiveUser)
							} else {
							Locator.sharedInstance.setActiveUserAnnotationOnMap(activeUser: newActiveUser)
							}
							
						}
						else if change.type == .modified {
							//

							guard let modifiedActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document),
								 let spotBeforeData = self.activeUsers[modifiedActiveUser.activeUserUid]
								else {

									return}
							Locator.sharedInstance.removeSingleAnnodation(activeUser: spotBeforeData)
							self.activeUsers[modifiedActiveUser.activeUserUid] = modifiedActiveUser
							if modifiedActiveUser.activeUserUid == DataService.uid {

								Locator.sharedInstance.setYourSelfasActiveUser(activeUser: modifiedActiveUser)
							}
							else {
								Locator.sharedInstance.setActiveUserAnnotationOnMap(activeUser: modifiedActiveUser)
							}
					
						}
						else if change.type == .removed {
				
							guard let deleteActiveUser = ActiveUsers.parseActiveUserDocumentSnapsots(documentSnap: change.document),
								let spotUser = self.activeUsers[deleteActiveUser.activeUserUid] else {
							
									return}
									Locator.sharedInstance.removeSingleAnnodation(activeUser: spotUser)
									self.activeUsers.removeValue(forKey: spotUser.activeUserUid)
						}
						
					})
					
					Locator.sharedInstance.zoomCustomLocation(zipCode:zipCode)
				return
				}
					print("active user listener err \(err.localizedDescription)")
				}
			}
	}
	
	private func callChatNotificationTableListener() {
		DataService.listenChatNotificationTable { (status, docSnap, error) in
			if status {
				chatNotificationInstance = chatNotification.parseSnapDoc(docSnap: docSnap)
				let total = chatNotificationInstance?.totalUnSeenMessages ?? 0
				
				if total > 0 {
					NotificationView.sharedInstance.notifLbl.backgroundColor = #colorLiteral(red: 1, green: 0.1878562868, blue: 0.2392513454, alpha: 1)
					NotificationView.sharedInstance.notifLbl.text = "\(total)"
				}
				else {
					NotificationView.sharedInstance.notifLbl.backgroundColor = .clear
					NotificationView.sharedInstance.notifLbl.text = nil
				}
				NotificationView.sharedInstance.requestChatHistoryData()
				
			}
		}
	}
	private func chatNotifListenerCleaner() {
		if chatNotificationListener != nil {
			chatNotificationListener?.remove()
			chatNotificationListener = nil
		}
	}
}

extension FirstVC:MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
//		guard annotation.isKind(of: MKAnnotation.self) else {

//			return nil}
		
		guard let annotation = annotation as? EmojiAnnotation else {
			return nil}
		
		
		switch annotation.type {
		case .happy:
			return HappyAnnotationView(annotation: annotation, reuseIdentifier: HappyAnnotationView.ReuserId)
		case .angery:
			return AngryAnnotationView(annotation: annotation, reuseIdentifier: AngryAnnotationView.ReuserId)
		case .mmm:
			return MMMAnnotationView(annotation: annotation, reuseIdentifier: MMMAnnotationView.ReuserId)
		case .aaa:
			return AaaAnnotationView(annotation: annotation, reuseIdentifier: AaaAnnotationView.ReuserId)
		case .cry:
			return CryAnnotationView(annotation: annotation, reuseIdentifier: CryAnnotationView.ReuserId)
		case .xx:
			return XxAnnotationView(annotation: annotation, reuseIdentifier: XxAnnotationView.ReuserId)
		case .sss:
			return SssAnnotationView(annotation: annotation, reuseIdentifier: SssAnnotationView.ReuserId)
		case .zzz:
			return ZzzAnnotationView(annotation: annotation, reuseIdentifier: ZzzAnnotationView.ReuserId)
		default :
			return nil
		}
	}
	
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		if let anno =  view.annotation as? EmojiAnnotation {
			anno.subtitle = Date.timeAgo(timeStamp: anno.activeUser.createdAt)
				self.view.addSubview(AnnotationClickView.sharedInstance.prepareForDisplay(view: view, activeUser: anno.activeUser))
		}
	}
	
	
	func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
		
		if self.view.subviews.contains(AnnotationClickView.sharedInstance.stackView) {
				AnnotationClickView.sharedInstance.stackView.removeFromSuperview()
		     	Locator.sharedInstance.mapView.selectedAnnotations.forEach({mapView.deselectAnnotation($0, animated: true)})
		}
	}
}

extension FirstVC: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		switch status {
		case .authorizedAlways:
			addMapViewWithCurrentLocation()
		case .authorizedWhenInUse:
			addMapViewWithCurrentLocation()
		case .denied:
				self.locationpermissionAlertview()
			
		case .notDetermined:
			DispatchQueue.main.async {
				self.addCoronaInfo()
			Locator.sharedInstance.locationManager.requestWhenInUseAuthorization()
			}
		
		case .restricted:
			print("restricted")
		default:
		print("default")
		}
	}
	
	func locationpermissionAlertview() {
		let alert = UIAlertController(title: "Location Permission", message: "Since you do not allow to share your location,\nyou will be directed on random location!\nIf you change your mind,\nPlease click Settings button and allow location services!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) in
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
		}))
		alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
			self.addMapViewWithRandomLocation()
			self.locationPrivacyStatusChangedForDataListener()
		}))
			self.present(alert, animated: true, completion: nil)
	}
}


extension FirstVC:GoToZipCodeViewDelegate {
	func gotoZipTapped(zipCode: String) {
		callActiveUsersFromCustomZipListener(zipCode: zipCode)
	}
	
}

extension FirstVC: CoronaInfoViewDelegate {
	func animateComingFromBacground() {
	
	}
	
	
}
