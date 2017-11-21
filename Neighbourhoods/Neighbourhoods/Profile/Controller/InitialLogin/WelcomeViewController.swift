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
            presentHintMessage(target: self, hintMessgae: "昵称不能为空")
        } else if (nickNameTF.text?.contains(" "))! {
            presentHintMessage(target: self, hintMessgae: "昵称不能含有空格")
        } else if maleBtn.isSelected == false && femaleBtn.isSelected == false {
            presentHintMessage(target: self, hintMessgae: "请选择性别")
        } else {
            // MARK:- create user and save to the server
            
            
            UIView.animate(withDuration: 1, animations: {
                self.view.alpha = 0
                UIApplication.shared.keyWindow?.rootViewController = AppDelegate.mainVC
                
            }) { (_) in
//                UIApplication.shared.keyWindow?.rootViewController = AppDelegate.mainVC
                
                self.dismiss(animated: true, completion: {
                })
            }
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
