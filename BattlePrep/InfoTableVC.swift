//
//  InfoTableVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/28/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class InfoTableVC: UITableViewController {
    
    let tableData = ["Guide", "Credits"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 80
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell") as! InfoCell
        cell.nameLabel.text = tableData[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("InfoDetailVC") as! InfoDetailVC
        
        vc.purpose = tableData[indexPath.row]
        print("")
        navigationController?.pushViewController(vc, animated: true)
        
    }

    

}
