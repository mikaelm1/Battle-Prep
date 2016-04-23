//
//  FirebaseClient.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/22/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit

typealias CompletionHandler = (success: Bool, error: NSError?) -> Void
typealias FBCompletionHandler = (success: Bool, error: NSError?, result: [String: AnyObject]?) -> Void

class FirebaseClient {
    
    static let sharedInstance = FirebaseClient()
    
    let ref = Firebase(url: Constants.firebaseURL)
    
    func createUser(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.createUser(email, password: password) { (error, result) in
        
            if error != nil {
                completionHandler(success: false, error: error)
            } else {
                completionHandler(success: true, error: nil)
            }
            
        }
        
    }
    
    func signInUser(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.authUser(email, password: password) { (error, authData) in
            
            if error != nil {
                completionHandler(success: false, error: error)
            } else {
                completionHandler(success: true, error: nil)
            }
        }
    }
    
    func attempFacebookLogin(viewController: UIViewController, completionHandler: FBCompletionHandler) {
        let fbLogin = FBSDKLoginManager()
        fbLogin.logInWithReadPermissions(["email"], fromViewController: viewController) { (result, error) in
            
            if error != nil {
                completionHandler(success: false, error: error, result: nil)
            } else if result.isCancelled {
                completionHandler(success: false, error: error, result: nil)
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { (error, authData) in
                    
                    if error != nil {
                        completionHandler(success: false, error: error, result: nil)
                    } else {
                        self.getFBUserEmail(accessToken, completionHandler: completionHandler)
                    }
                })
            }
        }
    }
    
    func getFBUserEmail(token: String, completionHandler: FBCompletionHandler) {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email"], tokenString: token, version: nil, HTTPMethod: "GET")
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            
            if error != nil {
                completionHandler(success: false, error: error, result: nil)
            } else {
                guard let result = result as? [String: AnyObject] else {
                    completionHandler(success: false, error: nil, result: nil)
                    return
                }
                completionHandler(success: true, error: nil, result: result)
            }
        }
    }
    
}






