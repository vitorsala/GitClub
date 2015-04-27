//
//  Label.swift
//  GitClub
//
//  Created by Vitor Kawai Sala on 27/04/15.
//  Copyright (c) 2015 Wololo. All rights reserved.
//

import Foundation
import CoreData

class Label: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var partOfChallenge: NSSet

}
