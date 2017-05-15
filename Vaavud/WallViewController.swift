//
//  WallViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/12/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseAuth


class WallViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgbackground: UIImageView!
    @IBOutlet weak var imgWall: UIImageView!
    @IBOutlet weak var lblWall: UILabel!
    @IBOutlet weak var lblDescriptionWall: UILabel!
    
    
    public func onHistory() {
        imgbackground.image = UIImage(named: "historyWall")
        imgWall.image = UIImage(named: "icHistoryWall")
        lblWall.text = "Measurement History"
        lblDescriptionWall.text = "To save measurements to your personal measurement history you need to log in."
        imgWall.image = imgWall.image!.withRenderingMode(.alwaysTemplate)
        imgWall.tintColor = .white

    }
    
    public func onMap() {
        imgbackground.image = UIImage(named: "mapWall")
        imgWall.image = UIImage(named: "icMapWall")
        lblWall.text = "Live Map"
        lblDescriptionWall.text = "To see wind readings from users around the world for the last 24 hours you need to log in."
        imgWall.image = imgWall.image!.withRenderingMode(.alwaysTemplate)
        imgWall.tintColor = .white
        
    }
    

    @IBAction func onLogin() {
        
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "AuthNavigator")
        
       self.present(mainViewController, animated: true, completion: nil)
    }
}



class MapCustomsViewController: UIViewController {
    
    
    @IBOutlet weak var mapContainer: UIView!
    @IBOutlet weak var wallContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let child = childViewControllers.first as? WallViewController {
            child.onMap()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        wallContainer.isHidden = !user.isAnonymous
        mapContainer.isHidden = user.isAnonymous
        
    }

}

class HistoryCustomsViewController: UIViewController {
    
    
    @IBOutlet weak var wallContainer: UIView!
    @IBOutlet weak var historyContainer: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let child = childViewControllers.first as? WallViewController {
            child.onHistory()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let user = FIRAuth.auth()?.currentUser else {
            return
        }
        
        wallContainer.isHidden = !user.isAnonymous
        historyContainer.isHidden = user.isAnonymous
        
    }
    
    
}
