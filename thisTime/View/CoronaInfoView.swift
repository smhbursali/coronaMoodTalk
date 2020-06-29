//
//  CoronaInfoView.swift
//  thisTime
//
//  Created by semih bursali on 3/14/20.
//  Copyright © 2020 semih bursali. All rights reserved.
//

import UIKit
import MapKit

protocol CoronaInfoViewDelegate {
	func animateComingFromBacground()
}
var movingTextData: [NSMutableAttributedString]? {
	didSet {
		guard let data = movingTextData else {return}
		CoronaInfoView.sharedInstace?.movingGeneralLbl.frame = CGRect(x: ((CoronaInfoView.sharedInstace?.lblWidt ?? 0.0) + 10) * 2, y: 10, width: (CoronaInfoView.sharedInstace?.lblWidt ?? 0.0) * CGFloat(data.count), height: shapeSize.height952 - 20)
		CoronaInfoView.sharedInstace?.animationText()
	}
}

class CoronaInfoView:NSObject {
	static var sharedInstace: CoronaInfoView?
	var country:String?
	var province:String?

	var delegate:CoronaInfoViewDelegate?
	var lblInstances = [UILabel]()
	
	
	let lblWidt:CGFloat = {
		return (shapeSize.width2 - 20) / 2
	}()
	
	init(delegate:CoronaInfoViewDelegate) {
		self.delegate = delegate
		super.init()
	}
	
	deinit {
		print("de init CoronaInfoViewCoronaInfoView")
	}

