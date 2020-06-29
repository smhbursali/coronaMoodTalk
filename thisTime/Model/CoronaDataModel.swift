//
//  CoronaDataModel.swift
//  thisTime
//
//  Created by semih bursali on 3/15/20.
//  Copyright © 2020 semih bursali. All rights reserved.
//

import FirebaseFirestore


class CoronaDataModel {
	static var sharedInstance:CoronaDataModel?
	var data = [String:Any]()
	
	init(querSnapShot:QuerySnapshot?,country:String,state:String,completion:@escaping(_ status:Bool)->()) {
		CoronaDataModel.sharedInstance = self
		if let query = querSnapShot {
			for doc in query.documents{
				let data = doc.data()
				let key = data[STATE_REF] as? String ?? ""
				let c = data[CORONA_COUNTRY_REF] as? String ?? ""
				self.data[key] = [ c: coronaData(country: data[CORONA_COUNTRY_REF] as? String ?? "", state: data[STATE_REF] as? String ?? "", deadth: data[DEATHS_REF] as? Int ?? 0, confirmed: data[CONFIRMED_REF] as? Int ?? 0, recovered: data[RECOVERED_REF] as? Int ?? 0)]
				if self.data.count == query.documents.count {
					completion(true)
				}
			}
			
		}
		else {
			completion(true)
			CoronaDataModel.sharedInstance = nil
		}
	}
	
	
	
}


struct coronaData {
	var country:String
	var state:String
	var death:Int
	var confirmed:Int
	var recovered:Int
	var active:Int
	init(country:String, state:String, deadth:Int, confirmed:Int, recovered:Int) {
		self.country = country
		self.state = state
		self.death = deadth
		self.confirmed = confirmed
		self.recovered = recovered
		self.active = confirmed - (recovered + death)
	}
}
