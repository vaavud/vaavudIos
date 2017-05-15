//
//  SummaryViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/9/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import Charts
import FirebaseDatabase
import MapKit

class SummaryViewController: UIViewController {

    
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var lblWindAvg: UILabel!
    @IBOutlet weak var lblWindMax: UILabel!
    @IBOutlet weak var lblWindMaxUnit: UILabel!
    @IBOutlet weak var lblWindAvgUnit: UILabel!
    @IBOutlet weak var imgArrowWindDirection: UIImageView!
    
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblTimeHour: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var mapVIew: MKMapView!
    
    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var windChart: LineChartView!
    var sessionKey: String!

    
    @IBOutlet weak var circleDirection: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        circleDirection.layer.borderColor = UIColor.vaavudBlue().cgColor
        circleDirection.layer.borderWidth = 2
        circleDirection.layer.cornerRadius = 40
        circleDirection.clipsToBounds = true
        
        windChart.chartDescription?.text = "Powered by Vaavud."
        windChart.chartDescription?.textColor = .vaavudBlue()
        windChart.chartDescription?.enabled = true
        windChart.noDataText = "You need to provide data for the chart."
        
        
        
        let l = windChart.legend
        l.form = .line
        l.textColor = .vaavudGray()
        
        
        let xl = windChart.getAxis(.left)
        xl.labelTextColor = .vaavudRed()
        xl.drawGridLinesEnabled = true
        xl.enabled = true
        
        let yl = windChart.getAxis(.right)
        yl.enabled = false
        
        getPoints()
        getSession()
    }
    
    @IBAction func onGoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getSession() {
        FIRDatabase.database().reference().child("session").child(sessionKey).observeSingleEvent(of: .value, with: {
            
            if let session = Session(key: $0.key, data: $0.value as! [String:Any]) {
                self.lblLocationName.text = session.location?.name
                self.lblWindMax.text = convertWindSpeed(speed: session.windMax, withUnits: false)
                self.lblWindAvg.text = convertWindSpeed(speed: session.windMean, withUnits: false)
                if let direction = session.windDirection {
                    self.lblWindDirection.text = convertDirection(direction: direction)
                    let imgDirection = UIImage(named: "summaryDirection")?.rotated(by: Measurement(value: Double(direction),unit: .degrees))
                    self.imgArrowWindDirection.image = imgDirection
                }
                else {
                    self.lblWindDirection.text = ""
                    self.imgArrowWindDirection.isHidden = true
                }
                
                self.lblWindAvgUnit.text = Defaults[.windSpeed]
                self.lblWindMaxUnit.text = Defaults[.windSpeed]
            }
        })
    }
    
    
    func getPoints(){
        FIRDatabase.database().reference().child("wind").child(sessionKey).observeSingleEvent(of: .value, with: {
            
            let chartDataSet = self.createSet()
            let chartData = LineChartData(dataSet:chartDataSet)
            self.windChart.data = chartData
            
            let data = self.windChart.data
            let set = data?.getDataSetByIndex(0)
            
            for child in $0.children {
                if let c = child as? FIRDataSnapshot {
                    let val = c.value as! [String:Any]
                    let dataEntry = ChartDataEntry(x: Double(set!.entryCount), y: val["speed"] as? Double ?? 0 )
                    data?.addEntry(dataEntry, dataSetIndex: 0)
                }
            }
            data?.notifyDataChanged()
            self.windChart.notifyDataSetChanged()
        })
    }
    
    
    
    func createSet() -> LineChartDataSet {
        
        let lineChartDataSet = LineChartDataSet(values: [ChartDataEntry(x: 0, y: 0)], label: "Wind Speed")
        
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.setColor(.vaavudRed())
        lineChartDataSet.setDrawHighlightIndicators(true)
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = .vaavudRed()
        lineChartDataSet.fillAlpha = 0.65
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.circleRadius = 4
        lineChartDataSet.setCircleColor(.vaavudRed())
        
        return lineChartDataSet
    }


}
