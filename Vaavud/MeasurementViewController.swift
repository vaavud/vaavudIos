//
//  MeasurementViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/8/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import VaavudSDK
import RxSwift


struct Ultrasonic {
    let windDirection: Int
    let windSpeed: Double
    let compass: Int
    let battery: Int
    let temperature: Int
    
    
    var toDic: [String:Any] {
        var d : [String:Any] = [:]
        d["windDirection"] = windDirection
        d["windSpeed"] = windSpeed
        d["compass"] = compass
        d["battery"] = battery
        d["temperature"] = temperature
        
        return d
    }
}


enum VaavudDevice: String {
    case Ultrasonic = "Ultrasonic"
    case Sleipnir = "Sleipnir"
    case Mjolnir = "Mjolnir"
}


class MeasurementViewController: UIViewController, WindMeasurementControllerDelegate, IBleSetup {
    
    @IBOutlet weak var testChart: OldGraph!
    
    @IBOutlet weak var lblWindAvg: UILabel!
    @IBOutlet weak var lblCurrentWind: UILabel!
    @IBOutlet weak var lblSpeedUnits: UILabel!
    @IBOutlet weak var imgDirectionArrow: UIImageView!
    @IBOutlet weak var lblWindDirection: UILabel!
    @IBOutlet weak var lblWindMax: UILabel!
    
    //timers
    @IBOutlet weak var lblCounterDown: UILabel!
    var initSeconds = 3
    var initTimer = Timer()
    var timeChart = Timer()
    
    
    let mjolnir = MjolnirMeasurementController()
    let ble = BluetoothController()
    
    
    @IBOutlet weak var progressBar: ActivityIndicatorButton!
    
    //Graph
    private var animator: UIDynamicAnimator!
    private var scaleItem: DynamicItem!
    private var targetLogScale: CGFloat = 0
    private var animatingScale = false
    private var smoothSpeed: Double = 0
    var weight: Double = 0.05 // todo: change
    
    
    
    //SubComponets
    var bleSetup: BleSetup!
    var blurEffectView: UIVisualEffectView!
    
