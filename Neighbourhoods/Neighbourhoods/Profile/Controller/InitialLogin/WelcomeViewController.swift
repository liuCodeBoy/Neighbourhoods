//
//  WelcomeViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 21/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollPageView: UIScrollView!
    
    @IBOutlet weak var nickNameTF: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    var gender: Int?
    @IBAction func maleBtnClicked(_ sender: UIButton) {
        maleBtn.isSelected = true
        femaleBtn.isSelected = false
        maleBtn.backgroundColor = #colorLiteral(red: 0.250980407, green: 0.5686274767, blue: 0.9254902005, alpha: 1)
        femaleBtn.backgroundColor = UIColor.white
        
    }
    @IBAction func femalBtnClicked(_ sender: UIButton) {
        femaleBtn.isSelected = true
        maleBtn.isSelected = false
        maleBtn.backgroundColor = UIColor.white
        femaleBtn.backgroundColor = #colorLiteral(red: 0.8957495093, green: 0.5784181952, blue: 0.6532259583, alpha: 1)
    }
    
    @IBOutlet weak var enterBtn: UIButton!
    @IBAction func enterBtnClicked(_ sender: UIButton) {
        
        if nickNameTF.text == "" {
            presentHintMessage(hintMessgae: "昵称不能为空", completion: nil)
        } else if (nickNameTF.text?.contains(" "))! {
            presentHintMessage(hintMessgae: "昵称不能含有空格", completion: nil)
        } else if maleBtn.isSelected == false && femaleBtn.isSelected == false {
            presentHintMessage(hintMessgae: "请选择性别", completion: nil)
        } else {
            // MARK:- create user and save to the server
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            if femaleBtn.isSelected {
                gender = 2
            } else if maleBtn.isSelected {
                gender = 1
            }
            NetWorkTool.shareInstance.editNameAndSex(access_token, nickname: self.nickNameTF.text!, sex: gender!, finished: { [weak self](result, error) in
                if error != nil {
                    print(error as AnyObject)
                } else if result!["code"] as! String == "200" {
                    self?.presentHintMessage(hintMessgae: "保存成功", completion: { (_) in
                        UIView.animate(withDuration: 1, animations: {
                            self?.view.alpha = 0
                            UIApplication.shared.keyWindow?.rootViewController = AppDelegate.mainVC
                            
                        }) { (_) in
//                            UIApplication.shared.keyWindow?.rootViewController = AppDelegate.mainVC
                            
                            self?.dismiss(animated: true, completion: {
                            })
                        }
                    })
                } else if result!["code"] as! String == "400" {
                    self?.presentHintMessage(hintMessgae: "查询失败", completion: nil)
                } else {
                    print("post failed with code \(String(describing: result!["code"]))")
                }
            })
            
            
        }
        
    }
    
    @IBOutlet weak var thirdView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollPageView.delegate = self
        
        enterBtn.layer.borderWidth = 1
        enterBtn.layer.borderColor = UIColor.black.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.thirdView.addGestureRecognizer(tap)
        
        
    }

    @objc func hideKeyboard() {
        self.nickNameTF.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.nickNameTF.resignFirstResponder()
    }
    


}
