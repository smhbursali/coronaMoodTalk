//
//  GoToZipCodeView.swift
//  thisTime
//
//  Created by semih bursali on 3/14/20.
//  Copyright © 2020 semih bursali. All rights reserved.
//

import UIKit

protocol GoToZipCodeViewDelegate {
	func gotoZipTapped(zipCode:String)
}

class GoToZipCodeView:NSObject {
	static var sharedInstance: GoToZipCodeView?
	var delegate:GoToZipCodeViewDelegate?
	
	deinit {
		print("GoToZipCodeView de init")
	}
	init(delegate:GoToZipCodeViewDelegate) {
		self.delegate = delegate
		super.init()
		generalView.addSubview(self.zipCodeTextField)
		generalView.addSubview(self.goBtn)
		generalView.addSubview(self.backBtn)
		zipCodeTextField.becomeFirstResponder()
	}
	
	private let generalView:UIView = {
		let view = UIView()
		view.frame = CGRect(x: 20, y: height / 2 - 50, width: width - 40, height:105)
		view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5265410959)
		view.oval(edge: 5)
		return view
	}()
	private lazy var zipCodeTextField:UITextField = {
		let txt = UITextField()
		txt.frame = CGRect(x: 10, y: 20, width: width - 100, height: 30)
		txt.placeholder = "zipcode"
		txt.keyboardType = .numberPad
		txt.placeholderColor(color: .white, placeHolderText: "zipcode")
		txt.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8753745719)
		txt.oval(edge: 3)
		return txt
	}()
	private lazy var goBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: shapeSize.width1 - 110, y: 65, width: 60, height: 30)
		btn.addTarget(self, action: #selector(GoToZipCodeView.submitBtnTapped), for: .touchUpInside)
		btn.backgroundColor = #colorLiteral(red: 0.5026292205, green: 0.8445406556, blue: 0.9892203212, alpha: 1)
		btn.setTitle("Go", for: .normal)
		btn.oval(edge: 3)
		return btn
	}()
	private lazy var backBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: width - 80, y: 20, width: 30, height: 30)
		btn.addTarget(self, action: #selector(GoToZipCodeView.backBtnTapped), for: .touchUpInside)
		btn.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
		
		return btn
	}()
	
	
	
	@IBAction func submitBtnTapped(sender:UIButton) {
		delegate?.gotoZipTapped(zipCode: zipCodeTextField.text ?? "000000")
		generalView.removeFromSuperview()
		GoToZipCodeView.sharedInstance = nil
	}
	
	@IBAction func backBtnTapped(sender:UIButton) {
		generalView.removeFromSuperview()
		GoToZipCodeView.sharedInstance = nil
	}
	
	func preapreForDisplay()->UIView {
		return generalView
	}

}
