//
//  SettingsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var cacheValue: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    @IBAction func notificationSwitchedStatus(_ sender: UISwitch) {
    }
    
    @IBOutlet weak var confirmChangeBtn: UIButton!
    
    @IBAction func confirmChangeClicked(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.onTintColor = #colorLiteral(red: 0.3019607961, green: 0.6941176653, blue: 0.980392158, alpha: 1)
        setRoundRect(targets: [confirmChangeBtn])
        
        setNavBarBackBtn()
        setNavBarTitle(title: "设置")
    }
}
