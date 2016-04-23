//
//  Workout.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/23/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class Workout: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var user: User
    @NSManaged var exercises: NSSet
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, user: User, context: NSManagedObjectContext, exercises: [Exercise]?) {
        
        let entity = NSEntityDescription.entityForName("Workout", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.user = user 
    }
    
}
