//
//  User.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/23/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class User: NSManagedObject {
    
    @NSManaged var email: String
    @NSManaged var name: String
    @NSManaged var workouts: NSSet?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(email: String, name: String, context: NSManagedObjectContext, workouts: [Workout]?) {
        
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.email = email
        self.name = name
        
    }
    
}
