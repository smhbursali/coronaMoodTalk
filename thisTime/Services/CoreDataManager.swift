//
//  CoreDataManager.swift
//  thisTime
//
//  Created by semih bursali on 11/22/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import CoreData
import UIKit

open class CoreDataManager: NSObject {
	public static let sharedInstance = CoreDataManager()
	
	private override init() {}
	
	var localEmotions:[Emotions]?
	
	
    private func getContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
	}
	
	private lazy var emotionsEntity: NSEntityDescription? = {
		guard let managedContext = getContext() else {return nil}
		   return NSEntityDescription.entity(forEntityName: CORE_DATA_EMOTIONS_ENTITY_REF, in: managedContext)
	   }()
	
	
	///call core  data here
	func retrieveLocalEmotions(completion:@escaping(_ status:Bool, _ error:Error?)->()){
        guard let managedContext = getContext() else {
			completion(true, nil)
			return }
        let fetchRequest = NSFetchRequest<Emotions>(entityName: CORE_DATA_EMOTIONS_ENTITY_REF)

        do {
            let result = try managedContext.fetch(fetchRequest)
			self.localEmotions = result
            completion(true, nil)
        } catch let error as NSError {
			completion(true, error)
        }
    }
	
	func saveEmotionCore(newEmotion:SaveEmotionModel) {
		guard let managedContext = getContext(),
		      let emotionsEntity = emotionsEntity else {return}
		let emotion = Emotions(entity: emotionsEntity, insertInto: managedContext)
		emotion.about = newEmotion.about
		emotion.createdAt = "\(Date().timeIntervalSince1970)"
		emotion.emojiName = newEmotion.emojiName
		emotion.emotionTitle = newEmotion.emotionTitle
		emotion.latitude = "\(newEmotion.location.latitude)"
		emotion.longitude = "\(newEmotion.location.longitude)"
		
		do {
			try managedContext.save()
			
		}catch let error as NSError {
			print("failed in save \(error)")
		}
		
		//add here localEmotions
		localEmotions?.insert(emotion, at: 0)
		
	}
	
	

}
