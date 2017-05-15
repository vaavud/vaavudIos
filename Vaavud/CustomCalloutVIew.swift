//
//  CustomCalloutVIew.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import Kingfisher


protocol ICalloutDelegate {
    func onMoreDetails(key: String)
}


class CustomCallOut: UIView {
    
    var key: String!
    var listener: ICalloutDelegate!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDirection: UILabel!
    @IBOutlet weak var lblWindAvg: UILabel!
    @IBOutlet weak var lblWindMax: UILabel!
    @IBOutlet weak var lblTime: UIView!
    
    
    @IBAction func onSeeSummary() {
        listener.onMoreDetails(key: key)
    }
    
    
//    override func awakeFromNib() {
//        super.awakeFromNib()}
    
    
    func setInformation(name: String?, time:Double, windDirection: Int?, windAvg: Double, windMax:Double, latlon: CLLocationCoordinate2D) {
        lblLocation.text = name
        lblWindAvg.text = convertWindSpeed(speed: windAvg)
        lblWindMax.text = convertWindSpeed(speed: windMax)
        if let direction = windDirection {
            lblDirection.text = convertDirection(direction: direction)
        }
        else {
            lblDirection.text = "-"
        }
        
        setupImage(latlon:latlon)
    }
    
    private func setupImage(latlon: CLLocationCoordinate2D) {
        
        let iconUrl = "https://images.vaavud.com/apps/ic_static_marker.png"
        var mapUrl = "http://maps.google.com/maps/api/staticmap"
        
        
        let markers = "icon:\(iconUrl)|shadow:false|\(latlon.latitude),\(latlon.longitude)"
        mapUrl = "\(mapUrl)?markers=\(markers)&zoom=15&size=\(240)x\(280)&sensor=true"
        
        
        let urlStr = mapUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        let url = URL(string: urlStr as String)
        
        imgLocation.kf.indicatorType = .activity
        imgLocation.kf.setImage(with: url)
    }
    
    
    
    
 }
