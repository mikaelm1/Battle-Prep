//
//  BeginWorkoutVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit

class BeginWorkoutVC: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var repsLabeL: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    var workout: Workout!
    var exercisesCompleted = [String: Double]()
    var currentExercise: Exercise!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "chart")!.imageWithRenderingMode(.AlwaysOriginal)
        
        let btn = UIButton()
        btn.frame = CGRectMake(view.frame.size.width, 0, 40, 40)
        btn.setImage(image, forState: .Normal)
        btn.addTarget(self, action: #selector(BeginWorkoutVC.chartButtonPressed), forControlEvents: .TouchUpInside)
        
        let barbtn = UIBarButtonItem(customView: btn)
        navigationItem.setRightBarButtonItem(barbtn, animated: true)
        

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")
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
    
    func showExercise(exercise: Exercise) {
        exerciseLabel.text = exercise.name
        repsLabeL.text = "\(Int(exercise.repetitions))"
    }
    
    func getRandomExercise() -> Exercise {
        let exercises = Array(workout.exercises)
        let randomIndex = Int(arc4random_uniform(UInt32(exercises.count)))
        return exercises[randomIndex] as! Exercise
    }
    
    func chartButtonPressed() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        saveExercise(currentExercise)
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        saveExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        currentExercise = getRandomExercise()
        showExercise(currentExercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func endButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showCharts", sender: nil)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showCharts" {
            let tabvc = segue.destinationViewController as! UITabBarController
            let pieVC = tabvc.viewControllers?.first as! PieChartVC
            pieVC.exercises = exercisesCompleted
            
            let barVC = tabvc.viewControllers![1] as! BarChartVC
            barVC.exercises = exercisesCompleted 
            
        }
    }

    

}
