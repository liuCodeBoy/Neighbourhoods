//
//  UploadIDInfomationViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class UploadIDInfomationViewController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var IDNumTF: UITextField!
    
    @IBAction func uploadClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "上传认证信息")


    }


}
