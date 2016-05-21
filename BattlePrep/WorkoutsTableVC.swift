//
//  WorkoutsTableVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData
import Instructions

class WorkoutsTableVC: UITableViewController, NSFetchedResultsControllerDelegate, CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    @IBOutlet weak var createWorkoutButton: UIBarButtonItem!
    
    let coachMarksController = CoachMarksController()
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Workout")
        fetchRequest.sortDescriptors = []
        //fetchRequest.predicate = NSPredicate(format: "user == %@", self.user)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCoachMarks()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //////print("User: \(user.email)")
        executeFetch()
        tableView.reloadData()
    }
    
    // MARK: - Helper methods
    
    func initialSetup() {
        title = "Workouts"
        
        navigationController?.navigationBar.barStyle = .Black
        navigationController?.navigationBar.barTintColor = Constants.navBlueColor
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        navigationItem.rightBarButtonItem = editButtonItem()
        
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.toolbar.barTintColor = Constants.navBlueColor
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
        
        if Constants.showingInstructions {
            print("TRUE")
            coachMarksController.showNext()
        }
        
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
        if segue.identifier == "showInfo" {
            // do nothing 
        } else {
            let vc = segue.destinationViewController as! NewWorkoutVC
        }
    }
    
    // MARK: - Coach Marks
    
    //var showingInstructions = false
    
    let nextButtonText = "Ok"
    let text1 = "This is where you can add workouts or select one to begin exercising."
    
    func setupCoachMarks() {
        if NSUserDefaults.standardUserDefaults().objectForKey(Constants.alreadyWatched) != nil {
            Constants.showingInstructions = true
            coachMarksController.dataSource = self
            coachMarksController.delegate = self
            coachMarksController.allowOverlayTap = false
            
            //let skipView = CoachMarkSkipDefaultView()
            //skipView.setTitle("Skip", forState: .Normal)
            //coachMarksController.skipView = skipView
            
            coachMarksController.startOn(self)
                        
            createWorkoutButton.enabled = false
            
        } else {
            Constants.showingInstructions = false
            
            createWorkoutButton.enabled = true 
        }
        
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 2
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.coachMarkForView(navigationController?.toolbar, bezierPathBlock: { (frame) -> UIBezierPath in
                return UIBezierPath(rect: frame)
            })
        case 1:
            return coachMarksController.coachMarkForView(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)))
        default:
            return coachMarksController.coachMarkForView()
        }
        
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)
        
        // For the coach mark at index 2, we disable the ability to tap on the
        // coach mark to get to the next one, forcing the user to perform
        // the appropriate action.
        switch(index) {
        case 1:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: false, arrowOrientation: coachMark.arrowOrientation)
            coachViews.bodyView.userInteractionEnabled = false
        default:
            coachViews = coachMarksController.defaultCoachViewsWithArrow(true, withNextText: true, arrowOrientation: coachMark.arrowOrientation)
        }
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = text1
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = "Choose this workout"
        default:
            break
        }
        return (coachViews.bodyView, coachViews.arrowView)
    }
    
    

    
    
}










