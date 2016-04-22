//
//  LoginVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    @IBOutlet weak var signInButton: MaterialButton!
    @IBOutlet weak var facebookButton: MaterialButton!
    @IBOutlet weak var twitterButton: MaterialButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    @IBAction func signInButtonPressed(sender: UIButton) {
    }
    
    @IBAction func facebookLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func twitterLoginPressed(sender: UIButton) {
        
    }
    
    @IBAction func signUpPressed(sender: UIButton) {
        
    }

}




