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
    var exercisesCompleted = [Exercise]() {
        willSet {
            
        } didSet {
            print("New exercise list: \(oldValue.count)")
        }
    }
        

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
        
        let exercise = getRandomExercise()
        showExercise(exercise)
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
        let exercise = getRandomExercise()
        showExercise(exercise)
        exercisesCompleted.append(exercise)
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        let exercise = getRandomExercise()
        showExercise(exercise)
    }
    
    @IBAction func endButtonPressed(sender: UIButton) {
        
    }

    

}
