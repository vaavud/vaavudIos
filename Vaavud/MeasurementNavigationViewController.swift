//
//  MeasurementNavigationViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/15/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit

class MeasurementNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portraitUpsideDown,.portrait]
    }
    
}
