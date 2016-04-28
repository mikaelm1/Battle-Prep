//
//  NewAccountVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class NewAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    @IBOutlet weak var createButton: UIButton!
    
    var newEmail: String?
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.barTintColor = Constants.navBarColor
        
        setUpFields()
    }
    
    // MARK: - Helper Methods
    
    func setUpFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func showAlert(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            if title == "Success!" {
                if let new = self.newEmail {
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as! LoginVC
                    vc.newAccountEmail = new
                }

                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }))
        presentViewController(ac, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions

    @IBAction func createButtonPressed(sender: UIButton) {
        setUIEnabled(false)
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FirebaseClient.sharedInstance.createUser(email, password: password, completionHandler: { (success, error) in
                
                if let error = error {
                    print("Error code.description: \(error.description)")
                    switch error.code {
                    case -5:
                        self.showAlert("Error", message: "Please enter a valid email.")
                    case -6:
                        self.showAlert("Error", message: "You must enter a password to create an account.")
                    case -15:
                        self.showAlert("Error", message: "There was a problem connecting to the Internet. Try again later.")
                    case -9:
                        self.showAlert("Error", message: "There is already an account associated with that email.")
                    default:
                        self.showAlert("Error", message: "There was an error creating you account.")
                    }

                } else {
                    print("Created User. Now Log them in")
                    performUpdatesOnMain({ 
                        let _ = self.createUser(email, name: nil)
                        self.newEmail = email
                        self.showAlert("Success!", message: "Your account was succesfully created. Now log in to prepare for battle!")
                    })
                    
                }
            })
            
        } else {
            // TODO: - Handle emtpy fields
        }
        setUIEnabled(true)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createUser(email: String, name: String?) -> User {
        let user = User(email: email, name: nil, context: sharedContext, workouts: nil)
        CoreDataStackManager.sharedInstance.saveContext()
        return user
    }

    
    func setUIEnabled(enabled: Bool) {
        if enabled {
            createButton.enabled = true
        } else {
            createButton.enabled = false
        }
    }
    


}




