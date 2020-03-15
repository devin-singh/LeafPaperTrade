//
//  LogInOrSignUpViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import LocalAuthentication

class LogInOrSignUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    
    // MARK: - Lifecycle Functions
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

           let scale = newWidth / image.size.width
           let newHeight = image.size.height * scale
           UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
           image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
           
           let newImage = UIGraphicsGetImageFromCurrentImageContext()

           UIGraphicsEndImageContext()
           
        return newImage?.withTintColor(.mapleBlueColor, renderingMode: .alwaysOriginal)
           
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var img = UIImage(named: "Right Detail")
        img = resizeImage(image: img!, newWidth: 40)
        
        navigationController?.navigationBar.backIndicatorImage = img
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = img
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
        
        LogInButton.layer.cornerRadius = 10
        LogInButton.clipsToBounds = true
        
        SignUpButton.layer.cornerRadius = 10
        SignUpButton.clipsToBounds = true
        
        if Auth.auth().currentUser != nil {
            handleFaceId()
            SVProgressHUD.setContainerView(self.view)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private functions
    
    fileprivate func handleFaceId() {
        let context = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Would you like to enable Face ID for this application?") { (result, error) in
                if let error = error {
                    SVProgressHUD.showInfo(withStatus: error.localizedDescription)
                    return
                }
                
                if result {
                    DispatchQueue.main.async {
                        let seconds = 0.4
                        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            self.dismiss(animated: true, completion: nil)
                            self.performSegue(withIdentifier: "skipLogIn", sender: self)
                        }
                    }
                } else {
                    SVProgressHUD.showInfo(withStatus: "Please Try Again")
                }
            }
            
        } else {
            SVProgressHUD.showInfo(withStatus: "Face ID/Touch ID Not Configured. Please Log In.")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        LogInButton.pulsate()
    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
        SignUpButton.pulsate()
    }
    
    
}
