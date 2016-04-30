//
//  WorkoutCell.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var workoutView: UIView!
    @IBOutlet weak var workoutLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        workoutView.layer.cornerRadius = 4
        workoutView.clipsToBounds = true
        
        workoutLabel.adjustsFontSizeToFitWidth = true 
    }



}
