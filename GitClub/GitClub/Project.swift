//
//  Project.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 30/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class Project: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var hasChallenge: NSSet


    func addChallenge(challenge:Challenge) {
        var hasChallenge = self.mutableSetValueForKey("hasChallenge")
        hasChallenge.addObject(challenge)
    }

    func removeChallenge(challenge:Challenge) {
        var hasChallenge = self.mutableSetValueForKey("hasChallenge")
        hasChallenge.removeObject(challenge)
    }

}
