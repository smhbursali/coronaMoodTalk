//
//  AnnotationClickView.swift
//  thisTime
//
//  Created by semih bursali on 11/1/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import MapKit


class AnnotationClickView {

	 
	static let sharedInstance = AnnotationClickView()
	private(set) var activeUser:ActiveUsers?
	
	private var boxWidth:CGFloat = shapeSize.width2 - 28
	
	init() {	}
	
	 lazy var stackView: UIStackView = {
		let view = UIStackView(arrangedSubviews: [nickNameLabel, explanationLabel,DMbutton])
		view.axis = .vertical
		view.alignment = .center
		view.spacing = 10

		return view
	  }()
	
	 lazy var nickNameLabel:UILabel = {
		let lbl = UILabel(frame: .zero)
		lbl.numberOfLines = 1
		lbl.textAlignment = .center
		lbl.font = UIFont.preferredFont(forTextStyle: .body)
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.heightAnchor.constraint(equalToConstant: 25).isActive = true
		lbl.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
		lbl.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8579302226)
		lbl.layer.cornerRadius = 5
		lbl.clipsToBounds = true
		
		return lbl
	}()
	
	 lazy var explanationLabel:UILabel = {
		let lbl = UILabel(frame: .zero)
		lbl.numberOfLines = 0
		lbl.lineBreakMode = .byWordWrapping
		lbl.textAlignment = .center
		lbl.font = UIFont(name: "Avenir Next", size: 15)
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
		lbl.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8579302226)
		lbl.layer.cornerRadius = 5
		lbl.clipsToBounds = true
		

		return lbl
	}()
	 lazy var DMbutton:UIButton = {
		let btn = UIButton(frame: .zero)
		btn.setTitle("   talk   ", for: .normal)
		btn.addTarget(self, action: #selector(self.DmButtonTapped), for: .touchUpInside)
		btn.backgroundColor = .cyan
		btn.layer.cornerRadius = 2
		btn.clipsToBounds = true
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
		btn.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
		
		return btn
	}()
	
	@IBAction func DmButtonTapped(sender:UIButton) {
		guard let recieverUid = activeUser?.activeUserUid,
			let receiverNickName = activeUser?.nickName   else {return}
		stackView.superview?.addSubview(DirekMessageView.sharedInstance.prepareForNextDisplay(receiverUid: recieverUid, receiverNickName: receiverNickName, isComingFromMap: true))
		stackView.removeFromSuperview()
	}
	
	func prepareForDisplay(view:MKAnnotationView, activeUser:ActiveUsers)->UIStackView {
		var contentHeight:CGFloat
		if activeUser.activeUserUid == DataService.uid {
			DMbutton.isHidden = true
		}
		else {
			DMbutton.isHidden = false
		}
	
		if activeUser.about != nil {
			contentHeight = activeUser.about!.height(withConstrainedWidth: boxWidth - 4, font:  UIFont(name: "Avenir Next", size: 15) ?? UIFont.preferredFont(forTextStyle: .body)) + 75
		explanationLabel.text = activeUser.about
		}
		else {
			contentHeight = 75
		}
		
		if view.frame.maxX > shapeSize.width2 && view.frame.maxY > shapeSize.height2 {
			stackView.frame = CGRect(x: view.frame.minX - boxWidth, y: view.frame.maxY - contentHeight, width: boxWidth, height: contentHeight)
		
		}
		else if view.frame.maxX <= shapeSize.width2 && view.frame.maxY >= shapeSize.height2 {
			stackView.frame = CGRect(x: view.frame.maxX, y: view.frame.maxY - contentHeight, width: boxWidth, height: contentHeight)
		}
		else if view.frame.maxX < shapeSize.width2 && view.frame.maxY < shapeSize.height2 {
			stackView.frame = CGRect(x: view.frame.maxX, y: view.frame.maxY, width: boxWidth, height: contentHeight)
		}
		else if view.frame.maxX >= shapeSize.width2 && view.frame.maxY <= shapeSize.height2 {
			stackView.frame = CGRect(x: view.frame.minX - boxWidth, y: view.frame.minY, width: boxWidth, height: contentHeight)
		}
	
		nickNameLabel.text = activeUser.nickName
		self.activeUser = activeUser

		return stackView
	}
	
	
}
