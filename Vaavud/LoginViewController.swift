//
//  LoginViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 4/22/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseAuth


protocol ILoginProtocol {
    func onLoginSuccess()
    func onLoginError(error: String)
}



class LoginBusinessController {
    
    private let delegate: ILoginProtocol
    
    init(delegate:ILoginProtocol){
        self.delegate = delegate
    }
    
    func doLogin(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { data, err in
            if let e = err {
                self.delegate.onLoginError(error: e.localizedDescription)
                return
            }
            
            self.delegate.onLoginSuccess()
        }
    }
}


class LoginViewController: UIViewController, UITextFieldDelegate, ILoginProtocol {
    
    
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    private var delegate: LoginBusinessController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = LoginBusinessController(delegate: self)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onLogin(_ sender: UIButton) {
        doLogin()
    }
    
    
    private func doLogin() {
        view.endEditing(true)
        delegate.doLogin(email: lblEmail.text!, password: lblPassword.text!)
    }
    
    
    private func validInput() -> Bool {
        if lblPassword.text!.characters.count < 5 {
            return false
        }
        else if lblEmail.text!.isEmpty {
            return false
        }
        
        return true
    }
    
    
    func onLoginSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func onLoginError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        refreshSignupButton()
    }
    
    
    
    private func refreshSignupButton() {
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lblEmail {
            lblPassword.becomeFirstResponder()
        }
        else {
            guard validInput() else {return false}
            doLogin()
        }
        return true
    }
    
}
