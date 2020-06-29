//
//  AppDelegate.swift
//  thisTime
//
//  Created by semih bursali on 10/22/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
		var sharedTokenData = [String:String]()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		Messaging.messaging().delegate = self
			 if #available(iOS 10.0, *) {
				 // For iOS 10 display notification (sent via APNS)
				 UNUserNotificationCenter.current().delegate = self
				 
				 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
				 UNUserNotificationCenter.current().requestAuthorization(
					 options: authOptions,
					 completionHandler: {_, _ in })
			 } else {
				 let settings: UIUserNotificationSettings =
					 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
				 application.registerUserNotificationSettings(settings)
			 }
			 
			application.registerForRemoteNotifications()
		
		FirebaseApp.configure()
		
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}

	
	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "LocalEmotions")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}
}


extension AppDelegate: MessagingDelegate {}


extension AppDelegate {
	//push Notification start
	  
	  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		  // If you are receiving a notification message while your app is in the background,
		  // this callback will not be fired till the user taps on the notification launching the application.
		  // TODO: Handle data of notification
		  // With swizzling disabled you must let Messaging know about the message, for Analytics
		  Messaging.messaging().appDidReceiveMessage(userInfo)
		  // Print message ID.
		  
		  // Print full message.
		  
		  completionHandler(UIBackgroundFetchResult.newData)
		  
	  }
	  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		  print("Unable to register for remote notifications: \(error.localizedDescription)")
	  }
	  // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
	  // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
	  // the FCM registration token.
	  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		  // With swizzling disabled you must set the APNs token here.
		  // Messaging.messaging().apnsToken = deviceToken
		
		  
		  var token = ""
		  for i in 0..<deviceToken.count {
			  token = token + String(format: "%2.2hhx", [deviceToken[i]])
		  }
	  
		  sharedTokenData[DEVICE_TOKEN_REF] = token
		  InstanceID.instanceID().instanceID { (instanid, error) in
			  if error != nil {
				  self.sharedTokenData[FCT_REF] = ""
			  }else {
				  self.sharedTokenData[FCT_REF] = instanid?.token
			  }
			  
		  }
		DataService.getDeviceTOkens(uid: DataService.uid) { (status, result) in
			  if status {
				  if result != self.sharedTokenData[FCT_REF] && self.sharedTokenData[FCT_REF] != "" {
					  //refresh the fcm here
					  DataService.sendTokens()
				  }
			  }
		  }
		  
	  }
	  //push notification end
}

@available(iOS 10, *)
extension AppDelegate:UNUserNotificationCenterDelegate {
 
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		//this functions is triggered when user on foregrand
		
      //  let userInfo = notification.request.content.userInfo
        
        // Print full message.
        // Change this to your preferred presentation option

		completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
		//this functions is triggered when user on bacground
		
          let userInfo = response.notification.request.content.userInfo

		completionHandler()
    }
    
    
}
