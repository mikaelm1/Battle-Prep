//
//  LoginVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!
    @IBOutlet weak var signInButton: MaterialButton!
    @IBOutlet weak var facebookButton: MaterialButton!
    @IBOutlet weak var twitterButton: MaterialButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpFields()
        setUIEnabled(true)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // If user already logged in before and didn't log out, don't make the sign in again. Log them in automatically
        alreadyLoggedIn()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    // MARK: FetchRequest
    
    func executeFetchForUsers() -> [User] {
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
        } catch {
            print("Fetch Request FAILED.")
            return [User]()
        }
    }
    
    func getUser(email: String) -> User {
        let users = executeFetchForUsers()
        print("Count of users fetched: \(users.count)")
        if users.count > 0 {
            for user in users {
                if user.email == email {
                    print("Found the user")
                    return user
                }
            }
        }
        return createUser(email, name: nil)
    }
    
    func createUser(email: String, name: String?) -> User {
        if let name = name {
            let user = User(email: email, name: name, context: sharedContext, workouts: nil)
            CoreDataStackManager.sharedInstance.saveContext()
            return user
        }
        let user = User(email: email, name: nil, context: sharedContext, workouts: nil)
        CoreDataStackManager.sharedInstance.saveContext()
        return user
    }
    
    // MARK: - Helper methods
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            // do something
        }))
        presentViewController(ac, animated: true) { 
            // do something 
        }
    }
    
    func setUpFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.becomeFirstResponder()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func goToMainMenu(user: User) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("WorkoutsTableVC") as! WorkoutsTableVC
        vc.user = user
        
        let nc = UINavigationController(rootViewController: vc)
        presentViewController(nc, animated: true, completion: nil)
        
    }
    
    func saveUserLogin(email: String) {
        NSUserDefaults.standardUserDefaults().setObject(email, forKey: Constants.lastLoggedIn)
        print("Saved last logged in")
    }
    
    func alreadyLoggedIn() {
        if let email = NSUserDefaults.standardUserDefaults().objectForKey(Constants.lastLoggedIn) as? String {
            print("Last logged in email: \(email)")
            let user = getUser(email)
            goToMainMenu(user)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true 
    }
    
    // MARK: - Actions

    @IBAction func signInButtonPressed(sender: UIButton) {
        setUIEnabled(false)
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            FirebaseClient.sharedInstance.signInUser(email, password: password, completionHandler: { (success, error) in
                
                if let error = error {
                    performUpdatesOnMain({
                        self.setUIEnabled(true)
                        print("Error description: \(error.description)")
                        switch error.code {
                        case -5, -6:
                            self.showAlert("Please enter a valid email and password.")
                        case -15:
                            self.showAlert("There was a problem connecting to the Internet. Please try again later.")
                        default:
                            self.showAlert("There was an error logging in. Please try again later.")
                        }
                    })
                    
                } else if success {
                    performUpdatesOnMain({ 
                        self.setUIEnabled(true)
                        let user = self.getUser(email)
                        self.saveUserLogin(email)
                        self.goToMainMenu(user)
                    })
                    
                }
            })
        } else {
            // TODO: Unable to get email or password from fields
        }
    }
    
    @IBAction func facebookLoginPressed(sender: UIButton) {
        
        setUIEnabled(false)
        FirebaseClient.sharedInstance.attempFacebookLogin(self) { (success, error, result) in
            
            if let error = error {
                performUpdatesOnMain({ 
                    self.setUIEnabled(true)
                    print("Facebook error: \(error.description)")
                    self.showAlert("There was an error logging in with Facebook")
                })
            } else if result != nil {
                let email = result!["email"] as! String
                print("Got email from Facebook: \(email)")
                performUpdatesOnMain({ 
                    self.setUIEnabled(true)
                    let user = self.getUser(email)
                    self.goToMainMenu(user)
                })
            }
        }
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




