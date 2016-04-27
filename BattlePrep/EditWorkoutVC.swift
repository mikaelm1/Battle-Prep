//
//  EditWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class EditWorkoutVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutTitleField: UITextField!
    
    var user: User!
    var workout: Workout!
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
    
    // MARK: - Segue
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if workout == nil {
            showAlert("Create a workout before adding exercises.")
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! EditExerciseVC
        vc.workout = workout
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

    @IBAction func updateButtonPressed(sender: AnyObject) {
        if let name = workoutTitleField.text where name != "" {
            workout!.setValue(name, forKey: "name")
            
            CoreDataStackManager.sharedInstance.saveContext()
        } else {
            showAlert("Please enter a name for the workout to update it.")
        }
    }
    
    @IBAction func beginButtonPressed(sender: AnyObject) {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("BeginWorkoutVC") as! BeginWorkoutVC
            vc.workout = workout
            navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
