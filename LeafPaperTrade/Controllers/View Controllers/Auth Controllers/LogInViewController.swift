//
//  LogInViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class LogInViewController: UIViewController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Outlets
    
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle Functions
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogInButton.layer.borderWidth = 1
        LogInButton.layer.borderColor = UIColor.mapleBlueColor.cgColor
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LogInButton.layer.cornerRadius = 10
        LogInButton.clipsToBounds = true
        LogInButton.clipsToBounds = true
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 30)
        
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        passwordTextField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 30)
        
        SVProgressHUD.setContainerView(self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Actions
    
    @IBAction func logInButtonPressed(_ sender: Any) {
        LogInButton.pulsate()
        
        SVProgressHUD.show()
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter your email")
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter your password")
            return
        }
        
        Auth.auth().signIn(withEmail: emailText, password: passwordText) { (result, error) in
            if let error = error {
                print(error, error.localizedDescription)
                DispatchQueue.main.async {
                    SVProgressHUD.showInfo(withStatus: "Email or Password is Incorrect")
                }
                return
            }
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toTabBar", sender: sender)
            }
            
        }
        
    }
}

