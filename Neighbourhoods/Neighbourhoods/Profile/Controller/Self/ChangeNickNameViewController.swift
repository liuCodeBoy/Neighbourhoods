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
    
    @IBAction func welcome(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "Welcome", bundle: nil).instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
    }
    @IBOutlet weak var nickNameTF: UITextField!
    @IBAction func confirmChangeBtnClicked(_ sender: UIButton) {
        
        if nickNameTF.text == nil {
            presentHintMessage(hintMessgae: "请输入昵称", completion: nil)
            return
        }
        
        nickName = nickNameTF.text?.replacingOccurrences(of: " ", with: "")
        
        if nickName == "" {
            presentHintMessage(hintMessgae: "昵称不能为空", completion: nil)
            return
        }
        
        
        //MARK: - change the former vc's property
        let firstVC = self.retSegue?.source as! SelfInfomationTableViewController
        firstVC.nickNameLbl.text = nickName
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        // MARK:- upload avatar to the server
        NetWorkTool.shareInstance.updateProfile(access_token, cate: "nickname", content: nickName, content_sex: nil, image: nil, finished: { [weak self](result, error) in
            
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                let source = self?.retSegue?.source as! SelfInfomationTableViewController
                source.nickNameLbl.text = self?.nickName
                self?.presentHintMessage(hintMessgae: "修改成功", completion: nil)
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
