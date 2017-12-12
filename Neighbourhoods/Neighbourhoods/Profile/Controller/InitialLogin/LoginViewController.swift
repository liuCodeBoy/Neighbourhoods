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
            self.presentHintMessage(hintMessgae: "请输入手机号码", completion: nil)
        } else if phoneNumber.text?.isValidePhoneNumber == false {
            self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
        } else if password.text == "" {
            self.presentHintMessage(hintMessgae: "请输入密码", completion: nil)
        } else if phoneNumber.text?.isValidePhoneNumber == true {
            //检查密码是否与服务器数据匹配
            weak var weakSelf = self
            NetWorkTool.shareInstance.UserLogin((weakSelf?.phoneNumber.text)!, password: (weakSelf?.password.text)!, type: "pas", finished: { [weak self](userInfo, error) in
                if error == nil {
                    let  userInfoDict = userInfo!
                    let loginStaus =  userInfoDict["code"] as? String
                    if  loginStaus == "200" {
                        let  resultDict = userInfoDict["result"] as? NSDictionary
                        if  let token = resultDict?["token"]{
                            //偏好设置
                            let userDefault =  UserDefaults.standard
                            //存储数据
                            userDefault.set(token, forKey: "token")
                            userDefault.set(self?.phoneNumber.text ,forKey: "number")
                            userDefault.set(self?.password.text, forKey: "pwd")
                            //同步数据
                            userDefault.synchronize()
                        }
                        if  let uid = resultDict?["uid"]{
                            //偏好设置
                            let userDefault =  UserDefaults.standard
                            //存储数据
                            userDefault.set(uid, forKey: "uid")
                            //同步数据
                            userDefault.synchronize()
                        } else {
                            return
                        }
                        if  let token = resultDict?["token"]{
                            //偏好设置
                            let userDefault =  UserDefaults.standard
                            //存储数据
                            userDefault.set(token, forKey: "token")
                            userDefault.set(self?.phoneNumber.text ,forKey: "number")
                            userDefault.set(self?.password.text, forKey: "pwd")
                            //同步数据
                            userDefault.synchronize()
                        } else {
                            return
                        }
                        // MARK:- login in JMessage
                        JMSGUser.login(withUsername: (self?.phoneNumber.text)!, password: "llb2580.", completionHandler: { (_, error) in
                            if error != nil {
                                self?.presentHintMessage(hintMessgae: "IM login failed", completion: nil)
                            }
                            // MARK:- save uid to IM server
                            JMSGUser.updateMyInfo(withParameter:  UserDefaults.standard.string(forKey: "uid")!, userFieldType: .fieldsAddress, completionHandler: { (_, error) in
                                if error != nil {
                                    self?.presentHintMessage(hintMessgae: "IM uid save failed", completion: nil)
                                }
                            })
                        })
                        
                        
                        let alert = UIAlertController(title: "提示", message: "登录成功", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                            //登陆界面销毁
                            let window = UIApplication.shared.delegate?.window as? UIWindow
                            window?.rootViewController = AppDelegate.mainVC
                        })
                        alert.addAction(ok)
                        weakSelf?.present(alert, animated: true, completion: nil)
                    }else{
                        //print("login failed with post request exit code \(String(describing: userInfoDict["code"] as? String))")
                        let alert = UIAlertController(title: "登录失败", message: "请检查账号密码后重试", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "好的", style: .default, handler: { (_) in
                            
                        })
                        alert.addAction(ok)
                        weakSelf?.present(alert, animated: true, completion: nil)
                    }
                }
            })
            
        } else {
            self.presentHintMessage(hintMessgae: "请输入正确的手机号码", completion: nil)
        }
        
    }
    // MARK:- Passenger login
    @IBAction func passengerLoginClicked(_ sender: UIButton) {
            //偏好设置
            let userDefault =  UserDefaults.standard
            //存储数据
            userDefault.set(0, forKey: "uid")
            //同步数据
            userDefault.synchronize()
        
        let window = UIApplication.shared.delegate?.window as? UIWindow
        window?.rootViewController = AppDelegate.mainVC
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumber.resignFirstResponder()
        password.resignFirstResponder()
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
