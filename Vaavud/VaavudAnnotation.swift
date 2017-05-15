
//
//  VaavudAnnotation.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import MapKit

class VaavudAnnotation : NSObject, MKAnnotation {
    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return coord
        }
    }
    
    var windMeter: String!
    var windMean: Double!
    var windMax: Double!
    var windDirection: Int?
    var key: String!
    var name: String?
    
    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
        self.coord = newCoordinate
    }
}


class AnnotationView: MKAnnotationView {
    
    
    var lblWind: UILabel!
    var imgMap: UIImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        self.bounds.size = CGSize(width: 45, height: 45)
        
        lblWind = UILabel()
        lblWind.textAlignment = .center
        lblWind.textColor = .white
        lblWind.font = UIFont(name: "Roboto-light", size: 12)
        
        
        imgMap = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        imgMap.contentMode = .center
        imgMap.addSubview(lblWind)
        
        self.addSubview(imgMap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setInformation(windSpeed:Double, windDirection: Int?) {
        lblWind.text = convertWindSpeed(speed: windSpeed, withUnits: false)
        
        if let windDirection = windDirection {
            let img = UIImage(named: "icMapMarkerDirection")?.rotated(by: Measurement(value: Double(windDirection), unit: .degrees))
            imgMap.image = img
        }
        else {
            imgMap.image = UIImage(named: "icMapMarker")!
        }
        
        lblWind.sizeToFit()
        lblWind.center = imgMap.center
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if (hitView != nil)
        {
            self.superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds;
        var isInside: Bool = rect.contains(point);
        if(!isInside)
        {
            for view in self.subviews
            {
                isInside = view.frame.contains(point);
                if isInside
                {
                    break
                }
            }
        }
        return isInside
    }
}

extension UIImage {
    struct RotationOptions: OptionSet {
        let rawValue: Int
        
        static let flipOnVerticalAxis = RotationOptions(rawValue: 1)
        static let flipOnHorizontalAxis = RotationOptions(rawValue: 2)
    }
    
    func rotated(by rotationAngle: Measurement<UnitAngle>, options: RotationOptions = []) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotationInRadians = CGFloat(rotationAngle.converted(to: .radians).value)
        let transform = CGAffineTransform(rotationAngle: rotationInRadians)
        var rect = CGRect(origin: .zero, size: self.size).applying(transform)
        rect.origin = .zero
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        return renderer.image { renderContext in
            renderContext.cgContext.translateBy(x: rect.midX, y: rect.midY)
            renderContext.cgContext.rotate(by: rotationInRadians)
            
            let x = options.contains(.flipOnVerticalAxis) ? -1.0 : 1.0
            let y = options.contains(.flipOnHorizontalAxis) ? 1.0 : -1.0
            renderContext.cgContext.scaleBy(x: CGFloat(x), y: CGFloat(y))
            
            let drawRect = CGRect(origin: CGPoint(x: -self.size.width/2, y: -self.size.height/2), size: self.size)
            renderContext.cgContext.draw(cgImage, in: drawRect)
        }
    }
}

