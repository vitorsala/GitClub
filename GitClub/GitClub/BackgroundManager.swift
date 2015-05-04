//
//  BackgroundManager.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 03/05/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import UIKit

class BackgroundManager{
    static let sharedInstance = BackgroundManager()
    private init(){}

    var hasUpdate = false {
        didSet{
            if hasUpdate{
                self.notify()
                hasUpdate = false
            }
        }
    }

    @objc func updateGitData(){
        println("Background update fired!")
        GitManager.sharedInstance.checkGitRepositories(NSUserDefaults().stringForKey("username")!)

    }

    func notify(){
        println("WOW! UPDATE!")
        let app = UIApplication.sharedApplication()
        let notifications = app.scheduledLocalNotifications

        if notifications.count > 0{
            app.cancelAllLocalNotifications()
        }

        let localNotification = UILocalNotification()
        
        localNotification.fireDate = NSDate()
        localNotification.timeZone = NSTimeZone.defaultTimeZone()
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.alertBody = "Você tem uma atualização!"

        app.scheduleLocalNotification(localNotification)
    }
}