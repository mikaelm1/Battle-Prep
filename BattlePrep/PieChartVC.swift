//
//  PieChartVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import Charts

class PieChartVC: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var exercises: [String: Double]!
    var workoutHist: WorkoutHistory!
    var checkingProgress = true
    
    var screenTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.toolbarHidden = true
        navigationController?.navigationBarHidden = true

        setUpBar()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadChart()
        navBar.topItem?.title = screenTitle
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func loadChart() {
        
        if exercises.count > 0 {
            var data = [String]()
            var values = [Double]()
            for (key, value) in exercises {
                data.append(key)
                values.append(value)
            }
            setChart(data, values: values)
        } else  {
            pieChartView.noDataText = Constants.noDataText
            
        }
        
    }
    
    func setUpBar() {
    
        navBar.barStyle = .Black
        navBar.barTintColor = Constants.navBlueColor
        navBar.tintColor = UIColor.whiteColor()
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        tabBarController?.tabBar.barTintColor = Constants.navBlueColor
        tabBarController?.tabBar.tintColor = UIColor.whiteColor()
        
        if checkingProgress {
            let btn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(PieChartVC.backButtonPressed))
            navItem.leftBarButtonItem = btn
        } else {
            let btn = UIBarButtonItem(title: "Home", style: .Plain, target: self, action: #selector(PieChartVC.homeButtonPressed))
            navItem.leftBarButtonItem = btn
        }
    }

    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(yVals: dataEntries, label: "Exercises")
        
        pieChartView.noDataText = Constants.noDataText
        
        chartDataSet.valueFormatter?.maximumFractionDigits = 0
        chartDataSet.colors = [Constants.blueColor, Constants.redColor, Constants.greenColor, Constants.yellowColor]
        
        chartDataSet.valueTextColor = UIColor.blackColor()
        
        pieChartView.animate(xAxisDuration: 2.0, easingOption: .EaseInCirc)
        pieChartView.descriptionText = ""
        
        let chartData = PieChartData(xVals: dataPoints, dataSet: chartDataSet)
        pieChartView.data = chartData
        
    }
    
    // MARK: - Button methods 
    
    func homeButtonPressed() {
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func backButtonPressed() {
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false
        navigationController?.popViewControllerAnimated(true)
    }


    

}
