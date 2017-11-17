//
//  ChangeNickNameViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 03/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class ChangeNickNameViewController: UIViewController {

    @IBOutlet weak var nameBackVIew: UIView!
    @IBOutlet weak var confirmChangeBtn: UIButton!
    
    var nickName: String?
    var retSegue: UIStoryboardSegue?
    
    @IBOutlet weak var nickNameTF: UITextField!
    @IBAction func confirmChangeBtnClicked(_ sender: UIButton) {
        
        if nickNameTF.text == nil {
            presentHintMessage(target: self, hintMessgae: "请输入昵称")
            return
        }
        
        nickName = nickNameTF.text?.replacingOccurrences(of: " ", with: "")
        
        if nickName == "" {
            presentHintMessage(target: self, hintMessgae: "昵称不能为空")
            return
        }
        
        
        //MARK: - change the former vc's property
        let firstVC = self.retSegue?.source as! SelfInfomationTableViewController
        firstVC.nickNameLbl.text = nickName
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        // MARK:- upload avatar to the server
        NetWorkTool.shareInstance.updateProfile(access_token, cate: "nickname", content: nickName, image: nil, finished: { (result, error) in
            
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(target: self, hintMessgae: "修改成功")
            } else {
                print("request failed with exit code \(String(describing: result!["code"]))")
            }
        })
        self.navigationController?.popViewController(animated: true)

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "修改昵称")
        setRoundRect(targets: [nameBackVIew, confirmChangeBtn])

    }
    

}
