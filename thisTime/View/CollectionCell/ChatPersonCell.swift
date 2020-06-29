//
//  ChatPersonCell.swift
//  thisTime
//
//  Created by semih bursali on 11/8/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit

class ChatPersonCell: UITableViewCell {

  
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: "chatPerson")
		self.contentView.addSubview(profileLabel)
		self.contentView.addSubview(textLbl)
		self.contentView.addSubview(nickNameLbl)
		self.contentView.addSubview(timeLbl)
		self.contentView.addSubview(notifLbl)
		self.contentView.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var profileLabel:UILabel = {
		  let firstLbl = UILabel(frame: CGRect(x: 10, y: 10, width: shapeSize.width9370, height: shapeSize.width9370))
		  firstLbl.backgroundColor = #colorLiteral(red: 0.1292660236, green: 0.7338587642, blue: 0.8004856706, alpha: 1)
		  firstLbl.oval(edge: shapeSize.width560 / 2)
		  firstLbl.font = UIFont(name: "Chalkduster", size: 30)
		  firstLbl.adjustsFontSizeToFitWidth = true
		  firstLbl.textAlignment = .center
		  return firstLbl
	  }()
	  private lazy var notifLbl:UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: shapeSize.width1 - 105, y: 5, width: 20, height: 20)
		lbl.adjustsFontSizeToFitWidth = true
		lbl.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0.2011827826, alpha: 1)
		lbl.oval(edge: 10)
		lbl.padding = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
		lbl.font = UIFont(name: "Avenir Next", size: 11)
		lbl.isHidden = true
		lbl.textAlignment = .center
		lbl.textColor = .white
		return lbl
	  }()
	  private lazy var textLbl:UILabel = {
		  let label = UILabel(frame: CGRect(x: shapeSize.width9370 + 15, y: 25, width: shapeSize.width1 - 130 - shapeSize.width9370, height: 30))
		  let font = UIFont(name: "Avenir Next", size: 12)
		  label.font = font
		  label.numberOfLines = 0
		  label.textColor = .darkGray
		label.adjustsFontSizeToFitWidth = true
		  return label
	  }()
	  private lazy var nickNameLbl: UILabel = {
		  let label = UILabel(frame: CGRect(x: 15 + shapeSize.width9370, y: 5, width: shapeSize.width1 - 110 - shapeSize.width9370, height: 20))
		  let font = UIFont.italicSystemFont(ofSize: 11)
		  label.font = font
		  label.textColor = .black
			label.textAlignment = .left
		  return label
	  }()
	  private lazy var timeLbl:UILabel = {
		  let label = UILabel(frame: CGRect(x: shapeSize.width1 - 115, y: 41, width: 30, height: 17))
		  let font = UIFont.italicSystemFont(ofSize: 10)
		  label.font = font
		  label.textColor = .darkGray
		  label.textAlignment = .right
		  label.adjustsFontSizeToFitWidth = true
		  return label
	  }()

	  func configureCell(message:chatHistoryMessageStruct) {
		profileLabel.text =  message.crossNickName.prefix(1).uppercased()
		textLbl.text = message.lastMessage
		nickNameLbl.text = message.crossNickName
		timeLbl.text = Date.timeAgo(timeStamp: message.lastMessageTime)
		
		if message.isUnseen {
			notifLbl.isHidden = false
			notifLbl.text = "\(message.subTotalUnSeen)"
		}
		else {
			notifLbl.isHidden = true
			notifLbl.text = nil
		}

	  }

}

