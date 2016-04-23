//
//  GCDBlackBox.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/23/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import Foundation

func performUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) { 
        updates()
    }
}
