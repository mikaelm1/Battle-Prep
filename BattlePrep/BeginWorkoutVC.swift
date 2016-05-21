//
//  BeginWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import CoreData
import Instructions

class BeginWorkoutVC: UIViewController, CoachMarksControllerDelegate, CoachMarksControllerDataSource {
    
    //@IBOutlet weak var exerciseLabel: UILabel!
    //@IBOutlet weak var repsLabeL: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    var doneButton: UIBarButtonItem!
    var currentExerciseCard: ExerciseCard!
    
    var workout: Workout!
    var exercisesCompleted = [String: Double]()
    var currentExercise: Exercise!
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        doneButton = UIBarButtonItem(title: "Finish", style: .Plain, target: self, action: #selector(BeginWorkoutVC.finishButtonPressed))
        navigationItem.setLeftBarButtonItem(doneButton, animated: false)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentExercise = getRandomExercise()
        currentExerciseCard = createCardFromNib()
        currentExerciseCard.center = AnimationEngine.offScreenRightPosition
        currentExerciseCard.frame = fitCardToScreen()
        
        currentExerciseCard.exerciseLabel.text = currentExercise.name
        currentExerciseCard.repsLabel.text = "Reps: \(Int(currentExercise.repetitions))"
        
        view.addSubview(currentExerciseCard)
        
        let pos = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.5, y: UIScreen.mainScreen().bounds.height * 0.4)
        AnimationEngine.animateToPosition(currentExerciseCard, position: pos) { (animation, finished) in
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupCoachMarks()
    }
    
    // MARK: - Helper methods
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func fitCardToScreen() -> CGRect {
        return CGRectMake(UIScreen.mainScreen().bounds.width * 0.05, UIScreen.mainScreen().bounds.height * 0.1, UIScreen.mainScreen().bounds.width * 0.9, UIScreen.mainScreen().bounds.height * 0.4)
    }
    
    func setupCard() {
        
    }
    
    func createCardFromNib() -> ExerciseCard {
        return NSBundle.mainBundle().loadNibNamed("ExerciseCard", owner: self, options: nil)[0] as! ExerciseCard
    }
    
