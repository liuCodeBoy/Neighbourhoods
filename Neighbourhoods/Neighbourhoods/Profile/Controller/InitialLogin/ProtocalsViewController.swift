//
//  ProtocalsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ProtocalsViewController: UIViewController {
    
    var phoneNumber = ""
    var password = ""
    var idNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        setNavBarTitle(title: "用户协议")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = navAndTabBarTintColor
    }

    @IBAction func refuse(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        
        if phoneNumber == "" {
            self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
            
        } else if phoneNumber.isValidePhoneNumber == false {
            self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
        } else if password.isValidPassword == false {
            self.presentHintMessage(hintMessgae: "密码应为6-20位字母和数字组合", completion: nil)
        } else if password == "" {
            self.presentHintMessage(hintMessgae: "请输入密码", completion: nil)
        } else if idNumber == "" {
            self.presentHintMessage(hintMessgae: "请输入验证码", completion: nil)
        } else {
            if phoneNumber.isValidePhoneNumber == true {
                
                SMSSDK.commitVerificationCode(idNumber, phoneNumber: phoneNumber, zone: "86", result: { (error: Error?) in
                    if error != nil {
                        self.presentHintMessage(hintMessgae: "验证码输入错误", completion: nil)
                    } else {
                        weak var weakSelf = self
                        NetWorkTool.shareInstance.UserRegister((weakSelf?.phoneNumber)!, password: (weakSelf?.password)!, finished: { [weak self](userInfo, error) in
                            if error == nil {
                                // MARK:- judge the return data from server
                                if userInfo!["code"] as! String == "200" {
                                    // MARK:- save token to user dafaults
                                    let token = userInfo!["result"]!["token"]
                                    UserDefaults.standard.setValue(token!, forKey: "token")
                                    let uid = userInfo!["result"]!["uid"]
                                    UserDefaults.standard.setValue(uid!, forKey: "uid")
                                    UserDefaults.standard.synchronize()
                                    
                                    let alert = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
                                    let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                                        // MARK:- show main interface
                                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Welcome")
                                        self?.present(vc!, animated: true, completion: {
                                        })
                                    })
                                    alert.addAction(ok)
                                    weakSelf?.present(alert, animated: true, completion: nil)
                                    
                                } else if userInfo!["code"] as! String == "400" {
                                    self?.presentHintMessage(hintMessgae: "该账号已注册", completion: nil)
                                } else if userInfo!["code"] as! String == "401" {
                                    self?.presentHintMessage(hintMessgae: "注册失败", completion: nil)
                                } else if userInfo!["code"] as! String == "415" {
                                    self?.presentHintMessage(hintMessgae: "错误的请求类型", completion: nil)
                                } else {
                                    //print("post request failed with exit code \(userInfo!["code"] as! String)")
                                }
                                
                                
                                
                                
                            } else {
                                //print(error as AnyObject)
                            }
                        })
                    }
                })
            } else {
                self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
            }
        }
    }
}
