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
    
    var exercises: [String: Double]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.toolbarHidden = true
        navigationController?.navigationBarHidden = true 

        print("Exercises in Pie Chart: \(exercises.count)")
        var data = [String]()
        var values = [Double]()
        for (key, value) in exercises {
            data.append(key)
            values.append(value)
        }
        setChart(data, values: values)
    }

    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(yVals: dataEntries, label: "Repetitions")
        let chartData = PieChartData(xVals: dataPoints, dataSet: chartDataSet)
        pieChartView.data = chartData
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        pieChartView.animate(xAxisDuration: 2.0, easingOption: .EaseInCirc)
        pieChartView.holeColor = UIColor.blueColor()
        
    }
    
    @IBAction func homeButtonPressed(sender: AnyObject) {
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false
        navigationController?.popToRootViewControllerAnimated(true)
    }

    

}
