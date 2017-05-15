//
//  LoginYogaViewController.swift
//  Vaavud
//
//  Created by Diego Galindo on 5/6/17.
//  Copyright © 2017 Vaavyd. All rights reserved.
//

import UIKit
import yoga

class LoginYogaViewController: UIViewController {
    
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
    
    
    func onCreateAccount(){
        print("asdasdsa")
    }
    
    func goBack(){
        navigationController?.popViewController(animated: true)
    }
    
    func btnTerms(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
//    // MARK: -- Render Views
//    
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
//        let navItem = UINavigationItem(title: "Sing Up")
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
//        let termsView = UIView(frame: .zero)
//        termsView.configureLayout {
//            $0.isEnabled = true
//            $0.alignItems = .center
//            $0.justifyContent = .center
//            $0.flexDirection = .row
//        }
//        
//        let terms = UILabel(frame: .zero)
//        terms.text = "I agree to the Terms & Conditions"
//        terms.font = UIFont(name: "Roboto-Light", size: 12)
//        
//        
//        let btnCheck = WOWCheckbox()
//        btnCheck.backgroundColor = .white
//        btnCheck.borderColor = .gray
//        btnCheck.lineWidth = 2
//        btnCheck.boxBackgroundColor = .white
//        btnCheck.tickColor = .vaavudBlue()
//        btnCheck.isChecked = false
//        btnCheck.contentMode = .scaleToFill
//        btnCheck.configureLayout{
//            $0.isEnabled = true
//            $0.width = 40
//            $0.height = 40
//        }
//        
//        termsView.addSubview(btnCheck)
//        termsView.addSubview(terms)
//
//        
//        
//        let btnSignUp = UIButton(frame: .zero)
//        btnSignUp.backgroundColor = .vaavudRed()
//        btnSignUp.setTitle("Create account", for: .normal)
//        btnSignUp.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
//        btnSignUp.addTarget(self, action: #selector(onCreateAccount), for: .touchUpInside)
//        btnSignUp.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//            $0.height = 50
//        }
//        
//        footer.addSubview(termsView)
//        footer.addSubview(btnSignUp)
//        
//        return footer
//    }
//    
//    
//    func renderBody() -> UIView {
//        
//        let body = UIView()
//        body.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width
//        }
//        
//        
//        let nameContainer = baseContainer()
//        
//        let lblName = UILabel(frame: .zero)
//        lblName.text = "First Name:"
//        lblName.font = UIFont(name: "Roboto-bold", size: 15)
//        lblName.lineBreakMode = .byTruncatingTail
//        lblName.textColor = .vaavudGray()
//        lblName.textAlignment = .left
//        lblName.numberOfLines = 1
//        lblName.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.3
//            $0.height = 80
//        }
//        
//        
//        let txtName = KMPlaceholderTextView(frame: .zero)
//        txtName.placeholder = "Diego R"
//        txtName.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0)
//        txtName.font = UIFont(name: "Roboto-Light", size: 15)
//        txtName.textContainer.maximumNumberOfLines = 1
//        txtName.textContainer.lineBreakMode = .byTruncatingTail
//        txtName.textAlignment = .right
//        txtName.contentInset.top = 22
//        txtName.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.7
//            $0.height = 80
//        }
//        
//        nameContainer.addSubview(lblName)
//        nameContainer.addSubview(txtName)
//        
//        
//        let lastNameContainer = baseContainer()
//        let lblLastName = UILabel(frame: .zero)
//        lblLastName.text = "Last Name:"
//        lblLastName.font = UIFont(name: "Roboto-bold", size: 15)
//        lblLastName.lineBreakMode = .byTruncatingTail
//        lblLastName.textColor = .vaavudGray()
//        lblLastName.numberOfLines = 1
//        lblLastName.textAlignment = .left
//        lblLastName.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.3
//            $0.height = 80
//        }
//        
//        
//        let txtLastName = KMPlaceholderTextView(frame: .zero)
//        txtLastName.placeholder = "Galindo"
//        txtLastName.backgroundColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0)
//        txtLastName.font = UIFont(name: "Roboto-Light", size: 15)
//        txtLastName.textContainer.maximumNumberOfLines = 1
//        txtLastName.textContainer.lineBreakMode = .byTruncatingTail
//        txtLastName.textAlignment = .right
//        txtLastName.contentInset.top = 22
//        txtLastName.configureLayout {
//            $0.isEnabled = true
//            $0.flexGrow = 0.7
//            $0.height = 80
//        }
//        
//        lastNameContainer.addSubview(lblLastName)
//        lastNameContainer.addSubview(txtLastName)
//        
//        
//        let emailContainer = baseContainer()
//        let lblEmail = UILabel(frame: .zero)
//        lblEmail.text = "Email:"
//        lblEmail.font = UIFont(name: "Roboto-bold", size: 15)
//        lblEmail.lineBreakMode = .byTruncatingTail
//        lblEmail.textColor = .vaavudGray()
//        lblEmail.textAlignment = .left
//        lblEmail.configureLayout {
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
//        emailContainer.addSubview(lblEmail)
//        emailContainer.addSubview(txtEmail)
//        
//        
//        
//        let passwordContainer = baseContainer()
//        let lblPassword = UILabel(frame: .zero)
//        lblPassword.text = "Password:"
//        lblPassword.font = UIFont(name: "Roboto-bold", size: 15)
//        lblPassword.lineBreakMode = .byTruncatingTail
//        lblPassword.textColor = .vaavudGray()
//        lblPassword.numberOfLines = 3
//        lblPassword.textAlignment = .left
//        lblPassword.configureLayout {
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
//        passwordContainer.addSubview(lblPassword)
//        passwordContainer.addSubview(txtPassword)
//        
//        
//        body.addSubview(nameContainer)
//        body.addSubview(renderDivier())
//        body.addSubview(lastNameContainer)
//        body.addSubview(renderDivier())
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
//    
//    private func renderDivier() -> UIView {
//        let divider = UIView()
//        divider.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0)
//        divider.configureLayout {
//            $0.isEnabled = true
//            $0.width = self.rootSize.width - 20
//            $0.marginLeft = 20
//            $0.height = 1
//        }
//        
//        return divider
//    }
//    
    
    
}
