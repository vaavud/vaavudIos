//
//  SettingsTableViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/12/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseAuth


extension DefaultsKeys {
    static let measurementTime = DefaultsKey<Int>("measurementTime")
    static let windSpeed = DefaultsKey<String>("windSpeed")
    static let windDirection = DefaultsKey<String>("windDirection")
    static let temperature = DefaultsKey<String>("temperature")
    static let doneFirstTime = DefaultsKey<Bool>("doneFirstTime")
    static let windMeter = DefaultsKey<String>("windMeter")
}


class SettingsTableViewController: UITableViewController {

    
    @IBOutlet weak var btnSignOut: UIButton!
    
    @IBOutlet weak var swMeasurementTime: UISegmentedControl!
    @IBOutlet weak var swWindSpeed: UISegmentedControl!
    @IBOutlet weak var swWindDirection: UISegmentedControl!
    @IBOutlet weak var swTemperature: UISegmentedControl!
    
    
    @IBAction func onMeasurementTimeChanged(_ sender: UISegmentedControl) {
        Defaults[.measurementTime] = sender.selectedSegmentIndex == 0 ? 1 : -1
    }
    
    @IBAction func onWindSpeedChanged(_ sender: UISegmentedControl) {
        Defaults[.windSpeed] = WindSpeed(position: sender.selectedSegmentIndex).rawValue
    }
    
    @IBAction func onWindDirectionChanged(_ sender: UISegmentedControl) {
        Defaults[.windDirection] = WindDirection(position: sender.selectedSegmentIndex).rawValue
    }
    
    @IBAction func onTemperatureChanged(_ sender: UISegmentedControl) {
        Defaults[.temperature] = TemperatureUnit(position: sender.selectedSegmentIndex).rawValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swMeasurementTime.selectedSegmentIndex = Defaults[.measurementTime] == -1 ? 1 : 0
        swWindSpeed.selectedSegmentIndex = WindSpeed(rawValue: Defaults[.windSpeed])!.index()
        swWindDirection.selectedSegmentIndex = WindDirection(rawValue: Defaults[.windDirection])!.index()
        swTemperature.selectedSegmentIndex = TemperatureUnit(rawValue: Defaults[.temperature])!.index()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = FIRAuth.auth()?.currentUser {
            btnSignOut.isHidden = user.isAnonymous
        }
    }

    @IBAction func onSignOut() {
        
        let refreshAlert = UIAlertController(title: "Log out", message: "Are you sure you want to log out from Vaavud?", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Yes", style: .default) { _ in
            do {
                try FIRAuth.auth()?.signOut()
                FIRAuth.auth()?.signInAnonymously()
                self.btnSignOut.isHidden = true
            }
            catch {
                print("Error")
            }
        }
        
        refreshAlert.addAction(action)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler:  nil))
        
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0: //Buy windmeter
                UIApplication.shared.open(URL(string: "https://vaavud.com/shop")!, options: [:], completionHandler: nil)
                return
            case 1: // measuring tips
                return
            default:
                fatalError("Unknown selection")
            }
        }
        else if indexPath.section == 3 {
            switch indexPath.row {
            case 0: //version
                return
            case 1: // vaavud
                UIApplication.shared.open(URL(string: "https://vaavud.com/shop")!, options: [:], completionHandler: nil)
                return
            case 2: // Terms of service
                UIApplication.shared.open(URL(string: "https://vaavud.com/terms")!, options: [:], completionHandler: nil)
                return
            case 3: // Privacy policy
                UIApplication.shared.open(URL(string: "https://vaavud.com/privacy-policy")!, options: [:], completionHandler: nil)
                return
            default:
                fatalError("Unknown selection")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
}