    var currentSdk: VaavudDevice?
    let shared = VaavudSDK.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        animator = UIDynamicAnimator(referenceView: view)
        scaleItem = DynamicItem(centerCallback: { [unowned self] in
            self.testChart.logScale = $0.y/10000
        })
    }
    
    
    func update() {
        self.smoothSpeed = self.weight * (self.shared.session.windSpeeds.last?.speed ?? 0) + (1 - self.weight) * self.smoothSpeed
        
        self.testChart.reading = convertWindSpeedD(speed: self.smoothSpeed)
        self.testChart.average = convertWindSpeedD(speed: self.shared.session.meanSpeed)
        
        if abs(self.targetLogScale - self.testChart.logScale) < 0.01 {
            self.animatingScale = false
            self.animator.removeAllBehaviors()
            self.testChart.logScale = self.targetLogScale
        }
        
        if !self.animatingScale {
            if self.testChart.insideFactor > 1 {
                self.animateLogScale(newLogScale: self.testChart.logScale + 1)
            }
            else if self.testChart.insideFactor < 0.2 && self.testChart.logScale >= 1 {
                self.animateLogScale(newLogScale: self.testChart.logScale - 1)
            }
        }
    }
    
    
    private func initSdk() {
        lblSpeedUnits.text = Defaults[.windSpeed]
        
        if let sdk = currentSdk {
            switch sdk {
            case .Ultrasonic:
                initBle()
                break
            case .Sleipnir:
                initSleipnir()
                
                break
            case .Mjolnir:
                initMjolnir()
                break
            }
            
            
            let displayLink = CADisplayLink(target: self, selector: #selector(update))
            displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            initCallbacks()
        }
        else {
            fatalError("No Sdk selected")
        }
    }
    
    func updateTimer() {
        
        initSeconds -= 1
        if initSeconds > 0  {
            lblCounterDown.text = String(initSeconds)
        }
        else {
            lblCounterDown.isHidden = true
            progressBar.image = UIImage(named: "icStop")
            
            self.initSdk()
            initTimer.invalidate()
        }
    }
    
    @IBAction func onStopMeasurement(_ sender: ActivityIndicatorButton) {
        ble.onDispose()
        mjolnir.stop()
        shared.stop()
        shared.removeAllCallbacks()
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("deinit Measurement")
    }
    
    func animateLogScale(newLogScale: CGFloat) {
        animator.removeAllBehaviors()
        targetLogScale = newLogScale
        animatingScale = true
        animator.addBehavior(UISnapBehavior(item: scaleItem, snapTo: CGPoint(x: 0, y: newLogScale*10000)))
    }
    
    
    private func initCallbacks() {
        
        shared.windDirectionCallback = {
            self.lblWindDirection.text = convertDirection(direction: Int($0.direction))
            let imgDirection = UIImage(named: "summaryDirection")?.rotated(by: Measurement(value: $0.direction,unit: .degrees))
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: .curveEaseIn,
                           animations: { () -> Void in
                            self.imgDirectionArrow.image = imgDirection
                            self.imgDirectionArrow.layoutIfNeeded()
            })
        }
        
        
        shared.windSpeedCallback = {
            self.lblWindMax.text = convertWindSpeed(speed: self.shared.session.maxSpeed, withUnits: false)
            self.lblWindAvg.text = convertWindSpeed(speed: self.shared.session.meanSpeed, withUnits: false)
            self.lblCurrentWind.text = convertWindSpeed(speed: $0.speed, withUnits: false)
        }
        
        shared.bluetoothCallback = {
            
            self.lblWindDirection.text = convertDirection(direction: $0.windDirection)
            let imgDirection = UIImage(named: "summaryDirection")?.rotated(by: Measurement(value: Double($0.windDirection),unit: .degrees))
            UIView.animate(withDuration: 0.1,
                           delay: 0.1,
                           options: .curveEaseIn,
                           animations: { () -> Void in
                            self.imgDirectionArrow.image = imgDirection
                            self.imgDirectionArrow.layoutIfNeeded()
            })
            
            
            self.lblWindMax.text = convertWindSpeed(speed: self.shared.session.maxSpeed, withUnits: false)
            self.lblWindAvg.text = convertWindSpeed(speed: self.shared.session.meanSpeed, withUnits: false)
            self.lblCurrentWind.text = convertWindSpeed(speed: $0.windSpeed, withUnits: false)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        testChart.changedScale()
    }
    
    
    func changedValidity(_ isValid: Bool, dynamicsIsValid: Bool) {
        if !isValid {
            print("is not valid")
        }
        
        if !dynamicsIsValid {
            print("is not dynamicsIsValid")
        }
    }
    
    
    func addSpeedMeasurement(_ currentSpeed: NSNumber!, avgSpeed: NSNumber!, maxSpeed: NSNumber!) {
        
        if mjolnir.dynamicsIsValid == false {
            return
        }
        
        let data = WindSpeedEvent(time: Date() , speed: currentSpeed.doubleValue)
        shared.newWindSpeed(event: data)
    }
    
    
    private func initSetupBle() {
        bleSetup = (Bundle.main.loadNibNamed("BleSetup", owner: self, options: nil))?[0] as! BleSetup
        bleSetup.center = self.view.center
        bleSetup.delegate = self
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bleSetup.center = blurEffectView.center
        blurEffectView.addSubview(bleSetup)
        
        view.addSubview(blurEffectView)
    }
    
    /*
     Init Controllers
     */
    
    private func initBle() {
        
        initSetupBle()
        
        shared.startWithBluetooth(offset: ["foo":12])
        
        let _ = ble.onVerifyBle()
            .subscribe(onError: {
                print($0)
                self.bleSetup.onError(message: "Seems like the bluethooth is off")
            }, onCompleted: {
                self.findUltrasonic()
            })
        
        
        let _ = ble.readRowData()
            .subscribe(onNext: {
                let val = $0.value?.hexEncodedString()
                let data = self.workWithRowData(val: val!)
                self.shared.newReading(event: BluetoothEvent(windSpeed: data.windSpeed, windDirection: data.windDirection, battery: data.battery, compass: Double(data.compass)))
            }, onError: {
                print($0)
            })
    }
    
    private func initMjolnir() {
        do {
            try shared.startLocationAndPressureOnly()
        }
        catch {
            print("Error")
        }
        
        mjolnir.delegate = self
        mjolnir.start()
    }
    
    private func initSleipnir() {
        do {
            try shared.start(flipped: false)
        }
        catch {
            
            print("error")
        }
    }
    
    private func findUltrasonic() {
        
        let _ = ble.onConnectDevice()
            .subscribe(onError: {
                self.bleSetup.onError(message: "We could not find your Ultrasonic.")
                print($0)
            }, onCompleted: {
                self.bleSetup.removeFromSuperview()
                self.blurEffectView.removeFromSuperview()
                self.ble.activateSensores()
            })
    }
    
    
    /*
     MARK: Ble dialog protocol
     */
    
    func onBleTryAgain() {
        print("onBleTryAgain")
    }
    
    func onCancel() {
        //        timeChart.invalidate()
        shared.stop()
        shared.removeAllCallbacks()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Extras
    
    
    
    func workWithRowData(val: String) -> Ultrasonic {
        
        //    print(val)
        
        //Speed
        let s10 = val.substring(from: 0, to: 1)
        let s11 = val.substring(from: 2, to: 3)
        let h1 = Int(s11.appending(s10), radix: 16)
        let windSpeed = Double(h1!) / 100
        
        //    print("speed: \(_h1)")
        
        //Direction
        let s20 = val.substring(from: 4, to: 5)
        let s21 = val.substring(from: 6, to: 7)
        let windDirection = Int(s21.appending(s20), radix: 16)!
        //    print("Direction: \(h2)")
        
        //Battery
        let s30 = val.substring(from: 8, to: 9)
        let h3 = Int(s30, radix: 16)! * 10
        //    print("Battery: \(h3)")
        
        //    //Temperature
        let s40 = val.substring(from: 10, to: 11)
        let h4 = Int(s40, radix: 16)! - 100
        //    print("Temperataure: \(h4)")
        //
        //
        //    //Escora
        //    let s50 = val.substring(from: 12, to: 13)
        //    let h5 = Int(s50, radix: 16)! - 90
        //    print("Escora: \(h5)")
        //
        //
        //    //Cabeceo
        //    let s60 = val.substring(from: 14, to: 15)
        //    let h6 = Int(s60, radix: 16)! - 90
        //    print("Cabeceo: \(h6)")
        
        
        //Compass
        let s70 = val.substring(from: 16, to: 17)
        let s71 = val.substring(from: 18, to: 19)
        let compass = Int(s71.appending(s70) , radix: 16)!
        
        //    print("Compass: \(h7)")
        
        return Ultrasonic(windDirection: windDirection, windSpeed: windSpeed, compass: compass, battery: h3, temperature: h4)
    }
    
    
    
    override open var shouldAutorotate: Bool {
        return true
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portraitUpsideDown,.portrait]
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portraitUpsideDown
    }
}


















