//
//  CreateWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class CreateWorkoutVC: UIViewController {

    @IBOutlet weak var workoutTitleField: UITextField!
    
    var user: User!
    var workout: Workout?
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        workoutTitleField.textAlignment = .Center
        if workout != nil {
            workoutTitleField.text = workout!.name
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(CreateWorkoutVC.saveButtonPressed))
    }
    
    func saveButtonPressed() {
        if let name = workoutTitleField.text where name != "" {
            if workout == nil {
                workout = Workout(name: name, user: user, context: sharedContext, exercises: nil)
            } else {
                workout?.setValue(name, forKey: "name")
            }
            
            CoreDataStackManager.sharedInstance.saveContext()
        } else {
            showAlert("Please enter a name for the workout to save it.")
        }
    }
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            // do something
        }))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if workout == nil {
            showAlert("Create a workout before adding exercises.")
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! CreateExerciseVC
        vc.workout = workout!
    }
    
    // MARK: - Actions

    @IBAction func beginButtonPressed(sender: UIButton) {
        
    }
    

}
