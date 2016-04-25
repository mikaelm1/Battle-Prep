//
//  CreateExerciseVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class CreateExerciseVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var exerciseField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    
    var workout: Workout!
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        exerciseField.delegate = self
        repsField.delegate = self

    }
    
    // MARK: - Text field delegate
    
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
            let _ = Exercise(name: name, repetitions: reps, workout: workout, context: sharedContext)
            
            CoreDataStackManager.sharedInstance.saveContext()
            
            navigationController?.popViewControllerAnimated(true)
        } else {
            displayAlert("Enter the name of the exercise and the repetitions you want to do for it.")
        }
    }

    

}
