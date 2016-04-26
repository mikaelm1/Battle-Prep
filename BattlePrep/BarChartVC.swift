//
//  BarChartVC.swift
//  BattlePrep
//
//  Created by Mikael Mukhsikaroyan on 4/25/16.
//  Copyright © 2016 MSquared. All rights reserved.
//

import UIKit
import Charts

class BarChartVC: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var exercises: [String: Double]!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
        
        print("Exercises in Bar Chart: \(exercises.count)")
        var data = [String]()
        var values = [Double]()
        for (key, value) in exercises {
            data.append(key)
            values.append(value)
        }
        setChart(data, values: values)
    }

    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries = [BarChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Repetitions")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        
        barChartView.data = chartData
        barChartView.xAxis.labelPosition = .Bottom
        
        chartDataSet.colors = ChartColorTemplates.colorful()
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInBack)
    }
    

}
