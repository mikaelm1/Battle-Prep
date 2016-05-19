//
//  ExerciseCard.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 5/19/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class ExerciseCard: UIView {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel! 
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func setupView() {
        layer.cornerRadius = 3.0
        layer.backgroundColor = Constants.navBlueColor.CGColor
        
        setNeedsLayout()
    }

}
