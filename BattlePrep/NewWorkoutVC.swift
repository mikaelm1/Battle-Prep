//
//  NewWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/27/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class NewWorkoutVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!

    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameField.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            // do something
        }))
        
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if let name = nameField.text where name != "" {
            let _ = Workout(name: name, context: sharedContext, exercises: nil)
            CoreDataStackManager.sharedInstance.saveContext()
            navigationController?.popViewControllerAnimated(true)
        } else {
            showAlert("Please name the workout before saving it.")
        }
    }

    

}
