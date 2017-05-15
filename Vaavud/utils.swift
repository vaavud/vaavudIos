//
//  utils.swift
//  Vaavud
//
//  Created by Diego Galindo on 4/22/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import Foundation
import UIKit

typealias FireDictionary = [String:Any]


class DynamicItem: NSObject, UIDynamicItem {
    var bounds: CGRect { return CGRect(x: 0, y: 0, width: 10000, height: 10000) }
    var center = CGPoint() { didSet { centerCallback(center) } }
    var transform = CGAffineTransform.identity { didSet { transformCallback(transform) } }
    
    var animating = false
    
    let centerCallback: (CGPoint) -> ()
    let transformCallback: (CGAffineTransform) -> ()
    
    init(centerCallback: @escaping (CGPoint) -> (), transformCallback: @escaping (CGAffineTransform) -> () = { x in }) {
        self.centerCallback = centerCallback
        self.transformCallback = transformCallback
        super.init()
    }
}


extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x - size.width/2, y: center.y - size.height/2), size: size)
    }
    
    
    var midLeft: CGPoint { return CGPoint(x: minX, y: midY) }
    
    var midRight: CGPoint { return CGPoint(x: maxX, y: midY) }
    
}

func ease(x: CGFloat) -> CGFloat {
    return x < 0.5 ? 4*pow(x, 3) : pow(2*x - 2, 3)/2 + 1
}

func ease(from: CGFloat, to: CGFloat, x: CGFloat) -> CGFloat {
    return ease(x: clamp(x: (x - from)/(to - from)))
}

func clamp(x: CGFloat) -> CGFloat {
    if x < 0 {
        return 0
    }
    else if x > 1 {
        return 1
    }
    
    return x
}



extension UIColor {
    class func vaavudRed() -> UIColor {
        return UIColor(red:0.819, green:0.164 ,blue:0.184 , alpha:1.00)
    }
    
    class func vaavudBlue() -> UIColor {
        return UIColor(red:0, green:0.631 ,blue:0.882 , alpha:1.00)
    }
    
    class func vaavudGray() -> UIColor {
        return UIColor(red:0.501, green:0.545 ,blue:0.611 , alpha:1.00)
    }
}


extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}


enum WindSpeed: String {
    case mps = "m/s"
    case kmh = "km/h"
    case mph = "mph"
    case knots = "Knots"
    
    init(position: Int) {
        switch position {
        case 0:
            self = .kmh
        case 1:
            self = .mps
        case 2:
            self = .mph
        case 3:
            self = .knots
        default:
            self = .mps
        }
    }
    
    func index() -> Int {
        switch self {
        case .mps:
            return 1
        case .kmh:
            return 0
        case .mph:
            return 2
        case .knots:
            return 3
        }
    }
    
    
}


enum WindDirection: String {
    case degrees = "Degrees"
    case cardinal = "Cardinal"
    
    init(position: Int) {
        switch position {
        case 0:
            self = .cardinal
        case 1:
            self = .degrees
        default:
            self = .degrees
        }
    }
    
    
    func index() -> Int {
        switch self {
        case .degrees:
            return 1
        case .cardinal:
            return 0
        }
    }
    
    
}

enum TemperatureUnit:String {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    init(position: Int) {
        switch position {
        case 0:
            self = .celsius
        case 1:
            self = .fahrenheit
        default:
            self = .celsius
        }
    }
    
    func index() -> Int {
        switch self {
        case .celsius:
            return 0
        case .fahrenheit:
            return 1
        }
    }
}


func convertWindSpeedD(speed: Double, unit: WindSpeed = WindSpeed(rawValue: Defaults[.windSpeed])!) -> Double {
    switch unit {
    case .mps:
        return speed
    case .mph:
        return speed * 2.236936
    case .kmh:
        return speed * 3.6
    case .knots:
        return speed * 1.943844492
    }
}




func convertWindSpeed(speed: Double,withUnits:Bool = true, unit: WindSpeed = WindSpeed(rawValue: Defaults[.windSpeed])!) -> String {
    switch unit {
    case .mps:
        return "\(String(format: "%.1f", speed)) \(withUnits ? unit.rawValue : "")"
    case .mph:
        return "\(String(format: "%.1f", speed * 2.236936)) \(withUnits ? unit.rawValue : "")"
    case .kmh:
        return "\(String(format: "%.1f", speed * 3.6)) \(withUnits ? unit.rawValue : "")"
    case .knots:
        return "\(String(format: "%.1f", speed * 1.943844492)) \(withUnits ? unit.rawValue : "")"
    }
}

func convertTemp(temp: Double, unit: TemperatureUnit) -> Double {
    switch unit {
    case .celsius:
        return temp
    case .fahrenheit:
        return temp * 9 / 5 + 32
    }
}


let cardinals = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
let cardinalsAngle = [0, 22.5, 45, 67.5, 90, 112.5, 135, 157.5, 180, 202.5, 225, 257.5, 270, 292.5, 315, 337.5]


func convertDirection(direction:Int, unit: WindDirection = WindDirection(rawValue: Defaults[.windDirection])!) -> String {
    switch unit {
    case .degrees:
        return "\(direction)°"
    case .cardinal:
        let step : Double = 360 / 15
        let truc = ((Double(direction) + step) / 2).truncatingRemainder(dividingBy: 360)
        let index = Int(floor( truc / step ))
        return cardinals[index * 2]
    }
}




//Jack utils

protocol NotificationName {
    var name: Notification.Name { get }
}

extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}

