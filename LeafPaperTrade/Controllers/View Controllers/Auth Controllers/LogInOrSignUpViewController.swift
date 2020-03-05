//
//  LogInOrSignUpViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class LogInOrSignUpViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LogInButton.layer.cornerRadius = 10
        LogInButton.clipsToBounds = true
        
        SignUpButton.layer.cornerRadius = 10
        SignUpButton.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        LogInButton.pulsate()
        
    }
}
