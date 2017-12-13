//
//  SignInViewController.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/12/12.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var scoreLab: UILabel!
    @IBOutlet weak var timesNum: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadSignInDetial()
    }
    
    @IBAction func dissmissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func singInAction(_ sender: Any) {
        signIn()
    }
    
    func signIn() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            presentHintMessage(hintMessgae: "你还未登录", completion: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        NetWorkTool.shareInstance.signIn(access_token) { [weak self](result, error) in
            if error != nil {
                self?.presentHintMessage(hintMessgae: "\(String(describing: error))", completion: { (_) in
                    return
                })
            } else if result!["code"] as! String == "200" {
                self?.presentHintMessage(hintMessgae: "签到成功", completion: { (_) in
                    
                    // MARK:- requset again
                    self?.loadSignInDetial()
                })
            } else if result!["code"] as! String == "401" {
                self?.presentHintMessage(hintMessgae: "签到失败", completion: nil)
            } else {
                self?.presentHintMessage(hintMessgae: "post request failed with exit code \(result!["code"] as! String )", completion: nil)
            }
        }
    }
    
    func loadSignInDetial() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            presentHintMessage(hintMessgae: "你还未登录", completion: { (_) in
                self.dismiss(animated: true, completion: nil)
            })
            return
        }
        NetWorkTool.shareInstance.signInDetial(access_token) { [weak self](result, error) in
            if error != nil {
                self?.presentHintMessage(hintMessgae: "\(String(describing: error))", completion: { (_) in
                    return
                })
            } else if result!["code"] as! String == "200" {
                let resultDict = result!["result"] as! NSDictionary
                let model = SignInDetModel.mj_object(withKeyValues: resultDict)
                
                self?.scoreLab.text = "\(model?.integral! as! Int)"
                self?.timesNum.text = "\(model?.continue_day! as! Int)"
                if model?.is_sign as! Int == 1 {
                    self?.signInBtn.isEnabled = false
                    self?.signInBtn.backgroundColor = UIColor.lightGray

                } else {
                    self?.signInBtn.isEnabled = true
                    self?.signInBtn.backgroundColor = defaultBlueColor
                }

            } else {
                self?.presentHintMessage(hintMessgae: "post request failed with exit code \(result!["code"] as! String )", completion: nil)
            }
        }
    }
    


}
