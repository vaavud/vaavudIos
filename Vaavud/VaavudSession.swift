//
//  VaavudSession.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import MapKit

struct Session {
    let key: String
    let deviceKey: String
    var location: Location?
    let timeEnd: Double
    let timeStart: Double
    let uid: String
    let windMax: Double
    let windMean: Double
    let windMeter: String
    let windDirection: Int?
    
    
    var date : Date {
        return Date(milliseconds: Int64(timeStart))
    }
    
    
    init?(key: String, data:[String:Any]){
        
        self.location = nil
        if let loc = data["location"] as? [String:Any] {
            self.location = Location(data: loc)
        }
        
        self.deviceKey = data["deviceKey"] as? String ?? "Unknown"
        self.key = key
        self.timeEnd = data["timeEnd"] as? Double ?? 0.0
        self.timeStart = data["timeStart"] as? Double ?? 0.0
        self.uid = data["uid"] as? String ?? "Unknown"
        self.windMax = data["windMax"] as? Double ?? 0.0
        self.windMean = data["windMean"] as? Double ?? 0.0
        self.windMeter = data["windMeter"] as? String ?? "Unknown"
        self.windDirection = data["windDirection"] as? Int
    }
}


struct Location {
    let altitude: Double
    let lat: Double
    let lon: Double
    let name: String
    
    init(data: [String:Any]){
        altitude = data["altitude"] as? Double ?? 0
        lat = data["lat"] as! Double
        lon = data["lon"] as! Double
        name = data["name"] as? String ?? "Unknown"
    }
    
    var toCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}
