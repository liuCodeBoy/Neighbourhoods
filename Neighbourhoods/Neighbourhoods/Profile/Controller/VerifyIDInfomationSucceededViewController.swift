//
//  VerifyIDInfomationSucceededViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class VerifyIDInfomationSucceededViewController: UIViewController {
    
    @IBOutlet weak var realNameLbl: UILabel!
    @IBOutlet weak var idNumLbl: UILabel!
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "认证通过")

    }



}
