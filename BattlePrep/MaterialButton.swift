//
//  MaterialButton.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/22/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class MaterialButton: UIButton {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: Constants.shadowColor, green: Constants.shadowColor, blue: Constants.shadowColor, alpha: 1).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0, 2.0)
    }

}
