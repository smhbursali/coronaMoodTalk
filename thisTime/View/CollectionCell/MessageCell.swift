//
//  MessageCell.swift
//  thisTime
//
//  Created by semih bursali on 11/6/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
  
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        let radians = atan2f(Float(self.contentView.transform.b), Float(self.contentView.transform.a))
        let degrees = radians * (180 / Float.pi)
        let transform = CGAffineTransform(rotationAngle: CGFloat((180 + degrees) * Float.pi/180))
        self.contentView.transform = transform
        self.backgroundColor = #colorLiteral(red: 0.8590483069, green: 0.8539420962, blue: 0.8629736304, alpha: 1)
        self.contentView.addSubview(textLabel)
        self.contentView.addSubview(timeLabel)
    }
 
    private let textLabel:UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Avenir Next", size: 15)
        label.font = font
        label.numberOfLines = 0
        label.textColor = .white
        label.padding = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.oval(edge: 5)
        return label
    }()
    private let timeLabel:UILabel = {
        let label = UILabel()
        let font =  UIFont.italicSystemFont(ofSize: 9)
        label.font = font
        label.textColor = .darkGray
		label.adjustsFontSizeToFitWidth = true
        return label
    }()
 
    func configureCell(messege:MessageModel, heightCell:CGFloat, widthCell:CGFloat) {
		let maxwidth = (shapeSize.width1 * 2) / 3
        var textWidth = widthCell
        if textWidth > maxwidth {
            textWidth = maxwidth
        }
        
		if messege.senderUID != DataService.uid {
          //left side
			textLabel.frame = CGRect(x: 10.0, y: 2.5, width: textWidth + 10.3, height: heightCell + 10)
            textLabel.text = messege.message
            textLabel.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1)

            timeLabel.frame = CGRect(x: textWidth + 23, y: 5.0, width: 40, height: 20)
			timeLabel.text = Date.timeAgo(timeStamp: messege.createdAt)
            timeLabel.textAlignment = .left

        }
        else {
          //right side
			textLabel.frame = CGRect(x: shapeSize.width1 - textWidth - 25, y: 2.5, width: textWidth + 10.3, height: heightCell + 10)
            textLabel.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1)
            textLabel.text = messege.message

			timeLabel.frame = CGRect(x: shapeSize.width1 - textWidth - 68, y: 5.0, width: 40, height: 20)
            timeLabel.text = Date.timeAgo(timeStamp: messege.createdAt)
            timeLabel.textAlignment = .right

        }
	
  
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
