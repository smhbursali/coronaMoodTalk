//
//  AboutPopUpView.swift
//  thisTime
//
//  Created by semih bursali on 11/4/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit

class AboutPopUpView:NSObject {
	
	
	 lazy var aboutView:UIView = {
		let view = UIView()
		view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.7187767551)
		view.layer.cornerRadius = 10
		view.clipsToBounds = true
		
		return view
	}()
	
	static let sharedInstance = AboutPopUpView(frame: CGRect(x: 20, y: height / 7, width: width - 40, height: shapeSize.width3 + 80))
	
	init(frame:CGRect) {
		super.init()
		aboutView.frame = frame
		aboutpopUpViewAlingments()
		DataService.getAboutInfo { (status, about, error) in
			if status {
				guard let about2 = about else {return}
				self.aboutTxt.text = about2
				self.characterCounter.text = "200/ \(about2.count)"
			}
		}
	}
	
	func aboutpopUpViewAlingments() {
		aboutView.addSubview(aboutTxt)
		aboutView.addSubview(aboutSubmitBtn)
		aboutView.addSubview(cancelBtn)
	}
	
	 lazy var aboutTxt: UITextView = {
		let txt = UITextView()
		txt.frame = CGRect(x: 20, y: 20, width: width - 80, height: shapeSize.width3)
		txt.delegate = self
		txt.textColor = .white
		txt.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
		txt.smartInsertDeleteType = UITextSmartInsertDeleteType.no
		txt.font = UIFont(name: "Avenir Next", size: 15)
		txt.addSubview(self.characterCounter)
		txt.layer.cornerRadius = 5
		txt.clipsToBounds = true
		return txt
	}()
	private lazy var characterCounter: UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: width - 82 - shapeSize.width7, y: shapeSize.width3 - 10, width: shapeSize.width7, height: 10)
		lbl.textColor = .white
		lbl.textAlignment = .center
		lbl.text = "200 / 0"
		lbl.font = UIFont.italicSystemFont(ofSize: 8)
		lbl.adjustsFontSizeToFitWidth = true
		return lbl
	}()
	private lazy var aboutSubmitBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: width - 90, y: shapeSize.width3 + 30, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.aboutSubmitBtnTapped), for: .touchUpInside)
		btn.setTitle("📌", for: .normal)
		btn.backgroundColor = #colorLiteral(red: 0, green: 0.9337626696, blue: 0.9172133803, alpha: 1)
		btn.layer.cornerRadius = 5
		btn.clipsToBounds = true
		return btn
	}()
	private lazy var cancelBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: 0, y: shapeSize.width3 + 30, width: 50, height: 50)
		btn.addTarget(self, action: #selector(self.cancelBtnTapped), for: .touchUpInside)
		btn.setTitle("❌", for: .normal)
		btn.backgroundColor = #colorLiteral(red: 0, green: 0.9337626696, blue: 0.9172133803, alpha: 1)
		btn.layer.cornerRadius = 5
		btn.clipsToBounds = true
		return btn
	}()
	
	
	@IBAction func aboutSubmitBtnTapped(sender:UIButton) {
		DataService.saveAboutText(about: self.aboutTxt.text)
		resetView()
	}
	
	@IBAction func cancelBtnTapped(sender:UIButton) {
		resetView()
	}
	
	private func resetView(){
		UIView.animate(withDuration: 1.3) {
			self.aboutView.removeFromSuperview()
		}
	}
}

extension AboutPopUpView: UITextViewDelegate{
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		 let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
			let numberOfChars = newText.count
			characterCounter.text = "200/ \(numberOfChars)"
			return numberOfChars < 200
		
	}
}
