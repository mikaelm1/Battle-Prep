//
//  CreateWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/24/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData

class CreateWorkoutVC: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var workoutTitleField: UITextField!
    
    var user: User!
    var workout: Workout?
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        if self.workout != nil {
            let fetchRequest = NSFetchRequest(entityName: "Exercise")
            fetchRequest.sortDescriptors = []
            fetchRequest.predicate = NSPredicate(format: "workout == %@", self.workout!)
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.sharedContext, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController.delegate = self
            return fetchedResultsController
        }
        return NSFetchedResultsController()
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        executeFetch()
        //tableView.reloadData()
        
        workoutTitleField.textAlignment = .Center
        if workout != nil {
            workoutTitleField.text = workout!.name
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(CreateWorkoutVC.editButtonPressed))
        
    }
    
    // MARK: - Helper methods
    
    func editButtonPressed() {
        tableView.setEditing(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(CreateWorkoutVC.doneButtonPressed))        
    }
    
    func doneButtonPressed() {
        tableView.setEditing(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(CreateWorkoutVC.editButtonPressed))
    }
    
    func configureCell(cell: ExerciseCell, exercise: Exercise) {
        cell.exerciseLabel.text = exercise.name
        cell.repsLabel.text = "\(Int(exercise.repetitions))"
    }
    
    func executeFetch() {
        if workout != nil {
            print("Attempting execute. Workout not nil")
            do {
                try fetchedResultsController.performFetch()
            } catch {
                print("Unable to perform fetch")
            }
        }
        
    }
    
    func saveButtonPressed() {
        if let name = workoutTitleField.text where name != "" {
            if workout == nil {
                workout = Workout(name: name, user: user, context: sharedContext, exercises: nil)
            } else {
                workout?.setValue(name, forKey: "name")
            }
            
            CoreDataStackManager.sharedInstance.saveContext()
        } else {
            showAlert("Please enter a name for the workout to save it.")
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
        vc.workout = workout!
    }
    
    // MARK: - Table view delegate and datasource 
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1 
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if workout != nil {
            let sectionInfo = fetchedResultsController.sections![section]
            print("Number of rows: \(sectionInfo.numberOfObjects)")
            return sectionInfo.numberOfObjects
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("ExerciseCell") as? ExerciseCell {
            if workout != nil {
                let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
                configureCell(cell, exercise: exercise)
                
                return cell
            }
        }
        return UITableViewCell() 
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let exercise = fetchedResultsController.objectAtIndexPath(indexPath) as! Exercise
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("EditExerciseVC") as! EditExerciseVC
        vc.exercise = exercise
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("deleting")
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
            print("inserted Section")
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
            if workout != nil {
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

    @IBAction func beginButtonPressed(sender: UIButton) {
        if workout != nil && workout?.exercises.count > 0 {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("BeginWorkoutVC") as! BeginWorkoutVC
            vc.workout = workout
            navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlert("Create a workout with at least one exericse before beginning.")
        }
        
        
    }
    

}
