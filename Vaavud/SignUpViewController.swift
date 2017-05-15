//
//  SignUpViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 4/22/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol ISignUpDelegate {
    func onSignUpSuccess()
    func onSignUpError(error: Error)
}

struct NewUser {
    let name: String
    let lastName: String
    let email: String
    let password: String
    
    var fireDict: FireDictionary {
        return ["firstName": name,"email":email, "lastName":lastName, "created": Date().toMillis()]
    }
}

class SignUpBusinessController {
    
    private let delegate: ISignUpDelegate
    
    init(delegate: ISignUpDelegate){
        self.delegate = delegate
    }
    
    func doSignUp(user: NewUser) {
        
        if let currentUser = FIRAuth.auth()?.currentUser {
            let userCredential = FIREmailPasswordAuthProvider.credential(withEmail: user.email, password: user.password)
            
            currentUser.link(with: userCredential) {data, err in
                if let err = err {
                    self.delegate.onSignUpError(error: err)
                    return
                }
                
                let uid = data!.uid
                self.createUser(user: user, uid: uid)
                self.delegate.onSignUpSuccess()
            }
        }
    }
    
    private func createUser(user: NewUser, uid: String) {
        FIRDatabase.database().reference().child("user").child(uid).setValue(user.fireDict)
    }
}



class SignUpViewController: UIViewController, UITextFieldDelegate,ISignUpDelegate {
    
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    private var signUpController: SignUpBusinessController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpController = SignUpBusinessController(delegate: self)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtLastName.becomeFirstResponder()
        }
        else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail{
            txtPassword.becomeFirstResponder()
        }
        else{
            doLogin()
        }
        
        return true
    }
    
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func onSignUpSuccess() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func onSignUpError(error: Error) {
        print(error.localizedDescription)
    }
    
    
    private func doLogin(){
        let newUser = NewUser(name: txtName.text!, lastName: txtLastName.text!, email: txtEmail.text!, password: txtPassword.text!)
        signUpController.doSignUp(user: newUser)
    }
    
}
