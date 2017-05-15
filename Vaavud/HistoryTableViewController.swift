//
//  HistoryTableViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/10/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class HistoryTableViewController: UITableViewController {
    
    var sessionss : [[Session]] = []
    var noMeasurementView: UIView?
    var speedUnits: String?
    var directionUnits: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = FIRAuth.auth()?.rx_addAuthStateDidChangeListener.subscribe(onNext: {auth, user in
            
            self.sessionss.removeAll()
            self.tableView.reloadData()
            
            guard let user = user, !user.isAnonymous else {
                return
            }
            
            self.fetchSessions()
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        guard let units = speedUnits, let direction = directionUnits else {
            self.speedUnits = Defaults[.windSpeed]
            self.directionUnits = Defaults[.windDirection]
            return
        }
        
        if units != Defaults[.windSpeed] || direction != Defaults[.windDirection]  {
            self.speedUnits = Defaults[.windSpeed]
            self.directionUnits = Defaults[.windDirection]
            print("refresh table")
            self.tableView.reloadData()
        }
    }
    
    
    
    
    private func fetchSessions() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("session").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (val, d) in
            
            if val.hasChildren() {
                
                var sessions : [Session] = []
                
                for child in val.children {
                    let c = child as! FIRDataSnapshot
                    let key = c.key
                    let value = c.value as! FireDictionary
                    if let s = Session(key: key, data: value) {
                        sessions.insert(s, at: 0)
                    }
                }
                
                if let v = self.noMeasurementView {
                    v.removeFromSuperview()
                }
                
                self.workWithSessions(_sessions: sessions)
            }
            else {
                self.noMeasurementView = (Bundle.main.loadNibNamed("NoHistory", owner: self, options: nil))?[0] as? UIView
                self.noMeasurementView?.bounds = self.view.frame
                self.noMeasurementView?.center = self.view.center
                self.view.addSubview(self.noMeasurementView!)
            }
        }
    }
    

    
    private func workWithSessions(_sessions: [Session]) {
        let sessions = _sessions.sorted{$0.timeStart > $1.timeStart}
        
        var currentDay = Calendar(identifier: .iso8601).ordinality(of: .day, in: .year, for: sessions[0].date)!
        var index = 0
        sessionss.append([])
        
        for session in sessions {
            let day = Calendar(identifier: .iso8601).ordinality(of: .day, in: .year, for: session.date)!

            if currentDay != day {
                index = index + 1
                currentDay = day
                sessionss.insert([], at: index)
            }
            sessionss[index].append(session)
        }
        
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sessionss.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionss[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryTableViewCell
        
        let session = sessionss[indexPath.section][indexPath.row]
        cell.setInformation(session: session)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CET")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        var strDate = ""
        if sessionss[section].count > 0 {
            strDate = dateFormatter.string(from: sessionss[section][0].date)
        }
        
        return strDate
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sessionKey = sessionss[indexPath.section][indexPath.row]
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "SummaryViewController") as? SummaryViewController {
            vc.sessionKey = sessionKey.key
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
