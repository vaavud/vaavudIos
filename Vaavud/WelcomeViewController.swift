//
//  WelcomeViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 4/22/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase


protocol IWelcomeProtocol {
    func onSuccess()
    func onError(error: Error)
}


class WelcomeBusinessController {
    
    let delegate: IWelcomeProtocol
    
    init(delegate: IWelcomeProtocol) {
        self.delegate = delegate
    }
    
    
    func doLoginFacebook() {
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) {data,error in
            
            if let e = error {
                print(e)
                return
            }
            
            let uid = data!.uid
            self.verifyUserFirebase(uid: uid)
        }
    }
    
    private func verifyUserFirebase(uid: String) {
        FIRDatabase.database().reference().child("user").child(uid).observeSingleEvent(of: .value, with: {data in
            if data.childrenCount > 1 {
                self.delegate.onSuccess()
            }
            else {
                self.saveUserFirebase()
            }
        })
    }
    
    
    
    private func saveUserFirebase() {
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields" : "first_name, last_name, picture.type(large), email, name, id, gender"])
        graphRequest!.start {(connection, result, error) in
            
            if let e = error {
                print(e)
                return
            }
            
            if let res = result as? FireDictionary {
                guard let email = res["email"] else{
                    print("No email :(")
                    return
                }
                
                let firstName = res["first_name"] as? String ?? "Unknown"
                let lastName = res["last_name"] as? String ?? ""
//                let country = NSLocale.currentLocale[NSLocale.Key.countryCode] as! String
                let language = NSLocale.preferredLanguages[0]
            }
        }

        
        self.delegate.onSuccess()
    }

}



class WelcomeViewController: UIViewController,IWelcomeProtocol, FBSDKLoginButtonDelegate {

    func onSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onError(error: Error) {
        
    }
    
    @IBOutlet weak var facebookView: FBSDKLoginButton!
    private var welcomeBusiness: WelcomeBusinessController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKLoginManager().logOut()
        welcomeBusiness = WelcomeBusinessController(delegate: self)
    }
    
    
    @IBAction func onCloseAuth() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
        if let _ = error {
            print("ERROR FROM FACEBOOK") //TODO
            return
        }
        
        if result.isCancelled {
            return
        }
        
        welcomeBusiness.doLoginFacebook()
    }

}
