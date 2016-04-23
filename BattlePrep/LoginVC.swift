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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFields()
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
        let nc = storyboard?.instantiateViewControllerWithIdentifier("MainMenuNav") as! UINavigationController
        presentViewController(nc, animated: true, completion: nil)
    }
    
    @IBAction func facebookLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func twitterLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        
    }

}