	lazy var infoView:UIView = {
		let view = UIView()
		view.frame = CGRect(x: 0, y: shapeSize.height3031, width: shapeSize.width1, height: shapeSize.height952)
		view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8274026113)
		view.addSubview(self.infoLbl1)
		view.addSubview(self.infoLbl2)
		view.addSubview(self.movingGeneralLbl)
		return view
	}()
	
	private lazy var infoLbl1:UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: 0, y: 0, width: lblWidt, height: shapeSize.height952)
		lbl.textColor = .white
		lbl.numberOfLines = 0
		lbl.adjustsFontSizeToFitWidth = true
		lbl.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		lbl.font = UIFont(name: "Avenir Next", size: 11)
		lbl.padding = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
		return lbl
	}()
	private lazy var infoLbl2:UILabel = {
		let lbl = UILabel()
		lbl.frame = CGRect(x: lblWidt , y: 0, width: lblWidt, height:shapeSize.height952)
		lbl.textColor = .white
		lbl.numberOfLines = 0
		lbl.adjustsFontSizeToFitWidth = true
		lbl.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		lbl.font = UIFont(name: "Avenir Next", size: 11)
		lbl.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
		return lbl
	}()
	
	lazy var movingGeneralLbl:UIView = {
		let lbl = UIView()
		lbl.layer.zPosition = infoLbl2.layer.zPosition - 1
		return lbl
	}()
	
	func generateMovingLbl(text:NSMutableAttributedString, tag:Int)->UILabel {
		let lbl = UILabel()
		lbl.frame = CGRect(x: lblWidt * CGFloat(tag + 1), y: 0, width: lblWidt, height: shapeSize.height952 - 20)
		lbl.textColor = .white
		lbl.numberOfLines = 0
		lbl.adjustsFontSizeToFitWidth = true
		lbl.attributedText = text
		lbl.tag = tag
		return lbl
	}
	
	
	func animationText() {
		DispatchQueue.main.async {
			UIView.animate(withDuration: TimeInterval((movingTextData?.count ?? 0) * 3), delay: 0.0, options: [.repeat, .autoreverse], animations: { [weak self] in
				self!.movingGeneralLbl.transform = CGAffineTransform(translationX: self!.movingGeneralLbl.bounds.origin.x - self!.movingGeneralLbl.frame.width, y: self!.movingGeneralLbl.bounds.origin.y)
				self?.movingGeneralLbl.layoutIfNeeded()
			}) { (status) in
				if status {
					print("basa don")
				}
			}
		}
	}
	
	func deinitTheClass() {
		self.lblInstances.removeAll()
		self.infoView.removeFromSuperview()
		CoronaInfoView.sharedInstace = nil
	}

	func setMovingText(){
		var i = 0
		var temp = [NSMutableAttributedString]()
		if let data = CoronaDataModel.sharedInstance?.data {
			for state in data {
				if let pack = state.value as? [String:coronaData] {
					if let key =  pack.keys.first {
						if let d = pack[key] {
							let t = self.textConverter(data: d)
							temp.append(t)
							let lbl = self.generateMovingLbl(text: t, tag: i)
							self.lblInstances.append(lbl)
							self.movingGeneralLbl.addSubview(lbl)
							i += 1
							if i == data.count {
								movingTextData = temp
							}
						}
					}
				}
			}
		}
	}
	
	func prepareForDisplay()->UIView {
		if CoronaDataModel.sharedInstance?.data == nil {
			Locator.sharedInstance.getCityAndStateName { (status, placeMark, error) in
					if status {
						if error == nil {
							///call corona data here
							let cont = DataService.getCountryForCorona(placeMark: placeMark)
							let state = DataService.getStateNameForCorona(placeMark: placeMark) ?? cont
							DataService.callCoronaData(country: cont, state: state) { (status, response, error) in
								if status {
									if error == nil {
										guard let countryData = response?[cont] as? [String:coronaData],
											let cntData = countryData[cont] else {return}
										self.infoLbl1.attributedText = self.textConverter(data: cntData)
										if let res = response?[state] as? [String:coronaData] {
											if state != cont {
												//res is state info
												guard let stateInfo = res[cont] else {return}
												self.infoLbl2.attributedText = self.textConverter(data: stateInfo)
												self.setMovingText()
											}
										}
										else {
											print(response)
										}
									}
									else {
										print(error)
									}
								}
							}
						}
					}
				}
				
		}
		else {
			Locator.sharedInstance.getCityAndStateName { (status, placeMark, error) in
				if status {
					if error == nil {
						///call corona data here
						let cont = DataService.getCountryForCorona(placeMark: placeMark)
						let state = DataService.getStateNameForCorona(placeMark: placeMark) ?? cont
						guard let countryData = CoronaDataModel.sharedInstance?.data[cont] as? [String:coronaData],
								let cntData = countryData[cont] else {return}
						self.infoLbl1.attributedText = self.textConverter(data: cntData)
						if let res = CoronaDataModel.sharedInstance?.data[state] as? [String:coronaData] {
										if state != cont {
											//res is state info
											guard let stateInfo = res[cont] else {return}
											self.infoLbl2.attributedText = self.textConverter(data: stateInfo)
											self.setMovingText()
										}
							
					}
				}
			}
			
		}
		
	}
		return infoView
	}

	
	private func textConverter(data:coronaData)->NSMutableAttributedString {
		let main_string = "\(data.state)\nconfirmed: \(data.confirmed)\nactive: \(data.active)\ndeath: \(data.death)\nrecovered : \(data.recovered)"
		let string_to_color0 = "\(data.state)"
		let string_to_color1 = "confirmed: \(data.confirmed)"
		let string_to_color2 = "active: \(data.active)"
		let string_to_color3 = "death: \(data.death)"
		let string_to_color4 = "recovered : \(data.recovered)"
		
		let range0 = (main_string as NSString).range(of: string_to_color0)
		let range1 = (main_string as NSString).range(of: string_to_color1)
		let range2 = (main_string as NSString).range(of: string_to_color2)
		let range3 = (main_string as NSString).range(of: string_to_color3)
		let range4 = (main_string as NSString).range(of: string_to_color4)
		let attribute = NSMutableAttributedString.init(string: main_string)
		attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.9458150268, green: 0.03317882866, blue: 0.1506800056, alpha: 1) , range: range1)
		attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green , range: range2)
		attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.220528841, green: 0.6358324885, blue: 0.9145533442, alpha: 1) , range: range3)
		attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange, range: range4)
		attribute.addAttributes([NSAttributedString.Key.font :  UIFont(name: "Avenir Next", size: 15) ?? UIFont.systemFont(ofSize: 13)], range: range0)
		return attribute
	}
	
	func changeInfoLbl2(country:String, state:String){
		guard let k = CoronaDataModel.sharedInstance?.data[state] as? [String:coronaData],
			let stateInfo = k[country] else {return}
			self.infoLbl2.attributedText = self.textConverter(data: stateInfo)
	}
	

}
