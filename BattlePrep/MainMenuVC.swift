//
//  MainMenuVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/22/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    
    @IBOutlet weak var beginButton: UIButton!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if user != nil {
            print("User's Name: \(user.name)")
        } else {
            print("User is nil")
        }
        
    }
    
    @IBAction func beginWorkout(sender: MaterialButton) {
        
    }
    
    @IBAction func createWorkout(sender: MaterialButton) {
        
    }
    
    @IBAction func viewStats(sender: MaterialButton) {
        
    }
    
    @IBAction func showGuide(sender: MaterialButton) {
        
    }

    

}
