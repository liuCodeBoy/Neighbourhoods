//
//  ChangePasswordViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var oldPwdView: UIView!
    @IBOutlet weak var newPwdView: UIView!
    @IBOutlet weak var confirmPwdView: UIView!
    @IBOutlet weak var confirmChangeBtn: UIButton!
    
    @IBAction func confirmChangeClicked(_ sender: UIButton) {
        
        if oldPassword.text == "" || newPassword.text == "" || confirmPassword.text == "" {
            presentHintMessage(target: self, hintMessgae: "请填写完整")
            return
        }
        
        if newPassword.text != confirmPassword.text {
            presentHintMessage(target: self, hintMessgae: "您输入的两次密码不一样")
            return
        }
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        //judge whether the old pwd is right
        NetWorkTool.shareInstance.changePwd(access_token, oldpwd: oldPassword.text!, newpwd: newPassword.text!) { [weak self](result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "400.4" {
                self?.presentHintMessage(target: self, hintMessgae: "您输入的密码有误")
            } else if result!["code"] as! String == "200" {
                self?.presentHintMessage(target: self, hintMessgae: "密码修改成功")
            } else {
                self?.presentHintMessage(target: self, hintMessgae: "修改失败")
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarBackBtn()
        setNavBarTitle(title: "修改密码")
        self.setRoundRect(targets: [oldPwdView, newPwdView, confirmPwdView, confirmChangeBtn])
    }


}
