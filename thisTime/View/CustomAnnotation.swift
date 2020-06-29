//
//  CustomAnnotation.swift
//  thisTime
//
//  Created by semih bursali on 10/23/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import MapKit


class CustomAnnotation: NSObject, MKAnnotation {

    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    var title: String?
    
    var subtitle: String?
    
    var imageName: String?
	
    static let sharedInstance = CustomAnnotation(coordinate: CLLocationCoordinate2D())
	
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
