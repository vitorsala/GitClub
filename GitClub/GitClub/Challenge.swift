//
//  Challenge.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 28/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class Challenge: NSManagedObject {

    @NSManaged var challengeDescription: String
    @NSManaged var hasLabel: Label
    @NSManaged var partOfProject: Project

}
