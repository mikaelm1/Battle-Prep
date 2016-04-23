//
//  LoginVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    @IBOutlet weak var signInButton: MaterialButton!
    @IBOutlet weak var facebookButton: MaterialButton!
    @IBOutlet weak var twitterButton: MaterialButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFields()
        setUIEnabled(true)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    // MARK: - Helper methods
    
    func showAlert(message: String) {
        
    }
    
    func setUpFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
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

    @IBAction func signInButtonPressed(sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FirebaseClient.sharedInstance.signInUser(email, password: password, completionHandler: { (success, error) in
                
                if let error = error {
                    print("Error description: \(error.description)")
                    switch error.code {
                    case -5, -6:
                        self.showAlert("Please enter a valid email and password.")
                    case -15:
                        self.showAlert("There was a problem connecting to the Internet. Please try again later.")
                    default:
                        self.showAlert("There was an error logging in. Please try again later.")
                    }
                } else if success {
                    let nc = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuNav") as! UINavigationController
                    self.presentViewController(nc, animated: true, completion: nil)
                }
            })
        }
        
        
    }
    
    @IBAction func facebookLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func twitterLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        
    }
    
    // MARK: - UI Methods
    
    func setUIEnabled(enabled: Bool) {
        
        signInButton.enabled = enabled
        signUpButton.enabled = enabled
        facebookButton.enabled = enabled
        twitterButton.enabled = enabled
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        
        if enabled {
            animateActivityIndicator(false)
            signUpButton.alpha = 1
            signInButton.alpha = 1
            facebookButton.alpha = 1
            twitterButton.alpha = 1
        } else {
            animateActivityIndicator(true)
            signUpButton.alpha = 0.5
            signInButton.alpha = 0.5
            facebookButton.alpha = 0.5
            twitterButton.alpha = 0.5
        }
    }
    
    func animateActivityIndicator(state: Bool) {
        if state {
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
        }
    }

}




