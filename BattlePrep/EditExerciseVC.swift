//
//  CreateExerciseVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class EditExerciseVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    
    var workout: Workout!
    var exercise: Exercise?
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseField.delegate = self
        exerciseField.becomeFirstResponder()
        repsField.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if exercise != nil {
            exerciseField.text = exercise!.name
            repsField.text = "\(Int(exercise!.repetitions))"
        }
        
        print("The name of the workout for this exercise: \(workout.name)")
    }
    
    // MARK: - Text field delegate
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string.characters.count == 0 {
            return true
        }
        if textField.tag == 1 { // reps field
            if Int(string) == nil {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Helper methods
    
    func getName() -> String? {
        if let name = exerciseField.text where name != "" {
            return name
        }
        return nil
    }
    
    func getReps() -> Double? {
        if let reps = repsField.text where reps != "" {
            let result = Double(reps)
            return result
        }
        return nil
    }
    
    func displayAlert(message: String) {
        let ac = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            // do something
        }))
        presentViewController(ac, animated: true, completion: nil)
    }
        
    // MARK: - Actions
    
    @IBAction func createExercisePressed(sender: AnyObject) {
        if let name = getName(), let reps = getReps() {
            
            if exercise != nil {
                exercise!.setValue(name, forKey: "name")
                exercise!.setValue(reps, forKey: "repetitions")
            } else {
                let exercise = Exercise(name: name, repetitions: reps, workout: workout, context: sharedContext)
                
                exercise.workout = workout
            }
            print("Saving the exercise in core data.")
            
            CoreDataStackManager.sharedInstance.saveContext()
            
            navigationController?.popViewControllerAnimated(true)
        } else {
            displayAlert("Enter the name of the exercise and the repetitions you want to do for it.")
        }
    }

    

}
