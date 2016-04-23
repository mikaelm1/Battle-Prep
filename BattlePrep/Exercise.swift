//
//  Exercise.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/23/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class Exercise: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var repetitions: Double
    @NSManaged var workout: Workout
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, repetitions: Double, workout: Workout, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Exercise", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.repetitions = repetitions
        self.workout = workout
    }
    
}
