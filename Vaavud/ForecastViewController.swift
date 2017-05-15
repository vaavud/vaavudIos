//
//  ForecastViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/10/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import React
import CodePush

class ForecastViewController: UIViewController {

    var data: [String: Any]?
    var rootView: RCTRootView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeReactView()
    }
    
    
    func initializeReactView() {
        
        //        let REACT_DEV_MODE = false
        
        if self.data == nil {
            self.data = [:]
        }
        
        // this is a good place to pass configuration variables
        self.data!["API_KEY"]             = "ABCDEF123456"
        self.data!["AUTHORIZATION_TOKEN"] = "a8b6de25b5bf481824c9c4173c56231a"
        
//        let jsCodeLocation = URL(string: "http://localhost:8081/index.ios.bundle?platform=ios&dev=true")!
//        let jsCodeLocation = CodePush.bundleURL()

        
        let jsCodeLocation = Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        
        
        //        if !REACT_DEV_MODE {
        //            jsCodeLocation = Bundle.mainBundle.URLForResource("main", withExtension: "jsbundle")
        //        }
        
        rootView = RCTRootView(
            bundleURL: jsCodeLocation,
            moduleName: "AddRatingApp",
            initialProperties: data,
            launchOptions: nil)
        rootView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(rootView)
        
        let views : [String : Any] = ["rootView": rootView]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[rootView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[rootView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        self.view.addConstraints(constraints)
        self.view.layoutIfNeeded()
    }


    

}
