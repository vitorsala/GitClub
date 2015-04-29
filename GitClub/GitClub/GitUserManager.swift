//
//  EntityManager.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 29/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class GitUserManager {

    static let sharedInstance = GitUserManager()
    static let entityName = "GitUser"

    let coreData = CoreDataPersistence.sharedInstance

    private init(){}

    func newGitUser() -> GitClub.GitUser{
        return NSEntityDescription.insertNewObjectForEntityForName(GitUserManager.entityName, inManagedObjectContext: coreData.managedObjectContext!) as! GitClub.GitUser
    }

    func GitUser() -> Array<GitClub.GitUser>{
        return coreData.fetchData(GitUserManager.entityName, predicate: NSPredicate(format: "TRUEPREDICATE")) as! Array<GitClub.GitUser>
    }

    func GitUser(predicate : NSPredicate) -> Array<GitClub.GitUser>{
        return coreData.fetchData(GitUserManager.entityName, predicate: predicate) as! Array<GitClub.GitUser>
    }

    func save(){
        coreData.saveContext()
    }

}