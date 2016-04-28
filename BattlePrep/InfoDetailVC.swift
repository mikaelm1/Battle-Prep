//
//  InfoDetailVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/28/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class InfoDetailVC: UIViewController {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var purpose: String!
    
    let guide = "Create a workout by giving it a name. You can change the name by selecting the workout. Add exercises for each workout by selecting the workout and pressing the + button. Once you have your exercises, you can begin the workout. The exercises will be randomly shown and you can choose to either do the exercise or to skip it. Once you finish the workout, press the \"End Workout\" button. You can view the progress of your workout at anytime by pressing the \"View Progress\" button."
    
    let credits = "\"App Logo\" by mud, \"Bar Chart Icon\" by Francisca Arevalo, \"Pie Chart Icon\" by Simple Icons, \"Info Icon\" by Guillaume Bahri from the Noun Project.\n\nColor schemes for charts designed by Rebecca Bovert."

    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.sizeToFit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if purpose == "Guide" {
            infoLabel.text = guide
        } else if purpose == "Credits" {
            infoLabel.text = credits
        }
    }

    

}
