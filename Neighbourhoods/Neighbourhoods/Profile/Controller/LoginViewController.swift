//
//  LoginViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import TZImagePickerController

class LoginViewController: UIViewController ,TZImagePickerControllerDelegate {
    
    @IBOutlet weak var accountBackView: UIView!
    @IBOutlet weak var pwdBackView: UIView!
    @IBOutlet weak var loginBtnBackView: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var navBar: UINavigationItem!

    @IBAction func userLoginClick(_ sender: Any) {
        
        if phoneNumber.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入手机号码")
        } else if phoneNumber.text?.isValidePhoneNumber == false {
            self.presentHintMessage(target: self, hintMessgae: "请输入正确的手机号码")
        } else if password.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入密码")
        } else if phoneNumber.text?.isValidePhoneNumber == true {
            //检查密码是否与服务器数据匹配
            weak var weakSelf = self
            NetWorkTool.shareInstance.UserLogin((weakSelf?.phoneNumber.text)!, password: (weakSelf?.password.text)!, type: "pas", finished: { (userInfo, error) in
                if error == nil {
                    let  userInfoDict = userInfo!
                    let loginStaus =  userInfoDict["code"] as? String
                    if  loginStaus == "200" {
                        let  resultDict = userInfoDict["result"] as? NSDictionary
                        let token = resultDict?["token"]
                        // 存储手机号码
//                        sender.savePhoneNumber(phone: (weakSelf?.phoneNumber.text!)!, token: token as! String)
                        let alert = UIAlertController(title: "提示", message: "登录成功", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
//                            isLogin = true
                            //发送值到profileVC
//                            NotificationCenter.default.post(name: isLoginNotification, object: nil)
                            //登陆界面销毁
                            weakSelf?.navigationController?.popToRootViewController(animated: true)
                        })
                        alert.addAction(ok)
                        weakSelf?.present(alert, animated: true, completion: nil)
                    }else{
//                        SVProgressHUD.showError(withStatus:userInfoDict["msg"]! as! String )
                    }
                }
            })
            
        } else {
            self.presentHintMessage(target: self, hintMessgae: "请输入正确的手机号码")
        }
        
    }
    // MARK:- Passenger login
    @IBAction func passengerLoginClicked(_ sender: UIButton) {
       let mainVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
        self.present(mainVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRoundRect(targets: [accountBackView, pwdBackView, loginBtnBackView])
        
        setNavBarAttribute()
        
    }
    
    func setNavBarAttribute() {
        let titleLbl = UILabel()
        titleLbl.text = "登录注册"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navBar.titleView = titleLbl
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = navAndTabBarTintColor
        
        
    }

}
