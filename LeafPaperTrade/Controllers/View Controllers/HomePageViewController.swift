//
//  HomePageViewController.swift
//  LeafPaperTrade
//
//  Created by Devin Singh on 3/4/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        
        ref.childByAutoId().setValue("User1")

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
