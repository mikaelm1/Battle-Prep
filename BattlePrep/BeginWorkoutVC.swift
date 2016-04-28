//
//  BeginWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class BeginWorkoutVC: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var repsLabeL: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    var workout: Workout!
    var exercisesCompleted = [String: Double]()
    var currentExercise: Exercise!
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Helper methods
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Finish Workout?", message: message, preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            performUpdatesOnMain({ 
                self.updateWorkoutHistory()
            })
            
            self.performSegueWithIdentifier("showCharts", sender: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            // do something
        }
        
        ac.addAction(yesAction)
        ac.addAction(noAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func saveExercise(exercise: Exercise) {
        let name = exercise.name
        let value = exercise.repetitions
        if let _ = exercisesCompleted[name] { // dictionary key not nil
            exercisesCompleted[name]! += value
        } else {
            exercisesCompleted[name] = value
        }
        
    }
    
    func updateWorkoutHistory() {
        
        for (name, value) in exercisesCompleted {
            let _ = WorkoutHistory(name: name, repetitions: value, workout: workout, context: sharedContext)
            
            CoreDataStackManager.sharedInstance.saveContext()
        }
    }
    
    func showExercise(exercise: Exercise) {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.exerciseLabel.alpha = 0.0
            self.repsLabeL.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                self.exerciseLabel.text = exercise.name
                self.repsLabeL.text = "\(Int(exercise.repetitions))"
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.exerciseLabel.alpha = 1.0
                    self.repsLabeL.alpha = 1.0
                    }, completion: nil)
        })

    }
    
    func getRandomExercise() -> Exercise {
        let exercises = Array(workout.exercises)
        let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
        return exercises[randomIndex] as! Exercise
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        saveExercise(currentExercise)
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func endButtonPressed(sender: UIButton) {
        showAlert("Are you sure you want to end the current workout?")
        
    }
    
    @IBAction func showProgressPressed(sender: AnyObject) {
        performSegueWithIdentifier("seeProgress", sender: nil)
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tabvc = segue.destinationViewController as! UITabBarController
        
        let pieVC = tabvc.viewControllers?.first as! PieChartVC
        pieVC.exercises = exercisesCompleted
        pieVC.screenTitle = Constants.currentWorkout
        
        let barVC = tabvc.viewControllers![1] as! BarChartVC
        barVC.exercises = exercisesCompleted
        barVC.screenTitle = Constants.currentWorkout
        
        if segue.identifier == "showCharts" {

            pieVC.checkingProgress = false
            barVC.checkingProgress = false
        } else {
            pieVC.checkingProgress = true
            barVC.checkingProgress = true 
        }
        
    }

    

}
