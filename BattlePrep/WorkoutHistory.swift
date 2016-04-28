//
//  WorkoutHistory.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/27/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class WorkoutHistory: NSManagedObject {
    
    @NSManaged var exerciseName: String
    @NSManaged var exerciseReps: Double
    @NSManaged var workout: Workout
    @NSManaged var dateCreated: NSDate
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, repetitions: Double, date: NSDate, workout: Workout, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("WorkoutHistory", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.exerciseName = name
        self.exerciseReps = repetitions
        self.workout = workout
    }
    
}
