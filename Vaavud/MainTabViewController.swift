//
//  MainTabViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth


class MainTabViewController: UITabBarController, UITabBarControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("----------------")
        
        
        let vaavudButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 50 , y: -30, width: 100, height: 100))
        vaavudButton.setImage(UIImage(named: "measureIcon"), for: .normal)
        vaavudButton.addTarget(self, action: #selector(onMeasurement), for: .touchUpInside)
        

        self.tabBar.addSubview(vaavudButton)
        delegate = self
        
        
//        FIRAuth.auth()?.addStateDidChangeListener { (auth,user) in
//            print(user)
//        }
        
//        let currentRoute = AVAudioSession.sharedInstance().currentRoute
//        for description in currentRoute.outputs {
//            if description.portType == AVAudioSessionPortHeadphones {
//                print("headphone plugged in")
//            } else {
//                print("headphone pulled out")
//            }
//        }
    }
    
    
    func onMeasurement() {
        let actionSheetController = UIAlertController(title: "Please select your wind meater", message: "Vaavud", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        let ultrasonic = UIAlertAction(title: "Ultrasonic", style: .default) { action  in
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "measurementNavigator") as! MeasurementViewController
            vc.currentSdk = .Ultrasonic
            self.present(vc, animated: true, completion: nil)
        }
        
        let sleipnir = UIAlertAction(title: "Sleipnir", style: .default) { action  in
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "measurementNavigator") as! MeasurementViewController
            vc.currentSdk = .Sleipnir
            self.present(vc, animated: true, completion: nil)
            
        }
        
        let mjolnir = UIAlertAction(title: "Mjolnir", style: .default) { action  in
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "measurementNavigator") as! MeasurementViewController
            vc.currentSdk = .Mjolnir
            self.present(vc, animated: true, completion: nil)
            
        }
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(sleipnir)
        actionSheetController.addAction(ultrasonic)
        actionSheetController.addAction(mjolnir)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == childViewControllers[2] {
            onMeasurement()
            return false
        }
        
        
//        if FIRAuth.auth()!.currentUser!.isAnonymous && (viewController == childViewControllers[1] || viewController == childViewControllers[3]) {
//            print("needs auth...")
//            return false
//        }
        
        
        return true
    }
}