    func showAlert(message: String) {
        let ac = UIAlertController(title: "Finish Workout?", message: message, preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .Default) { (action) in
            
            performUpdatesOnMain({ 
                self.updateWorkoutHistory()
            })
            
            self.performSegueWithIdentifier("showCharts", sender: nil)
        }
        
        let noAction = UIAlertAction(title: "No", style: .Default) { (action) in
            // do something
        }
        
        ac.addAction(yesAction)
        ac.addAction(noAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func saveExercise(exercise: Exercise) {
        let name = exercise.name
        let value = exercise.repetitions
        if let _ = exercisesCompleted[name] { // dictionary key not nil
            exercisesCompleted[name]! += value
        } else {
            exercisesCompleted[name] = value
        }
        
    }
    
    func updateWorkoutHistory() {
        
        for (name, value) in exercisesCompleted {
            let currentDate = NSDate()
            let _ = WorkoutHistory(name: name, repetitions: value, date: currentDate, workout: workout, context: sharedContext)
            
            CoreDataStackManager.sharedInstance.saveContext()
        }
    }
    
    func showExerciseCard(exercise: Exercise) {
        let cardToRemove = currentExerciseCard
        
        AnimationEngine.animateToPosition(cardToRemove, position: AnimationEngine.offScreenLeftPosition) { (animation, finished) in
            cardToRemove.removeFromSuperview()
        }
        
        currentExerciseCard = createCardFromNib()
        currentExerciseCard.center = AnimationEngine.offScreenRightPosition
        currentExerciseCard.frame = fitCardToScreen()
        //currentExerciseCard.hidden = true
        
        currentExerciseCard.exerciseLabel.text = exercise.name
        currentExerciseCard.repsLabel.text = "Reps: \(Int(exercise.repetitions))"
        
        view.addSubview(currentExerciseCard)
        
        let pos = CGPoint(x: UIScreen.mainScreen().bounds.width * 0.5, y: UIScreen.mainScreen().bounds.height * 0.4)
        AnimationEngine.animateToPosition(currentExerciseCard, position: pos) { (animation, finished) in
        }
        
    }
    
//    func showExercise(exercise: Exercise) {
//        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
//            
//            self.exerciseLabel.alpha = 0.0
//            self.repsLabeL.alpha = 0.0
//            }, completion: {
//                (finished: Bool) -> Void in
//                
//                self.exerciseLabel.text = exercise.name
//                self.repsLabeL.text = "\(Int(exercise.repetitions))"
//                
//                UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
//                    self.exerciseLabel.alpha = 1.0
//                    self.repsLabeL.alpha = 1.0
//                    }, completion: nil)
//        })
//
//    }
    
    func getRandomExercise() -> Exercise {
        let exercises = Array(workout.exercises)
        let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
        return exercises[randomIndex] as! Exercise
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        saveExercise(currentExercise)
        currentExercise = getRandomExercise()
        
        showExerciseCard(currentExercise)
        //showExercise(currentExercise)
        //print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        currentExercise = getRandomExercise()
        
        showExerciseCard(currentExercise)
        //showExercise(currentExercise)
        //print("Exercise count: \(exercisesCompleted.count)")
    }

    
    func finishButtonPressed(sender: UIButton) {
        showAlert("Are you sure you want to end the current workout?")
    }
    
    @IBAction func showProgressPressed(sender: AnyObject) {
        performSegueWithIdentifier("seeProgress", sender: nil)
        
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let tabvc = segue.destinationViewController as! UITabBarController
        
        let pieVC = tabvc.viewControllers?.first as! PieChartVC
        pieVC.exercises = exercisesCompleted
        pieVC.screenTitle = Constants.currentWorkout
        
        let barVC = tabvc.viewControllers![1] as! BarChartVC
        barVC.exercises = exercisesCompleted
        barVC.screenTitle = Constants.currentWorkout
        
        if segue.identifier == "showCharts" {

            pieVC.checkingProgress = false
            barVC.checkingProgress = false
        } else {
            pieVC.checkingProgress = true
            barVC.checkingProgress = true 
        }
        
    }
    
    // MARK: - Coach Marks
    
    let coachMarksController = CoachMarksController()
    var showingInstructions = false
    
    let nextButtonText = "Ok"
    let text1 = "Training has begun!"
    let text2 = "Tap here if you did the exercise..."
    let text3 = "...or here if you skipped it."
    let text4 = "Once you've had enough training, tap here to view your stats and end your workout."
    
    func instructionsWatched() {
        NSUserDefaults.standardUserDefaults().setObject(true, forKey: Constants.alreadyWatched)
    }
    
    func setupCoachMarks() {
        if Constants.showingInstructions {
            coachMarksController.dataSource = self
            coachMarksController.delegate = self
            coachMarksController.allowOverlayTap = false
            
            coachMarksController.startOn(self)
            
            doneButton.enabled = false
            
            instructionsWatched() 
                        
        } else {
            Constants.showingInstructions = false
            
            doneButton.enabled = true
        }
        
    }
    
    func numberOfCoachMarksForCoachMarksController(coachMarksController: CoachMarksController) -> Int {
        return 4
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        
        switch index {
        case 0:
            return coachMarksController.coachMarkForView(self.navigationController?.navigationBar) { (frame: CGRect) -> UIBezierPath in
                // This will make a cutoutPath matching the shape of
                // the component (no padding, no rounded corners).
                return UIBezierPath(rect: frame)
            }

        case 1:
            return coachMarksController.coachMarkForView(nextButton)
        case 2:
            return coachMarksController.coachMarkForView(skipButton)
        case 3:
            doneButton.enabled = true 
            return coachMarksController.coachMarkForView(doneButton.valueForKey("view") as? UIView)
        default:
            return coachMarksController.coachMarkForView()
        }
        
    }
    
    func coachMarksController(coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.defaultCoachViewsWithArrow(true, arrowOrientation: coachMark.arrowOrientation)
        
        switch index {
        case 0:
            coachViews.bodyView.hintLabel.text = text1
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 1:
            coachViews.bodyView.hintLabel.text = text2
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 2:
            coachViews.bodyView.hintLabel.text = text3
            coachViews.bodyView.nextLabel.text = nextButtonText
        case 3:
            coachViews.bodyView.hintLabel.text = text4
            coachViews.bodyView.nextLabel.text = nextButtonText
        default:
            break
        }
        return (coachViews.bodyView, coachViews.arrowView)
    }
    


    

}
