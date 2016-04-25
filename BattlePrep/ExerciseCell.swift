//
//  ExerciseCell.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell {
    
    @IBOutlet weak var exerciseView: UIView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        exerciseView.layer.cornerRadius = 4.0
        exerciseView.clipsToBounds = true 
    }

}
