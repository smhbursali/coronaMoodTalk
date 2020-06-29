//
//  EmojiPopUpView.swift
//  thisTime
//
//  Created by semih bursali on 10/24/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit

class EmojiPopUp: NSObject {
	
	enum DataSaveCases {
		case onlyPublic, onlySelf, publicAndSelf
	}
	
	private var selectedEmojiName:String?
	private lazy var emojiScreenFrame = CGRect(x: 20, y: height / 2, width: width - 40, height: (shapeSize.width5 * 3) + 60)
	private var decidedCase:DataSaveCases = .publicAndSelf
	
	let emojiView: UIView = {
		let view = UIView()
		view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7187767551)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		return view
	}()
	static let sharedInstance = EmojiPopUp(frame: CGRect(x: 20, y: height / 2, width: width - 40, height: (shapeSize.width5 * 3) + 60))
	
	
	init(frame:CGRect) {
		emojiView.frame = frame
		super.init()
		emojiScreenAlingments()
		
	}
	private func emojiScreenAlingments() {
		emojiView.frame = self.emojiScreenFrame
		emojiView.addSubview(self.happyBtn)
		emojiView.addSubview(self.cryBtn)
		emojiView.addSubview(self.xxBtn)
		emojiView.addSubview(self.mmmBtn)
		emojiView.addSubview(self.zzzBtn)
		emojiView.addSubview(self.sssBtn)
		emojiView.addSubview(self.angeryBtn)
		emojiView.addSubview(self.aaaBtn)
		emojiView.addSubview(backBtn)
	}
	
	
	private lazy var backBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: width - 80, y: 20, width: 30, height: 30)
		btn.addTarget(self, action: #selector(self.backBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
		
		return btn
	}()
	
	
	private lazy var happyBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: shapeSize.width2 - shapeSize.width10 - 20, y: 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "happy"), for: .normal)
		btn.layer.name = "happy"
		return btn
	}()
	private lazy var cryBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: shapeSize.width2 - shapeSize.width10 - 20, y: 0, width: shapeSize.width5, height: shapeSize.width5)
		btn.center.y = ((shapeSize.width5 * 3) + 60) / 2
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "cry"), for: .normal)
		btn.layer.name = "cry"
		return btn
	}()
	private lazy var xxBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.happyBtn.frame.minX - shapeSize.width5 - 15, y: 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "xx"), for: .normal)
		btn.layer.name = "xx"
		return btn
	}()
	private lazy var mmmBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: shapeSize.width2 - shapeSize.width10 - 20, y: self.cryBtn.frame.maxY + 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "mmm"), for: .normal)
		btn.layer.name = "mmm"
		return btn
	}()
	private lazy var zzzBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.xxBtn.frame.minX, y: self.xxBtn.frame.maxY + 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "zzz"), for: .normal)
		btn.layer.name = "zzz"
		return btn
	}()
	private lazy var sssBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.xxBtn.frame.minX, y: self.zzzBtn.frame.maxY + 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "sss"), for: .normal)
		btn.layer.name = "sss"
		return btn
	}()
	private lazy var angeryBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.happyBtn.frame.maxX + 15, y: 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "angery"), for: .normal)
		btn.layer.name = "angery"
		return btn
	}()
	private lazy var aaaBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.angeryBtn.frame.minX, y: self.angeryBtn.frame.maxY + 15, width: shapeSize.width5, height: shapeSize.width5)
		btn.addTarget(self, action: #selector(self.emojiBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "aaa"), for: .normal)
		btn.layer.name = "aaa"
		return btn
	}()
	

	
	private lazy var modeText: UITextField = {
		let txt = UITextField()
		txt.frame = CGRect(x: 75, y: 15, width: width - 135, height: 35)
		txt.placeholder = "how are you feeling..."
		txt.delegate = self
		txt.borderStyle = .roundedRect
		txt.textColor = .white
		txt.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		txt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
		txt.addSubview(self.characterCounter)
		return txt
	}()
	private lazy var characterCounter: UILabel = {
		   let lbl = UILabel()
		lbl.frame = CGRect(x: width - 137 - shapeSize.width7, y: 24, width: shapeSize.width7, height: 10)
		   lbl.textColor = .white
		   lbl.textAlignment = .center
		   lbl.text = "21 / 0"
		   lbl.font = UIFont.italicSystemFont(ofSize: 8)
		   lbl.adjustsFontSizeToFitWidth = true
		   return lbl
	   }()
	private lazy var privateBtnLbl: UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: 20, y: 55, width: 50, height: 14)
		lbl.textColor = .white
		lbl.textAlignment = .center
		lbl.text = "self"
		lbl.font = DIRECT_MESSAGE_TEXT_FONT
		lbl.adjustsFontSizeToFitWidth = true
		return lbl
	}()
	private lazy var publicBtnLbl: UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: self.emojiView.center.x - 45, y: 55, width: 50, height: 14)
		lbl.textColor = .white
		lbl.textAlignment = .center
		lbl.text = "public"
		lbl.font = DIRECT_MESSAGE_TEXT_FONT
		lbl.adjustsFontSizeToFitWidth = true
		return lbl
	}()
	private lazy var textSubmitBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: width - 105, y: 71, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.textSubmitBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "submit"), for: .normal)
		return btn
	}()
	private lazy var publicBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: self.emojiView.center.x - 45, y: 71, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.sharePreference), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
		btn.isSelected = true
		btn.tag = 22
		return btn
	}()
	private lazy var privateBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: 20, y:71, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.sharePreference), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
		btn.isSelected = true
		btn.tag = 11
		return btn
	}()
	private lazy var skewLocationBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: 27.5, y:15, width: 35, height: 35)
		btn.addTarget(self, action: #selector(self.skewBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "radioUnchecked"), for: .normal)
		btn.isSelected = false
		return btn
	}()
	private lazy var skewLbl: UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: 20, y: 1, width: 50, height: 14)
		lbl.textColor = .white
		lbl.textAlignment = .center
		lbl.text = "skew location"
		lbl.font = DIRECT_MESSAGE_TEXT_FONT
		lbl.adjustsFontSizeToFitWidth = true
		return lbl
	}()

	@IBAction func emojiBtnTapped(sender:UIButton) {
		selectedEmojiName = sender.layer.name
		UIView.animate(withDuration: 1.5) {
			self.emojiView.frame = CGRect(x: 20, y: height / 2 - 55, width: width - 40, height: 125)
			self.emojiView.subviews.forEach({$0.removeFromSuperview()})
			self.emojiView.addSubview(self.modeText)
			self.emojiView.addSubview(self.textSubmitBtn)
			self.emojiView.addSubview(self.publicBtn)
			self.emojiView.addSubview(self.privateBtn)
			self.emojiView.addSubview(self.privateBtnLbl)
			self.emojiView.addSubview(self.publicBtnLbl)
			self.emojiView.addSubview(self.skewLbl)
			self.emojiView.addSubview(self.skewLocationBtn)
			self.modeText.becomeFirstResponder()
		}
	
		
	}
	@IBAction func sharePreference(sender:UIButton) {
		if sender.tag == 11 {
			//private tapped
			if self.publicBtn.isSelected && sender.isSelected {
				sender.isSelected = false
				sender.setImage(#imageLiteral(resourceName: "radioUnchecked"), for: .normal)
				self.decidedCase = .onlyPublic
			}
			else if self.publicBtn.isSelected && !sender.isSelected {
				sender.isSelected = true
				sender.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
				self.decidedCase = .publicAndSelf
			}
		}
		else if sender.tag == 22 {
			//public tapped
			if self.privateBtn.isSelected && sender.isSelected {
				sender.isSelected = false
				sender.setImage(#imageLiteral(resourceName: "radioUnchecked"), for: .normal)
				self.decidedCase = .onlySelf
			}
			else if self.privateBtn.isSelected && !sender.isSelected {
				sender.isSelected = true
				sender.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
				self.decidedCase = .publicAndSelf
			}
		}
		
	}
	
	@IBAction func skewBtnTapped(sender:UIButton) {
		if sender.isSelected {
			sender.isSelected = false
			sender.setImage(#imageLiteral(resourceName: "radioUnchecked"), for: .normal)
		}
		else {
			sender.isSelected = true
			sender.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
		}
	}

	
	private func pubLicPrivateSkewBtnReset(){
		self.publicBtn.isSelected = true
		self.publicBtn.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
		self.privateBtn.isSelected = true
		self.privateBtn.setImage(#imageLiteral(resourceName: "radioChecked"), for: .normal)
		self.skewLocationBtn.isSelected = false
		self.skewLocationBtn.setImage(#imageLiteral(resourceName: "radioUnchecked"), for: .normal)
		self.decidedCase = .publicAndSelf
	}
	
	@IBAction func textSubmitBtnTapped(sender:UIButton) {
		guard let emojiName = self.selectedEmojiName else {return}
		
		var saveEmotionDataPack:SaveEmotionModel
		if self.skewLocationBtn.isSelected {
			//skew curret location
			let currentLocation = Locator.skewCurrentLocation(location: Locator.sharedInstance.getLocationAsCLlocation())
			let geoPoint = DataService.firLocationConverter(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
	
			 saveEmotionDataPack = SaveEmotionModel(location: geoPoint, emojiName: emojiName, emotionTitle: self.modeText.text, isLocationLegit: Locator.sharedInstance.isLocationLegit, about: DataService.userDataModel?.about)
		}
		else {
			let currentLocation = Locator.sharedInstance.getLocationAsCLlocation()
			let geoPoint = DataService.firLocationConverter(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
			
			 saveEmotionDataPack = SaveEmotionModel(location: geoPoint, emojiName: emojiName, emotionTitle: self.modeText.text, isLocationLegit: Locator.sharedInstance.isLocationLegit, about: DataService.userDataModel?.about)
		}


		
		
		UIView.animate(withDuration: 1.3) {
			self.emojiView.subviews.forEach({$0.removeFromSuperview()})
			self.emojiView.removeFromSuperview()
		}
		
		switch decidedCase {
		case .onlyPublic:
			//public
			//and server personal
			DataService.savePublicLocation(emotion:saveEmotionDataPack, isLocationSkewed: self.skewLocationBtn.isSelected) { (status, error, docRef) in
					if status {
						if !lastpublicDocRef.contains(docRef) {
							lastpublicDocRef.append(docRef)
						}
					}
				}
			DataService.saveEmotionForUser(emotion: saveEmotionDataPack, isLastKnownLocLegit: saveEmotionDataPack.isLocationLegit, isDataInCore: false)
			
		case .onlySelf:
			//server personal
			//core data
			DataService.saveEmotionForUser(emotion: saveEmotionDataPack, isLastKnownLocLegit: saveEmotionDataPack.isLocationLegit, isDataInCore: true)
			CoreDataManager.sharedInstance.saveEmotionCore(newEmotion:saveEmotionDataPack)
		case .publicAndSelf:
			//public
			//server personal
			//core
			DataService.savePublicLocation(emotion:saveEmotionDataPack, isLocationSkewed: self.skewLocationBtn.isSelected) { (status, error, docRef) in
					if status {
						if !lastpublicDocRef.contains(docRef) {
							lastpublicDocRef.append(docRef)
						}
					}
			}
			DataService.saveEmotionForUser(emotion: saveEmotionDataPack, isLastKnownLocLegit: saveEmotionDataPack.isLocationLegit, isDataInCore: true)
			CoreDataManager.sharedInstance.saveEmotionCore(newEmotion:saveEmotionDataPack)
		}

	
		emojiScreenAlingments()
		modeText.text?.removeAll()
		modeText.placeholder = "how are you feeling..."
		characterCounter.text = "21 / 0"
		pubLicPrivateSkewBtnReset()
		
		
	}
	
	@IBAction func backBtnTapped(sender:UIButton) {
		self.emojiView.removeFromSuperview()
	}
}


extension EmojiPopUp: UITextFieldDelegate {
	
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let textFieldText = textField.text,
			let rangeOfTextToReplace = Range(range, in: textFieldText) else {
				return false
		}
		let substringToReplace = textFieldText[rangeOfTextToReplace]
		let count = textFieldText.count - substringToReplace.count + string.count
		
		if count <= 21 {
			characterCounter.text = "21 / \(count)"
		}
		return count <= 21
	}
}
