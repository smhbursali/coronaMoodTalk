//
//  PublicListeners.swift
//  thisTime
//
//  Created by semih bursali on 11/6/19.
//  Copyright © 2019 semih bursali. All rights reserved.
//

import FirebaseFirestore

public var activeUserlistener:ListenerRegistration?
public var messageDatalistener:ListenerRegistration?
public var userOnlineStatusListenerForDM:ListenerRegistration?

public var chatNotificationListener:ListenerRegistration?
var chatNotificationInstance:chatNotification?

