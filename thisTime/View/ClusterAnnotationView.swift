//
//  ClusterAnnotationView.swift
//  thisTime
//
//  Created by semih bursali on 11/1/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import MapKit

class ClusterAnnotationView:MKAnnotationView {
	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		collisionMode = .circle
		centerOffset = CGPoint(x: 0, y: -10)
	}
	override func prepareForDisplay() {
		super.prepareForDisplay()
		
		if let cluster = annotation as? MKClusterAnnotation {
			let totalEmotion = cluster.memberAnnotations.count
			
			if count(emotionType: .happy) > 0 {
				//happy clustering
				image = drawHappyCount(count: totalEmotion)
			}
			if count(emotionType: .aaa) > 0 {
				image = drawAAACount(count: totalEmotion)
			}
			if count(emotionType: .mmm) > 0 {
				image = drawMMMCount(count: totalEmotion)
			}
			if count(emotionType: .angery) > 0 {
				image = drawAngeryCount(count: totalEmotion)
			}
			if count(emotionType: .cry) > 0 {
				image = drawCryCount(count: totalEmotion)
			}
			if count(emotionType: .sss) > 0 {
				image = drawSSSCount(count: totalEmotion)
			}
			if count(emotionType: .xx) > 0 {
				image = drawXXCount(count: totalEmotion)
			}
			if count(emotionType: .zzz) > 0 {
				image = drawZZZCount(count: totalEmotion)
			}
			
		}
	}
	
	private func drawHappyCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1))
	}
	private func drawAngeryCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.8044856191, green: 0.1853864193, blue: 0.1659093201, alpha: 1))
	}
	private func drawMMMCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
	}
	private func drawAAACount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
	}
	private func drawCryCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1))
	}
	private func drawSSSCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.8873460889, green: 0.5229536295, blue: 0.9359019399, alpha: 1))
	}
	private func drawXXCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
	}
	private func drawZZZCount(count:Int)->UIImage {
		return drawRadio(fraction: 0, whole: count, fractionColor: nil, wholeColor: #colorLiteral(red: 0, green: 0.8980928063, blue: 0.6800190806, alpha: 1))
	}
	
	private func drawRadio(fraction:Int, whole:Int, fractionColor:UIColor?, wholeColor:UIColor?)->UIImage {
		let render = UIGraphicsImageRenderer(size: CGSize(width: 50, height: 50))
		return render.image { _ in
			//background color
			wholeColor?.setFill()
			UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 50, height: 50)).fill()
			
			fractionColor?.setFill()
			let piePath = UIBezierPath()
			piePath.addArc(withCenter: CGPoint(x: 25, y: 25), radius: 25, startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(fraction)) / CGFloat(whole), clockwise: true)
			
			piePath.addLine(to: CGPoint(x: 25, y: 25))
			piePath.close()
			piePath.fill()
			
			UIColor.white.setFill()
			 UIBezierPath(ovalIn: CGRect(x: 10, y: 10, width: 30, height: 30)).fill()
			
			let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
							  NSAttributedString.Key.font: UIFont(name: "Avenir Next", size: 20)]
			let text = "\(whole)"
			let size = text.size(withAttributes: attributes as [NSAttributedString.Key : Any])
			let rect = CGRect(x: 25 - size.width / 2, y: 25 - size.height / 2, width: size.width, height: size.height)
			
			text.draw(in: rect, withAttributes: attributes as [NSAttributedString.Key : Any])
		}
	}
	
	private func count(emotionType:EmojiType)->Int {
		guard let cluster = annotation as? MKClusterAnnotation else {return 0}
		
		return cluster.memberAnnotations.filter { (member) -> Bool in
			guard let emotion = member as? EmojiAnnotation else {
				fatalError("un expected annotation type")
			}
			return emotion.type == emotionType
		}.count
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
