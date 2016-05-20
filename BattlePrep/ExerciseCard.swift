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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
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
        layer.cornerRadius = 5.0
        
        exerciseLabel.clipsToBounds = true
        repsLabel.clipsToBounds = true 
        
        //setNeedsLayout()
    }

}
