//
//  FirebaseClient.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/22/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import Firebase

typealias CompletionHandler = (success: Bool, error: NSError?) -> Void

class FirebaseClient {
    
    static let sharedInstance = FirebaseClient()
    
    let ref = Firebase(url: Constants.firebaseURL)
    
    func createUser(email: String, password: String, completionHandler: CompletionHandler) {
        
        ref.createUser(email, password: password) { (error, result) in
        
            if error != nil {
                completionHandler(success: false, error: error)
            } else {
                print("Result from creating user: \(result)")
                completionHandler(success: true, error: nil)
            }
            
        }
        
    }
    
}
