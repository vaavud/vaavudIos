//
//  HistoryTableViewCell.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit


class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDevice: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var imgDirection: UIImageView!
    @IBOutlet weak var lblWindSpeedUnit: UILabel!
    
    
    func setInformation(session: Session) {
        
        if let location = session.location {
            lblName.text = location.name
            setUpMap(lat: location.lat, lon: location.lon)
        }
        
        lblDevice.text = session.windMeter
        lblWindSpeedUnit.text = WindSpeed(rawValue: Defaults[.windSpeed])!.rawValue
        lblWindSpeed.text = convertWindSpeed(speed: session.windMean, withUnits: false)
        
        if let direction = session.windDirection {
            imgDirection.isHidden = false
            lblWindDirection.isHidden = false
            lblWindDirection.text = convertDirection(direction: direction)
            let img = UIImage(named: "smallArrow")?.rotated(by: Measurement(value: Double(direction + 180),unit: .degrees))
            imgDirection.image = img
        }
        else {
            imgDirection.isHidden = true
            lblWindDirection.isHidden = true
        }
        
        
        
    }
    
    
    private func setUpMap(lat: Double, lon: Double){
        let iconUrl = "https://images.vaavud.com/apps/ic_static_marker.png"
        var mapUrl = "http://maps.google.com/maps/api/staticmap"
    
    
        let markers = "icon:\(iconUrl)|shadow:false|\(lat),\(lon)"
        mapUrl = "\(mapUrl)?markers=\(markers)&zoom=15&size=\(180)x\(180)&sensor=true"
    
    
        let urlStr = mapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        let url = URL(string: urlStr as String)
    
        imgLocation.kf.indicatorType = .activity
        imgLocation.kf.setImage(with: url)
        imgLocation.layer.cornerRadius = 25
        imgLocation.clipsToBounds = true
    }
}
