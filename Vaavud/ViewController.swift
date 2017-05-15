//
//  ViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 4/22/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var rootSize: CGSize!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        rootSize = self.view.bounds.size
//    }
    
    
//    func onLogin() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "loginYoga")
//        navigationController?.pushViewController(vc,animated: true)
//    }
//    
//    
//    func onSignUp() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "singUpYoga")
//        navigationController?.pushViewController(vc,animated: true)
//    }
}


class OldGraph : UIView {
    let lowY: CGFloat = 0
    let highY: CGFloat = 10
    let n = 100
    
    var readings = [CGFloat()]
    var reading: Double = 0 { didSet { addReading(value: reading) } }
    var average: Double = 0 { didSet { newAverage(value: average) } }
    var logScale: CGFloat = 0 { didSet { if logScale != oldValue { changedScale() } } }
    
    private var lineWidth: CGFloat = 3
    private let graphColor = UIColor.vaavudBlue()
    private let avgColor = UIColor.vaavudRed()
    private let textColor = UIColor.vaavudGray()
    
    private let graphShape = CAShapeLayer()
    private let avgShape = CAShapeLayer()
    private var labels = [UILabel]()
    private var labelLogScale = -1
    
    private var factor: CGFloat = 1
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        graphShape.strokeColor = graphColor.cgColor
        graphShape.fillColor = nil
        graphShape.lineJoin = kCALineJoinRound
        layer.addSublayer(graphShape)
        
        avgShape.anchorPoint = CGPoint(x: 0, y: 0.5)
        avgShape.strokeColor = avgColor.cgColor
        avgShape.fillColor = nil
        
        layer.addSublayer(avgShape)
        
        for _ in 0...10 {
            let label = UILabel()
            label.font = UIFont(name: "Roboto-Light", size: 14)
            label.textAlignment = .center
            label.text = "9999"
            label.textColor = textColor
            label.sizeToFit()
            addSubview(label)
            labels.append(label)
        }
        
        changedScale()
    }
    
    var insideFactor: CGFloat {
        return CGFloat(reading)/(factor*highY)
    }
    
    func changedScale() {
        factor = pow(2, logScale)
        
        let modScale = logScale.remainder(dividingBy: 1)
        let scale = 2/((1 + modScale)*CGFloat(labels.count - 1))
        let outside = ease(from: 0, to: -20,x: 0)
        
        for (i, label) in labels.enumerated() {
            label.center.y = bounds.height*(1 - CGFloat(i)*scale)
            label.alpha = min(i % 2 == 0 ? 1 : 1 - modScale, 1 - outside)
        }
        
        let intScale = Int(floor(logScale))
        
        if labelLogScale != intScale {
            labelLogScale = intScale
            
            for (i, label) in labels.enumerated() {
                let j = 2*i*Int(pow(2, Float(labelLogScale)))
                label.text = String(j)
            }
        }
    }
    
    func newAverage(value: Double) {
        CATransaction.setDisableActions(true)
        avgShape.position.y = yValue(reading: CGFloat(value))
    }
    
    func addReading(value: Double) {
        readings.append(CGFloat(value))
        
        let path = UIBezierPath()
        
        let iEnd = readings.count
        let iStart = max(iEnd - n, 0)
        
        path.move(to: CGPoint(x: 0, y: yValue(reading: readings[iStart])))
        
        for i in (iStart + 1)..<iEnd {
            path.addLine(to: CGPoint(x: xValue(i: i), y: yValue(reading: readings[i])))
        }
        
        graphShape.path = path.cgPath
    }
    
    func yValue(reading: CGFloat) -> CGFloat {
        let y = (highY - reading/factor)/(highY - lowY)
        return max(bounds.height*y - lineWidth/2, 0)
    }
    
    func xValue(i: Int) -> CGFloat {
        return bounds.width*CGFloat(i + n - readings.count)/CGFloat(n - 1)
    }
    
    override func layoutSubviews() {
        if bounds.width > 400 {
            lineWidth = 5
        }
        
        avgShape.bounds.size.height = 2*lineWidth
        graphShape.lineWidth = lineWidth
        avgShape.lineWidth = lineWidth
        
        graphShape.frame = bounds
        avgShape.frame.size.width = bounds.width
        
        let path = UIBezierPath()
        path.move(to: avgShape.bounds.midLeft)
        path.addLine(to: avgShape.bounds.midRight)
        
        avgShape.path = path.cgPath
    }
}

