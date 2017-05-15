//
//  HistoryViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HistoryViewController_: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var sessionRef: UInt!
    let rowId = "IdHistoryCell"
    private var table: UITableView!
    
    var sessions : [Session] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.yoga.isEnabled = true
//        self.view.addSubview(renderTable())
//        self.view.yoga.applyLayout(preservingOrigin: true)
        
        
        
        
//        FIRAuth.auth()?.signIn(withEmail: "galmac12@gmail.com", password: "110921", completion: nil)
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("session").queryOrdered(byChild: "uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (val, d) in
            
            if val.hasChildren() {
                
                for child in val.children {
                    let c = child as! FIRDataSnapshot
                    let key = c.key
                    let value = c.value as! FireDictionary
                    if let s = Session(key: key, data: value) {
                        self.sessions.insert(s, at: 0)
                    }
                }
                self.table.reloadData()
            }
        }
    }
    

    
    
    // MARK: -Table delegate
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: rowId) as! HistoryTableViewCell
        
//        cell.setInformation(session: sessionss[indexPath.row].key)
        
        return cell
    }
    
//    // MARK: -Render Views
//    
//    
//    private func renderEmptyView() -> UIView {
//        
//        let container = UIView()
//        container.configureLayout {
//            $0.isEnabled = true
//            $0.height = self.view.bounds.height
//            $0.width = self.view.bounds.width
//            $0.justifyContent = .center
//            $0.alignItems = .center
//        }
//        
//        
//        let image = UIImageView(image: UIImage(named: "icNoInformation"))
//        image.yoga.isEnabled = true
//        
//        
//        let lblEmpty = UILabel()
//        lblEmpty.text = "Seems like you have not measurements, start taking one"
//        lblEmpty.font = UIFont(name: "Roboto-Bold", size: 16)
//        lblEmpty.textAlignment = .center
//        lblEmpty.textColor = .vaavudGray()
//        lblEmpty.numberOfLines = 2
//        lblEmpty.configureLayout {
//            $0.isEnabled = true
//            $0.margin = 30
//        }
//        
//        container.addSubview(image)
//        container.addSubview(lblEmpty)
//        
//        
//        return container
//    }
//    
//    
//    
//    private func renderTable() -> UITableView {
//        
//        table = UITableView()
//        table.yoga.isEnabled = true
//        table.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
//        table.rowHeight = 80
//        table.delegate = self
//        table.dataSource = self
//        table.yoga.width = self.view.bounds.width
//        table.yoga.height = self.view.bounds.height
//        table.register(HistoryTableViewCell.self, forCellReuseIdentifier: rowId)
//        
//        return table
//    }
}
