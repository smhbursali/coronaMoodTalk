//
//  Constants.swift
//  surveyControl
//
//  Created by semih bursali on 9/28/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import Foundation
import UIKit



let alertColor:UIColor = #colorLiteral(red: 0.7702896595, green: 0.1189569309, blue: 0.302449435, alpha: 0.7297463613)



//sakin bunlari unutma buyuk problem guard let le

let screenRect = UIScreen.main.bounds
let width = screenRect.size.width
let height = screenRect.size.height

let shapeSize = ShapeSize.model

class ShapeSize {
    
    static let model = ShapeSize()
    
    //let width1:CGFloat!
     let imgHeight:CGFloat = {
        return (width * 2) / 3
    }()
     let width1:CGFloat = {
        return width
    }()
    let width2:CGFloat = {
        return width / 2
    }()
    let width3:CGFloat = {
        return width / 3
    }()
	let width8:CGFloat = {
		   return width / 8
	   }()
    let width2180:CGFloat = {
        return width / 2.18
    }()
    let width240:CGFloat = {

        return width / 2.4
    }()
    let width5:CGFloat = {
        return width / 5
    }()
     let width125:CGFloat = {
        return width / 12.5
    }()
    let width12:CGFloat = {
        return width / 12
    }()
    let width4:CGFloat = {
        return width / 4
    }()
    let width468:CGFloat = {
        return width / 4.68
    }()
     let width75:CGFloat = {
        return width / 75
    }()
    let width7:CGFloat = {
        return width / 7
    }()
    let width6:CGFloat = {
        return width / 6
    }()
    let width24:CGFloat = {
        return width / 24
    }()
	let width10:CGFloat = {
		return width / 10
	}()
//    let width750:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 7.5
//    }()
//     let width79:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 7.9
//    }()
//     let width94:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 9.4
//    }()
//     let width375:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 37.5
//    }()
//    let width3750:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.75
//    }()
//    let width3:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3
//    }()
//    let width950:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 9.5
//    }()
//    let width18750:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.875
//    }()
//     let width111:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.11
//    }()
//     let width25:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 25
//    }()
//     let width781:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 7.81
//    }()
//     let width30:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 30
//    }()
//     let width214:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 2.14
//    }()
//    let width250:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 2.5
//    }()
//    let width2770:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 2.77
//    }()
//    let width235:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 2.35
//    }()
//    let width227:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 2.27
//    }()
//     let width15:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 15
//    }()
//     let width166:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.66
//    }()
//     let width147:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.47
//    }()
//     let width13:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.3
//    }()
//     let width1179:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.179
//    }()
    let width560:CGFloat = {
        return width / 5.6
    }()
//    let width1334:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 133.4
//    }()
//    let width8:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 8
//    }()
//    let width850:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 8.5
//    }()
//    let width340:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.4
//    }()
//    let width3120:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.12
//    }()
//    let width326:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.26
//    }()
//    let width350:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.5
//    }()
//    let width6180:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 6.18
//    }()
//    let width3940:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 3.94
//    }()
//     let width1875:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 - (width1 / 18.75)
//    }()
//    let width187500:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 18.75
//    }()
//    let width9860:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 9.86
//    }()
    let width9370:CGFloat = {
        return width / 9.37
    }()
//    let width1970:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.97
//    }()
//    let width1920:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 1.92
//    }()
//    let width6250:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return width1 / 6.25
//    }()
//    let height1:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1
//    }()
//    let height1212:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 12.12
//    }()
//    let height206:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 2.06
//    }()
//    let height3335:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 33.35
//    }()
//    let height33:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 33
//    }()
    let height2223:CGFloat = {
        return height / 22.23
    }()
    let height2:CGFloat = {
		return height / 2
    }()
	let height4:CGFloat = {
		return height / 4
    }()
//    let height606:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 6.06
//    }()
//    let height667:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 66.7
//    }()
//    let height6670:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 6.67
//    }()
//    let height92:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 9.2
//    }()
//    let height1667:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 16.675
//    }()
    let height952:CGFloat = {
        return height / 9.52
    }()
//    let height37:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 3.7
//    }()
    let height3031:CGFloat = {
        return height / 30.31
    }()
//    let height261:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 2.61
//    }()
//    let height1334:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 133.4
//    }()
//    let height11:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 11
//    }()
//    let height1905:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 19.05
//    }()
//    let height1875:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 18.75
//    }()
//    let height31:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 3.1
//    }()
//    let height250:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 2.5
//    }()
//    let height230:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 2.3
//    }()
//    let height635:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 6.35
//    }()
//    let height513:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 5.13
//    }()
//    let height338:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 3.38
//    }()
//    let height2779:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 27.79
//    }()
//    let height1482:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 14.82
//    }()
//    let height190:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 1.9
//    }()
//    let height7:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 7
//    }()
//    let height1111:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 11.11
//    }()
//    let height220:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 2.2
//    }()
//    let height13340:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 13.34
//    }()
//    let height1190:CGFloat = {
//        guard let height1 = height else {return CGFloat()}
//        return height1 / 1.19
//    }()
//    let surveyLblWidth:CGFloat = {
//        guard let width1 = width else {return CGFloat()}
//        return (width1 - 20) / 5
//    }()
}


