//
//  IssueMissionViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class IssueMissionViewController: UIViewController {

    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func issueBtn(_ sender: UIButton) {
    }
    
    @IBOutlet weak var missionTitle: UITextField!
    @IBOutlet weak var missionDetialTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    
    }

}
