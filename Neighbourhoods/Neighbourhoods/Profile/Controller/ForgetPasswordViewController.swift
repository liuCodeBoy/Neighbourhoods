//
//  ForgetPasswordViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var phoneOrUserName: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    @IBAction func sendIDNuberClicked(_ sender: UIButton) {
    }
    @IBOutlet weak var sendIDNumberBtn: UIButton!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    @IBOutlet weak var confirmChange: UIButton!
    @IBAction func confirmChangeClicked(_ sender: UIButton) {
    }
    
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var idNumBackView: UIView!
    @IBOutlet weak var confirmPwdBackView: UIView!
    @IBOutlet weak var newPwdBackView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "忘记密码")
        self.setRoundRect(targets: [phoneBackView, idNumBackView, confirmPwdBackView, newPwdBackView, sendIDNumberBtn, confirmChange])

    }



}
