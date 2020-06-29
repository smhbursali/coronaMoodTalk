//
//  extension.swift
//  thisTime
//
//  Created by semih bursali on 10/25/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import CoreLocation

extension UITextField {
    func placeholderColor(color: UIColor, placeHolderText:String){
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color.withAlphaComponent(0.5)])
        
    }
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension UIViewController {
	
	
	func alertView(message:String, colorPereferences: UIColor) {
		  
		  let height = self.view.bounds.height
		  let width = self.view.bounds.width
		  let alertView = UIView()
		  
		  alertView.backgroundColor = colorPereferences
		  self.view.addSubview(alertView)
		  
		  let messageLbl = UILabel()
		  messageLbl.numberOfLines = 0
		  messageLbl.font = UIFont(name: "Avenier Next", size: 12)
		  messageLbl.textColor = .white
		  messageLbl.textAlignment = .center
		  messageLbl.text = message
		   messageLbl.adjustsFontSizeToFitWidth = true
		  self.view.addSubview(messageLbl)
		  
		  
			let lblHeight = height / 11.11 - (UIApplication.shared.statusBarFrame.height)
		  
		  UIView.animate(withDuration: 0.65, animations: {
			  alertView.frame = CGRect(x: 0, y: 0, width: width, height: height / 11.11)
			  messageLbl.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: width, height: lblHeight)
		  }) { (finished) in
			  
			  if finished {
				  UIView.animate(withDuration: 0.3, delay: 2, options: .curveLinear, animations: {
					  alertView.frame.origin.y = 0 - height / 11.11
					  messageLbl.frame.origin.y = 0 - lblHeight
				  }, completion: { (finished) in
					  if finished {
						  alertView.removeFromSuperview()
						  messageLbl.removeFromSuperview()
					  }
				  })
			  }
		  }
	  }
}

extension CLLocation {
	func generateRandomCoordinates(fakeUser:Bool?)-> CLLocation {
		var currentLong:Double
		var currentLat:Double
		var min: UInt32
		var max: UInt32
		if let lastLoc = DataService.userDataModel?.lastKnownLocation {
			currentLong = lastLoc.longitude
			currentLat = lastLoc.latitude
			min = 5000
			max = 5000
		}
		else {
			if let f = fakeUser {
				if f {
					currentLong = Locator.sharedInstance.getLocationAsCLlocation().coordinate.longitude
					currentLat = Locator.sharedInstance.getLocationAsCLlocation().coordinate.latitude
					min = 500
					max = 500
				}
				else {
					currentLong = -73.82516520851782
					currentLat = 42.687774658203125
					min = 50000
					max = 50000
				}
			} else {
			currentLong = -73.82516520851782
			currentLat = 42.687774658203125
			min = 50000
			max = 50000
			}
		}
		let meterCord = 0.00900900900901 / 1000

		//Generate random Meters between the maximum and minimum Meters
		let randomMeters = UInt(arc4random_uniform(max) + min)

		//then Generating Random numbers for different Methods
		let randomPM = arc4random_uniform(8)

		//Then we convert the distance in meters to coordinates by Multiplying the number of meters with 1 Meter Coordinate
		let metersCordN = meterCord * Double(randomMeters)

		//here we generate the last Coordinates
		if randomPM == 0 {
					return CLLocation(latitude: currentLat + metersCordN, longitude: currentLong + metersCordN)
				}else if randomPM == 1 {
					return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong - metersCordN)
				}else if randomPM == 2 {
					return CLLocation(latitude: currentLat + metersCordN, longitude: currentLong - metersCordN)
				}else if randomPM == 3 {
					return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong + metersCordN)
				}else if randomPM == 4 {
					return CLLocation(latitude: currentLat, longitude: currentLong - metersCordN)
				}else {
					return CLLocation(latitude: currentLat - metersCordN, longitude: currentLong)
				}
		
		
	}
	
}


extension String {
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		   let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
		   let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
		   
		   return ceil(boundingBox.height)
	   }
	func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension Date {
	
	static func timeAgo(timeStamp:TimeInterval) -> String {
		let difference = Date().timeIntervalSince1970 - timeStamp
		if difference >= 3600 {
			return "\(Int(difference / 3600))h. ago"
		}
		else {
			if difference > 60 {
				let min = Int(difference / 60)
				return "\(min)m. ago"
			}
			else {
				return "now"
			}
		}
	}
}


extension UIView {
	func oval(edge:CGFloat) {
        self.layer.cornerRadius = edge
        self.clipsToBounds = true
    }
}

extension UITextView {
	static func validate(textView: UITextView) -> Bool {
		  guard let text = textView.text,
			  !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
				  return false
		  }
		  return true
	  }
}


extension UILabel {
	func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        let bestFittingFont = UIFont.bestFittingFont(for: text, in: bounds, fontDescriptor: currentFont.fontDescriptor)
        font = bestFittingFont
    }
    func adjustViewHeight(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
    }
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        guard let text = self.text else { return super.intrinsicContentSize }
        
        var contentSize = super.intrinsicContentSize
        var textWidth: CGFloat = frame.size.width
        var insetsHeight: CGFloat = 0.0
        
        if let insets = padding {
            textWidth -= insets.left + insets.right
            insetsHeight += insets.top + insets.bottom
        }
        
        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        
        contentSize.height = ceil(newSize.size.height) + insetsHeight
        
        return contentSize
    }
}

extension UIFont {
	static func bestFittingFontSize(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor) -> CGFloat {
		 let constrainingDimension = min(bounds.width, bounds.height)
		 let properBounds = CGRect(origin: .zero, size: bounds.size)
		 
		 var bestFontSize: CGFloat = constrainingDimension
		 
		 for fontSize in stride(from: bestFontSize, through: 0, by: -1) {
			 let newFont = UIFont(descriptor: fontDescriptor, size: fontSize)
			 let currentFrame = text.boundingRect(with: properBounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: newFont], context: nil)
			 
			 if properBounds.contains(currentFrame) {
				 bestFontSize = fontSize
				 break
			 }
		 }
		 
		 return bestFontSize
	 }
	 
	 static func bestFittingFont(for text: String, in bounds: CGRect, fontDescriptor: UIFontDescriptor) -> UIFont {
		 let bestSize = bestFittingFontSize(for: text, in: bounds, fontDescriptor: fontDescriptor)
		 return UIFont(descriptor: fontDescriptor, size: bestSize)
	 }
}
