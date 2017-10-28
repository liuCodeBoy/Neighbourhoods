//
//  RegisterViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var pwdBackView: UIView!
    @IBOutlet weak var confirmBackView: UIView!
    @IBOutlet weak var sendIDNumBackVIew: UIButton!
    @IBOutlet weak var registerBackView: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRoundRect(targets: [phoneBackView, pwdBackView, confirmBackView, sendIDNumBackVIew, registerBackView])
        
        // MARK:- set nav bar attribute
        setNavBarAttribute()
    }
    
    func setNavBarAttribute() {

        let titleLbl = UILabel()
        titleLbl.text = "注册"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navBar.titleView = titleLbl
        let back = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .done, target: self, action: #selector(pop))
        self.navBar.setLeftBarButton(back, animated: true)
    }
    
    @IBAction func registeAction(_ sender: Any) {
        if phoneNumber.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入手机号码")
            
        } else if phoneNumber.text?.isValidePhoneNumber == false {
            self.presentHintMessage(target: self, hintMessgae: "请输入正确的手机号码")
        } else if password.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入密码")
        } else if idNumber.text != "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入验证码")
        } else {
            if phoneNumber.text!.isValidePhoneNumber == true {
                
                SMSSDK.commitVerificationCode(idNumber.text!, phoneNumber: phoneNumber.text!, zone: "86", result: { (error: Error?) in
                    if error != nil {
                        self.presentHintMessage(target: self, hintMessgae: "验证码输入错误")
                    } else {
                        weak var weakSelf = self
                        NetWorkTool.shareInstance.UserRegister((weakSelf?.phoneNumber.text!)!, password: (weakSelf?.password.text!)!, finished: { (userInfo, error) in
                            if error == nil {
                                //存储手机号码和密码
                                //MARK: - bug fix
//                                sender.saveUserData(phone: self.phoneNumber.text!, password: self.password.text!, token: "")
                                //存储数据到服务器
                                let alert = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
                                let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                                    //登陆界面销毁
                                    weakSelf?.navigationController?.popToRootViewController(animated: true)
                                })
                                alert.addAction(ok)
                                weakSelf?.present(alert, animated: true, completion: nil)
                                
                            }
                        })
                    }
                })
            } else {
                self.presentHintMessage(target: self, hintMessgae: "请输入正确的手机号码")
            }
        }
        
        
    }
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension UIViewController {
    
    
    
    func presentHintMessage(target: UIViewController, hintMessgae: String) {
        let alert = UIAlertController(title: "提示", message: hintMessgae, preferredStyle: .alert)
        let ok = UIAlertAction(title: "好的", style: .cancel, handler: nil)
        alert.addAction(ok)
        target.present(alert, animated: true, completion: nil)
    }
}
extension String {
    
    var isValidePhoneNumber: Bool {
        get {
            let mobileRE: String = "^((13[0-9])|(147)|(15[0-3,5-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
            let regex = NSPredicate(format: "SELF MATCHES %@", mobileRE)
            
            if regex.evaluate(with: self) == true {
                return true
            } else {
                return false
            }
        }
        
        set {
            
        }
    }
}

