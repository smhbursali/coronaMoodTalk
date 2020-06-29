//
//  IntroVC.swift
//  thisTime
//
//  Created by semih bursali on 10/25/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import FirebaseAuth

class IntroVC: UIViewController {
	
	private lazy var nickNameTxt:UITextField = {
		let txt = UITextField()
		txt.frame = CGRect(x: 40, y: shapeSize.width2 + 20, width: width - 80, height: 35)
		txt.delegate = self
		txt.borderStyle = .roundedRect
		txt.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		txt.placeholder = "nick name"
		return txt
	}()
	
	private lazy var nickNameSubmitBtn:UIButton = {
		let btn = UIButton()
		btn.frame = CGRect(x: 0, y: shapeSize.width2 + 70, width: shapeSize.width4, height: shapeSize.width4)
		btn.layer.cornerRadius = shapeSize.width8
		btn.clipsToBounds = true
		btn.titleLabel?.numberOfLines = 0
		btn.titleLabel?.adjustsFontSizeToFitWidth = true
		btn.setTitle("express\nyourself", for: .normal)
		btn.center.x = self.view.center.x
		btn.addTarget(self, action: #selector(self.nickNameSubmitBtnTapped), for: .touchUpInside)
		btn.backgroundColor = #colorLiteral(red: 0.8957495093, green: 0, blue: 0.2064105868, alpha: 1)
		btn.titleLabel?.textAlignment = .center
		btn.titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		btn.titleLabel?.font = UIFont(name: "Avenir Next", size: 15)
		return btn
	}()
    override func viewDidLoad() {
        super.viewDidLoad()
		
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(true)
		guard Auth.auth().currentUser?.uid != nil else {
			view.addSubview(nickNameTxt)
			view.addSubview(nickNameSubmitBtn)
			nickNameTxt.becomeFirstResponder()
			return
		}
		sendfirstVC()
	}

	@IBAction func nickNameSubmitBtnTapped(sender:UIButton) {
		if !(nickNameTxt.text?.isEmpty ?? true) {
			//send server
			DataService.createUser(nickName: nickNameTxt.text!) { (status, error) in
				if status {
					guard let err = error else {
						//send second view controller here
						self.sendfirstVC()
						DataService.sendTokens()
						return
					}
					self.alertView(message: err.localizedDescription, colorPereferences: alertColor)
				}
			}
		}
		else {
			self.alertView(message: "nick name . . .", colorPereferences: alertColor)
		}
		
	}
	private func sendfirstVC () {
		guard let newVc = storyboard?.instantiateViewController(withIdentifier: "firstVC") as? FirstVC else {return}
		newVc.modalPresentationStyle = .fullScreen
		self.present(newVc, animated: true, completion: nil)
	}
	
}


extension IntroVC:UITextFieldDelegate {
	
}



