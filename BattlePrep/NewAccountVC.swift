//
//  NewAccountVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class NewAccountVC: UIViewController {
    
    @IBOutlet weak var nameTextField: MaterialTextField!
    @IBOutlet weak var emailTextField: MaterialTextField!
    @IBOutlet weak var passwordTextField: MaterialTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func createButtonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}




