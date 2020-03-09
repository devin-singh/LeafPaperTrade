//
//  SignUpViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.cornerRadius = 10
        emailTextField.attributedPlaceholder = NSAttributedString(string: " Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.attributedPlaceholder = NSAttributedString(string: " Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        SVProgressHUD.setContainerView(self.view)
    }
    
    // MARK: - Actions
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        signUpButton.pulsate()
        
        guard let emailText = emailTextField.text, !emailText.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Please enter an email")
            return
        }
        
        guard let passwordText = passwordTextField.text, !passwordText.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Please enter a password")
            return
        }
        
        Auth.auth().createUser(withEmail: emailText, password: passwordText) { (result, error) in
            guard let user = result?.user, error == nil
                else {
                    SVProgressHUD.showInfo(withStatus: error!.localizedDescription)
                    return
            }
            
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "toTabBarFromSignUp", sender: sender)
            }
            // Add user uid to database
            let ref = Database.database().reference()
            
            ref.child("Users/\(user.uid)/Portfolio Value").setValue("100000")
            ref.child("Users/\(user.uid)/Email").setValue("\(user.email!)")
        }
    }
}
