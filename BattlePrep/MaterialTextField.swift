//
//  MaterialTextField.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/21/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: Constants.shadowColor, green: Constants.shadowColor, blue: Constants.shadowColor, alpha: 1).CGColor
        layer.borderWidth = 1.0
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }

}
