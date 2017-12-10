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
    
    var progressView: UIView?

    @IBAction func confirmChangeClicked(_ sender: UIButton) {
        
        if oldPassword.text == "" || newPassword.text == "" || confirmPassword.text == "" {
            presentHintMessage(hintMessgae: "请填写完整", completion: nil)
            return
        }
        
        if newPassword.text != confirmPassword.text {
            presentHintMessage(hintMessgae: "您输入的两次密码不一样", completion: nil)
            return
        }
        
        if newPassword.text?.isValidPassword == false {
            self.presentHintMessage(hintMessgae: "密码应为6-20位字母和数字组合", completion: nil)
            return
        }
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "修改中"
        self.progressView = progress
        self.view.addSubview(progress)
        //judge whether the old pwd is right
        NetWorkTool.shareInstance.changePwd(access_token, oldpwd: oldPassword.text!, newpwd: newPassword.text!) { [weak self](result, error) in
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "400.4" {
                self?.presentHintMessage(hintMessgae: "您输入的密码有误", completion: nil)
            } else if result!["code"] as! String == "200" {
                
                self?.presentHintMessage(hintMessgae: "密码修改成功", completion: nil)
            } else {
                self?.presentHintMessage(hintMessgae: "修改失败", completion: nil)
                //print("post request failed with exit code \(String(describing: result!["code"]))")
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
