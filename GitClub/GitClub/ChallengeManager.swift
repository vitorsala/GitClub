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
        return NSEntityDescription.insertNewObjectForEntityForName(ChallengeManager.entityName, inManagedObjectContext: coreData.managedObjectContext!) as! GitClub.Challenge
    }

    func Challenge() -> Array<GitClub.Challenge>?{
        return coreData.fetchData(ChallengeManager.entityName, predicate: NSPredicate(format: "TRUEPREDICATE")) as? Array<GitClub.Challenge>
    }

    func Challenge(predicate : NSPredicate) -> Array<GitClub.Challenge>?{
        return coreData.fetchData(ChallengeManager.entityName, predicate: predicate) as? Array<GitClub.Challenge>
    }

    func save(){
        coreData.saveContext()
    }

    func delete(project: GitClub.Challenge){
        coreData.managedObjectContext?.deleteObject(project)
    }

}