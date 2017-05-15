//
//  MapViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/7/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate,ICalloutDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblUnits: UILabel!

    
    var units: String?
    var annotations = [VaavudAnnotation]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        guard let units = units else {
            self.units = Defaults[.windSpeed]
            lblUnits.text = Defaults[.windSpeed]
            return
        }
        
        if units != Defaults[.windSpeed] {
            lblUnits.text = Defaults[.windSpeed]
            self.units = Defaults[.windSpeed]
            print("refresh annotations")
            reloadAnnotations()
        }
    }
    
    
    
    private func reloadAnnotations() {
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    
    private func setupMap() {
        
        Alamofire.request("https://weather.vaavud.com/api/spots").responseJSON { response in
            if response.result.isSuccess {
                let sessions = response.result.value as! [String : [String:Any]]
                
                for (key, data) in sessions {
                    if let s = Session(key: key, data: data) {
                        if let location = s.location {
                            let pinAnnotation = VaavudAnnotation()
                            pinAnnotation.key = key
                            pinAnnotation.windMax = s.windMax
                            pinAnnotation.windMean = s.windMean
                            pinAnnotation.windDirection = s.windDirection
                            pinAnnotation.name = location.name
                            pinAnnotation.setCoordinate(newCoordinate: location.toCoordinate)
                            self.annotations.append(pinAnnotation)
                            self.mapView.addAnnotation(pinAnnotation)
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    func onMoreDetails(key: String) {
        
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
            vc.sessionKey = key
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "VaavudPin") as? AnnotationView
        
        if annotation is VaavudAnnotation {
            let vaavudAnnotation = annotation as! VaavudAnnotation
            
            if annotationView == nil{
                annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "VaavudPin")
                annotationView?.canShowCallout = false
            }else{
                annotationView?.annotation = annotation
            }

            annotationView?.setInformation(windSpeed: vaavudAnnotation.windMean, windDirection: vaavudAnnotation.windDirection)
        }
        
        return annotationView
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            return
        }
        
        let vaavudAnnotation = view.annotation as! VaavudAnnotation
        
        let customCallOut = (Bundle.main.loadNibNamed("CustomCallOut", owner: self, options: nil))?[0] as! CustomCallOut
        customCallOut.center = CGPoint(x: 20, y: -70)
        
        
        customCallOut.setInformation(name: vaavudAnnotation.name, time: 0, windDirection: vaavudAnnotation.windDirection, windAvg: vaavudAnnotation.windMean, windMax: vaavudAnnotation.windMax, latlon: vaavudAnnotation.coordinate)
        customCallOut.key = vaavudAnnotation.key
        customCallOut.listener = self
        
        view.addSubview(customCallOut)
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self){
            for subview in view.subviews {
                if subview is CustomCallOut {
                    subview.removeFromSuperview()
                }
                
            }
        }
    }
    

}
