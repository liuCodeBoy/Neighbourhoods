//
//  RegisterViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    fileprivate var countDownTimer: Timer?
    
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var pwdBackView: UIView!
    @IBOutlet weak var confirmBackView: UIView!
    @IBOutlet weak var sendIDNumBackVIew: UIButton!
    @IBOutlet weak var registerBackView: UIButton!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
                sendIDNumBackVIew.setTitle("重新发送\(newValue)秒", for: .normal)
            if newValue <= 0 {
                sendIDNumBackVIew.setTitle("发送验证码", for: .normal)
                isCounting = false
            }
        }
    }
    
    fileprivate var isCounting = false {
        willSet {
            if newValue {
                countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 60
            } else {
                countDownTimer?.invalidate()
                countDownTimer = nil
            }
            sendIDNumBackVIew.isEnabled = !newValue
        }
    }
    
    @objc fileprivate func updateTime() {
        remainingSeconds -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setRoundRect(targets: [phoneBackView, pwdBackView, confirmBackView, sendIDNumBackVIew, registerBackView])
        // MARK:- set nav bar attribute
        setNavBarAttribute()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.idNumber.resignFirstResponder()
        self.password.resignFirstResponder()
        self.phoneNumber.resignFirstResponder()
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
    @IBAction func sendIDNumAction(_ sender: Any) {
        if phoneNumber.text == "" {
            self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
        }
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneNumber.text, zone: "86", result: { (error: Error?) in
            if error != nil {
                print(error as Any)
            } else {
                self.phoneNumber.endEditing(true)
                self.presentHintMessage(hintMessgae: "验证码发送成功", completion: nil)
                self.isCounting = true
                
            }
        })
    }
    
    @IBAction func registeAction(_ sender: Any) {
        if phoneNumber.text == "" {
            self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
            
        } else if phoneNumber.text?.isValidePhoneNumber == false {
            self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
        } else if password.text?.isValidPassword == false {
            self.presentHintMessage(hintMessgae: "密码应为6-20位字母和数字组合", completion: nil)
        } else if password.text == "" {
            self.presentHintMessage(hintMessgae: "请输入密码", completion: nil)
        } else if idNumber.text == "" {
            self.presentHintMessage(hintMessgae: "请输入验证码", completion: nil)
        } else {
            if phoneNumber.text!.isValidePhoneNumber == true {
                
//                SMSSDK.commitVerificationCode(idNumber.text!, phoneNumber: phoneNumber.text!, zone: "86", result: { (error: Error?) in
//                    if error != nil {
//                        self.presentHintMessage(target: self, hintMessgae: "验证码输入错误")
//                    } else {
//                        weak var weakSelf = self
//                        NetWorkTool.shareInstance.UserRegister((weakSelf?.phoneNumber.text!)!, password: (weakSelf?.password.text!)!, finished: { [weak self](userInfo, error) in
//                            if error == nil {
//                                //存储数据到服务器
//                                let alert = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
//                                let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
//                                    //登陆界面销毁
//                                    weakSelf?.navigationController?.popToRootViewController(animated: true)
//                                })
//                                alert.addAction(ok)
//                                weakSelf?.present(alert, animated: true, completion: nil)
//
//                            }
//                        })
//                    }
//                })
                
                presentHintMessage(hintMessgae: "success", completion: { (_) in
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome")
                    self.present(vc!, animated: true, completion: {
                       
                    })
                })
            } else {
                self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
            
     
            }
        }
        
        
    }
    
    @objc func pop() {
        self.navigationController?.popViewController(animated: true)
    }

}



