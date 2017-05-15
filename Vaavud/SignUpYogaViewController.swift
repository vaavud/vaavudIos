//
//  SignUpYogaViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/7/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit

class SignUpYogaViewController: UIViewController {

    var rootSize: CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootSize = self.view.bounds.size
        
//        
//        let root = self.view!
//        root.configureLayout { (layout) in
//            layout.isEnabled = true
//            layout.width = self.rootSize.width
//            layout.height = self.rootSize.height
//        }
//        
//        let navView = UIView()
//        navView.backgroundColor = .vaavudRed()
//        navView.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 20
//        }
//        
//        root.addSubview(navView)
//        root.addSubview(renderHeader())
//        root.addSubview(renderBody())
//        root.addSubview(renderFooter())
//        
//        root.yoga.applyLayout(preservingOrigin: true)
    }
    
    func onLogin(){
        print("login")
    }

    func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
   

//
//    // MARK: - Render views
//    
//    
//    private func renderFooter() -> UIView {
//        
//        
//        let footer = UIView(frame: .zero)
//        footer.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 90
//            $0.position = .absolute
//            $0.bottom = 0
//        }
//        
//        
//        let btnForgotPassword = UIButton(type: .system)
//        btnForgotPassword.tintColor = .vaavudGray()
//        btnForgotPassword.setTitle("Forgot your password?", for: .normal)
//        btnForgotPassword.titleLabel?.font = UIFont(name: "Roboto-ligth", size: 12)
//        btnForgotPassword.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
//        btnForgotPassword.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 40
//        }
//        
//        
//        let btnSignUp = UIButton(type: .system)
//        btnSignUp.backgroundColor = .vaavudRed()
//        btnSignUp.tintColor = .white
//        btnSignUp.setTitle("Log in", for: .normal)
//        btnSignUp.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
//        btnSignUp.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
//        btnSignUp.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 50
//        }
//        
//        footer.addSubview(btnForgotPassword)
//        footer.addSubview(btnSignUp)
//        
//        return footer
//    }
//    
//    private func renderHeader() -> UIView {
//        
//        let header = UINavigationBar(frame: .zero)
//        header.isTranslucent = false
//        header.barTintColor = .vaavudRed()
//        header.tintColor = .white
//        header.configureLayout {
//            $0.isEnabled = true
//        }
//        
//        
//        let navItem = UINavigationItem(title: "")
//        
//        let doneItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(goBack))
//        doneItem.tintColor = .white
//        navItem.leftBarButtonItem = doneItem
//        header.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Roboto-Bold", size: 20)!,  NSForegroundColorAttributeName: UIColor.white]
//        header.setItems([navItem], animated: false)
//        
//        return header
//        
//    }
//
//    private func renderBody()  -> UIView {
//        
//        let body = UIView()
//        body.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//        }
//        
//        
//        let emailContainer = baseContainer()
//        
//        let lblemail = UILabel(frame: .zero)
//        lblemail.text = "Email:"
//        lblemail.font = UIFont(name: "Roboto-bold", size: 15)
//        lblemail.lineBreakMode = .byTruncatingTail
//        lblemail.textColor = .vaavudGray()
//        lblemail.textAlignment = .left
//        lblemail.numberOfLines = 1
//        lblemail.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.3
//            $0.height = 80
//        }
//        
//        
//        let txtEmail = KMPlaceholderTextView(frame: .zero)
//        txtEmail.placeholder = "example@vaavud.com"
//        txtEmail.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0)
//        txtEmail.font = UIFont(name: "Roboto-Light", size: 15)
//        txtEmail.textContainer.maximumNumberOfLines = 1
//        txtEmail.textContainer.lineBreakMode = .byTruncatingTail
//        txtEmail.textAlignment = .right
//        txtEmail.contentInset.top = 22
//        txtEmail.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.7
//            $0.height = 80
//        }
//        
//        emailContainer.addSubview(lblemail)
//        emailContainer.addSubview(txtEmail)
//        
//        
//        let passwordContainer = baseContainer()
//        let lblpassword = UILabel(frame: .zero)
//        lblpassword.text = "Password:"
//        lblpassword.font = UIFont(name: "Roboto-bold", size: 15)
//        lblpassword.lineBreakMode = .byTruncatingTail
//        lblpassword.textColor = .vaavudGray()
//        lblpassword.numberOfLines = 1
//        lblpassword.textAlignment = .left
//        lblpassword.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.3
//            $0.height = 80
//        }
//        
//        
//        let txtPassword = UITextField(frame: .zero)
//        txtPassword.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0)
//        txtPassword.font = UIFont(name: "Roboto-Light", size: 15)
//        txtPassword.textAlignment = .right
//        txtPassword.isSecureTextEntry = true
//        txtPassword.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.7
//            $0.height = 80
//        }
//        
//        
//        passwordContainer.addSubview(lblpassword)
//        passwordContainer.addSubview(txtPassword)
//        
//        
//        
//        
//        body.addSubview(emailContainer)
//        body.addSubview(renderDivier())
//        body.addSubview(passwordContainer)
//        body.addSubview(renderDivier())
//        
//        
//        return body
//    }
//    
//    
//    
//    private func baseContainer() -> UIView {
//        
//        let container = UIView()
//        container.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 60
//            $0.padding = 10
//            $0.flexDirection = .row
//            $0.alignItems = .center
//        }
//        
//        return container
//    }
//    
//    private func placeholder(text: String) -> UILabel {
//        let placeholderLabel = UILabel()
//        placeholderLabel.text = text
//        placeholderLabel.font = UIFont(name: "Roboto-Light", size: 15)
//        placeholderLabel.sizeToFit()
//        
//        return placeholderLabel
//    }
//    
//    
//    private func renderDivier() -> UIView {
//        let divider = UIView()
//        divider.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
//        divider.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 1
//        }
//        
//        return divider
//    }
//

    
    
 

}
