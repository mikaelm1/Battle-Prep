//
//  InfoCell.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/28/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        infoView.layer.cornerRadius = 4.0
        infoView.clipsToBounds = true 
    }

    

}
