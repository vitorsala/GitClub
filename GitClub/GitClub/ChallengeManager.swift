//
//  EntityManager.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 29/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class ChallengeManager {

    static let sharedInstance = ChallengeManager()
    static let entityName = "Challenge"

    let coreData = CoreDataPersistence.sharedInstance

    private init(){}

    func newChallenge() -> GitClub.Challenge{
        return NSEntityDescription.insertNewObjectForEntityForName(GitUserManager.entityName, inManagedObjectContext: coreData.managedObjectContext!) as! GitClub.Challenge
    }

    func Challenge() -> Array<GitClub.Challenge>{
        return coreData.fetchData(GitUserManager.entityName, predicate: NSPredicate(format: "TRUEPREDICATE")) as! Array<GitClub.Challenge>
    }

    func Challenge(predicate : NSPredicate) -> Array<GitClub.Challenge>{
        return coreData.fetchData(GitUserManager.entityName, predicate: predicate) as! Array<GitClub.Challenge>
    }

    func save(){
        coreData.saveContext()
    }

}