//
//  NewAccountVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class NewAccountVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: MaterialTextField!
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
    }
    
    // MARK: - Helper Methods
    
    func setUpFields() {
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func showAlert(message: String) {
        
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            print("Ok pressed")
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
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FirebaseClient.sharedInstance.createUser(email, password: password, completionHandler: { (success, error) in
                
                if let error = error {
                    print("Error code.description: \(error.description)")
                    switch error.code {
                    case -5:
                        self.showAlert("Please enter a valid email.")
                    case -6:
                        self.showAlert("You must enter a password to create an account.")
                    case -15:
                        self.showAlert("There was a problem connecting to the Internet. Try again later.")
                    default:
                        self.showAlert("There was an error creating you account.")
                        
                    }
                } else {
                    print("Created User. Now Log them in")
                    // TODO: User account created. Log them in
                }
            })
            
        } else {
            // TODO: - Handle emtpy fields
        }
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}




