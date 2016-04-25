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
    var exercisesCompleted = [Exercise]()


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
        saveExercise(exercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    func saveExercise(exercise: Exercise) {
        exercisesCompleted.append(exercise)
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
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        exercisesCompleted.removeLast()
        let exercise = getRandomExercise()
        showExercise(exercise)
        print("Exercise count: \(exercisesCompleted.count)")
    }
    
    @IBAction func endButtonPressed(sender: UIButton) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("PieChartVC") as! PieChartVC
        vc.exercises = exercisesCompleted
        
        let tabvc = UITabBarController()
        tabvc.setViewControllers([vc], animated: true)
        
        //navigationController?.pushViewController(vc, animated: true)
        presentViewController(tabvc, animated: true, completion: nil)
    }

    

}
