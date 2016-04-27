//
//  WorkoutsTableVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class WorkoutsTableVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var user: User!
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Workout")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "user == %@", self.user)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("User: \(user.email)")
        executeFetch()
    }
    
    // MARK: - Helper methods
    
    func initialSetup() {
        title = "Workouts"
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = Constants.navBarColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationItem.rightBarButtonItem = editButtonItem()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: #selector(WorkoutsTableVC.logOut))
        
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.barTintColor = Constants.navBarColor
        navigationController?.toolbar.tintColor = UIColor.whiteColor()
    }
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Unable to perform fetch")
        }
    }
    
    func logOut() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constants.lastLoggedIn)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView.editing && self.tableView(tableView, canEditRowAtIndexPath: indexPath) {
            
        }
        let workout = fetchedResultsController.objectAtIndexPath(indexPath) as! Workout
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkoutCell") as! WorkoutCell
        cell.workoutLabel.text = workout.name
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let workout = fetchedResultsController.objectAtIndexPath(indexPath) as! Workout
            sharedContext.deleteObject(workout)
            CoreDataStackManager.sharedInstance.saveContext()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let workout = fetchedResultsController.objectAtIndexPath(indexPath) as! Workout
        let vc = storyboard?.instantiateViewControllerWithIdentifier("EditWorkoutVC") as! EditWorkoutVC
        vc.workout = workout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Fetched results controller delegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            print("Inserted Section")
        case .Delete:
            print("Deleted Section")
        case .Move:
            print("Moved Section")
        case .Update:
            print("Updated Section")
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            print("Inserting row")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            print("Deleting row")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            print("Updating row")
            let cell = tableView.cellForRowAtIndexPath(indexPath!) as! WorkoutCell
            let workout = controller.objectAtIndexPath(indexPath!) as! Workout
            configureCell(cell, workout: workout)
        case .Move:
            print("Moving row")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func configureCell(cell: WorkoutCell, workout: Workout) {
        cell.workoutLabel.text = workout.name
    }
    
    // MARK: - Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! NewWorkoutVC
        vc.user = user
        
    }
    
    
}









