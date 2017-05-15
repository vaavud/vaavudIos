//
//  BleSetup.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/10/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit


protocol IBleSetup {
    func onCancel()
    func onBleTryAgain()
}



class BleSetup: UIView {

    
    @IBOutlet weak var imgBle: UIImageView!
    
    @IBOutlet weak var btnTryAgain: UIButton!
    @IBOutlet weak var lblError: UILabel!
    
    var delegate: IBleSetup!
    
    
    @IBAction func onCancel() {
        delegate.onCancel()
    }
    
    @IBAction func onTryAgain() {
        delegate.onBleTryAgain()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let pulseEffect = LFTPulseAnimation(repeatCount: .infinity, radius:80, position:imgBle.center)
        pulseEffect.backgroundColor = UIColor.vaavudRed().cgColor
        self.layer.insertSublayer(pulseEffect, below: imgBle.layer)
    }
    
    
    func onError(message: String){
    
    }

}
