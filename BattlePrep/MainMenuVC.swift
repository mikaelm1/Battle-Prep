//
//  MainMenuVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/22/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class MainMenuVC: UIViewController {
    
    @IBOutlet weak var beginButton: UIButton!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Main Menu"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if user != nil {
            print("User's Email: \(user.email)")
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
