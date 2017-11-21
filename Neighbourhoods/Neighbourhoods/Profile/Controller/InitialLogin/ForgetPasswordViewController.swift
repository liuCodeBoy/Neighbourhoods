//
//  ForgetPasswordViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {
    
    fileprivate var countDownTimer: Timer?
    
    @IBOutlet weak var phoneOrUserName: UITextField!
    @IBOutlet weak var idNumber: UITextField!
    @IBAction func sendIDNuberClicked(_ sender: UIButton) {
        if phoneOrUserName.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入手机号码或用户名")
        }
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phoneOrUserName.text, zone: "86", result: { (error: Error?) in
            if error != nil {
                print(error as Any)
            } else {
                self.phoneOrUserName.endEditing(true)
                self.presentHintMessage(target: self, hintMessgae: "验证码发送成功")
                self.isCounting = true
                
            }
        })
    }
    @IBOutlet weak var sendIDNumberBtn: UIButton!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var confirmPwd: UITextField!
    @IBOutlet weak var confirmChange: UIButton!
    @IBAction func confirmChangeClicked(_ sender: UIButton) {
        if phoneOrUserName.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入手机号码")
            
        } else if phoneOrUserName.text?.isValidePhoneNumber == false {
            self.presentHintMessage(target: self, hintMessgae: "请输入正确的手机号码")
        } else if newPwd.text?.isValidPassword == false {
            self.presentHintMessage(target: self, hintMessgae: "密码应为6-20位字母和数字组合")
        } else if newPwd.text == "" || confirmPwd.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入密码")
        } else if idNumber.text == "" {
            self.presentHintMessage(target: self, hintMessgae: "请输入验证码")
        } else if newPwd.text != confirmPwd.text {
            self.presentHintMessage(target: self, hintMessgae: "您两次输入的密码不一样")
        } else {
            
            
            SMSSDK.commitVerificationCode(idNumber.text!, phoneNumber: phoneOrUserName.text!, zone: "86", result: { (error: Error?) in
                if error != nil {
                    self.presentHintMessage(target: self, hintMessgae: "验证码输入错误")
                } else {
                    weak var weakSelf = self
                    // MARK:- change the pwd and send to server
                    
                    NetWorkTool.shareInstance.forgetPwd(account: self.phoneOrUserName.text!, newpwd: self.newPwd.text!, finished: { [weak self](result, error) in
                        if error != nil {
                            print(error as AnyObject)
                        } else if result!["code"] as! String == "200" {
                            weakSelf?.presentHintMessage(hintMessgae: "密码重置成功", completion: { (_) in
                                self?.navigationController?.popViewController(animated: true)
                            })
                        } else {
                            print(result!["code"] as! String)
                            weakSelf?.presentHintMessage(target: self!, hintMessgae: "修改失败")
                        }
                    })
                    
                    weakSelf?.presentHintMessage(hintMessgae: "修改成功", completion: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    @IBOutlet weak var phoneBackView: UIView!
    @IBOutlet weak var idNumBackView: UIView!
    @IBOutlet weak var confirmPwdBackView: UIView!
    @IBOutlet weak var newPwdBackView: UIView!
    
    fileprivate var remainingSeconds: Int = 0 {
        willSet {
            sendIDNumberBtn.setTitle("重新发送\(newValue)秒", for: .normal)
            if newValue <= 0 {
                sendIDNumberBtn.setTitle("发送验证码", for: .normal)
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
            sendIDNumberBtn.isEnabled = !newValue
        }
    }
    
    @objc fileprivate func updateTime() {
        remainingSeconds -= 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.phoneOrUserName.resignFirstResponder()
        self.idNumber.resignFirstResponder()
        self.newPwd.resignFirstResponder()
        self.confirmPwd.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarAttribute()
        
        self.setRoundRect(targets: [phoneBackView, idNumBackView, confirmPwdBackView, newPwdBackView, sendIDNumberBtn, confirmChange])

    }
    
    func setNavBarAttribute() {
        
        let titleLbl = UILabel()
        titleLbl.text = "忘记密码"
        titleLbl.font = UIFont.systemFont(ofSize: 20)
        titleLbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.titleView = titleLbl
    }




}
