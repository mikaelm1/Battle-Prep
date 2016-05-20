//
//  EditWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData
import Instructions

class EditWorkoutVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, CoachMarksControllerDataSource, CoachMarksControllerDelegate {

    @IBOutlet weak var beginWorkoutButton: UIBarButtonItem!
    @IBOutlet weak var addExerciseButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutTitleField: UITextField!
    
    var user: User!
    var workout: Workout!
    var allExercises = [String: Double]()
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Exercise")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "workout == %@", self.workout!)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        print("Fetch was successful")
        return fetchedResultsController
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        setUpFieds()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        executeFetch()
        tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(EditWorkoutVC.editButtonPressed))
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCoachMarks()
    }
    
    // MARK: - Helper methods
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setUpFieds() {
        workoutTitleField.delegate = self
        workoutTitleField.textAlignment = .Center
        workoutTitleField.text = workout.name
    }
    
    func editButtonPressed() {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(EditWorkoutVC.doneButtonPressed))
    }
    
    func doneButtonPressed() {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(EditWorkoutVC.editButtonPressed))
    }
    
    func configureCell(cell: ExerciseCell, exercise: Exercise) {
        cell.exerciseLabel.text = exercise.name
        cell.repsLabel.text = "\(Int(exercise.repetitions))"
    }
    
    func executeFetch() {
        
        print("Attempting execute. Workout not nil")
        print("Exercises count: \(workout?.exercises.count)")
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unable to perform fetch: \(error.debugDescription)")
        }
        
    }
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Invalid Entry", message: message, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
            // do something
        }))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    // MARK: Text field delegate 
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("textFieldDidEndEditing")
        if let name = workoutTitleField.text where name != "" {
            workout!.setValue(name, forKey: "name")
            
            CoreDataStackManager.sharedInstance.saveContext()
        } else {
            showAlert("Please enter a name for the workout to update it.")
        }
    }
    
    // MARK: - Segue
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if workout == nil && identifier == "editExercise" {
            showAlert("Create a workout before adding exercises.")
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "editExercise" {
            let vc = segue.destinationViewController as! EditExerciseVC
            vc.workout = workout
        } else if segue.identifier == "showAllHistory" {
            let tabvc = segue.destinationViewController as! UITabBarController
            
            let pieVC = tabvc.viewControllers?.first as! PieChartVC
            pieVC.exercises = allExercises
            pieVC.screenTitle = Constants.totalWorkout
            pieVC.checkingProgress = false
            
            let barVC = tabvc.viewControllers![1] as! BarChartVC
            barVC.exercises = allExercises
            barVC.screenTitle = Constants.totalWorkout
            barVC.checkingProgress = false 
        }
        
    }
    
    // MARK: Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Table view delegate and datasource 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell") as! ExerciseCell
        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        configureCell(cell, exercise: exercise)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("EditExerciseVC") as! EditExerciseVC
        vc.exercise = exercise
        vc.workout = workout
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if workout != nil {
                let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
                sharedContext.deleteObject(exercise)
                CoreDataStackManager.sharedInstance.saveContext()
            }
        } else if editingStyle == .Insert {
            
        }
    }
    
    // MARK: - FetchedResults delegate 
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
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
            print("INserting row")
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            print("Deleting row")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            print("Updating row")
            if workout != nil && workout?.exercises.count > 0 {
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! ExerciseCell
                let exercise = controller.objectAtIndexPath(indexPath!) as! Exercise
                configureCell(cell, exercise: exercise)
            }
            
        case .Move:
            print("Moving row")
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    // MARK: - Actions
    
    @IBAction func beginButtonPressed(sender: AnyObject) {
        if workout.exercises.count > 0 {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("BeginWorkoutVC") as! BeginWorkoutVC
            vc.workout = workout
            navigationController?.pushViewController(vc, animated: true)

        } else {
            showAlert("Add at least one exercise for \"\(workout.name)\" before beginning the workout.")
        }
        
        
    }
    
    @IBAction func chartButtonPressed(sender: AnyObject) {
        
        // The list of workout histories can have same names because when they are created, there is no check to see if they exist
        let workoutHist = fetchAllWorkoutHistory()
        
        if workoutHist.count == 0 {
            print("Something went wrong")
        } else {
            for hist in workoutHist {
                if let value = allExercises[hist.exerciseName] {
                    print("VALUE: \(value)")
                    // In case we already placed a History entity with the same name, we just need to update the value
                    let newValue = value + hist.exerciseReps
                    allExercises[hist.exerciseName] = newValue
                } else {
                    print("Putting in Dictionary for first time")
                    // If we haven't already added a History entity into our dictionary, then add it and its value
                    allExercises[hist.exerciseName] = hist.exerciseReps
                }
            }
            print("All exercises: \(allExercises)")
            
        }
        
        performSegueWithIdentifier("showAllHistory", sender: nil)

        
    }
    
    func fetchAllWorkoutHistory() -> [WorkoutHistory] {
        let fetchRequest = NSFetchRequest(entityName: "WorkoutHistory")
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "workout == %@", self.workout!)
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [WorkoutHistory]
        } catch let error as NSError {
            print("Failed to fetch history: \(error.debugDescription)")
            return [WorkoutHistory]()
        }
    }
    
    // MARK: - Coach Marks
    
    let coachMarksController = CoachMarksController()
    var showingInstructions = false
    
    let nextButtonText = "Ok"
    let text1 = "This is where you can edit existing exercises..."
    let text2 = "...or, create new exercises."
    let text3 = "Tap to begin the workout."
    
    func setupCoachMarks() {
        showingInstructions = true
        coachMarksController.dataSource = self
        coachMarksController.delegate = self
        coachMarksController.allowOverlayTap = false
        
        let skipView = CoachMarkSkipDefaultView()
        skipView.setTitle("Skip", forState: .Normal)
        
        coachMarksController.skipView = skipView
        coachMarksController.startOn(self)
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.coachMarkForView(tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)))
        case 1:
            return coachMarksController.coachMarkForView(addExerciseButton.valueForKey("view") as? UIView)
        case 2:
            return coachMarksController.coachMarkForView(beginWorkoutButton.valueForKey("view") as? UIView)
        default:
            return coachMarksController.coachMarkForView()
        }
        
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        var coachViews: (bodyView: CoachMarkBodyDefaultView, arrowView: CoachMarkArrowDefaultView?)
        
        // For the coach mark at index 3, we disable the ability to tap on the
        // coach mark to get to the next one, forcing the user to perform
        // the appropriate action.
        switch(index) {
        case 2:
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
            coachViews.bodyView.hintLabel.text = text2
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = text3
        default:
            break
        }
        return (coachViews.bodyView, coachViews.arrowView)
    }

    

}
