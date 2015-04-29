//
//  EntityManager.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 29/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class ProjectManager {

    static let sharedInstance = ProjectManager()
    static let entityName = "Project"

    let coreData = CoreDataPersistence.sharedInstance

    private init(){}

    func newProject() -> GitClub.Project{
        return NSEntityDescription.insertNewObjectForEntityForName(GitUserManager.entityName, inManagedObjectContext: coreData.managedObjectContext!) as! GitClub.Project
    }

    func Project() -> Array<GitClub.Project>{
        return coreData.fetchData(GitUserManager.entityName, predicate: NSPredicate(format: "TRUEPREDICATE")) as! Array<GitClub.Project>
    }

    func Project(predicate : NSPredicate) -> Array<GitClub.Project>{
        return coreData.fetchData(GitUserManager.entityName, predicate: predicate) as! Array<GitClub.Project>
    }

    func save(){
        coreData.saveContext()
    }
    
}