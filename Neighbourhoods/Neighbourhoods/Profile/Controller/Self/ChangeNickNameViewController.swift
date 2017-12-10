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
    
    var progressView: UIView?

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
        
        if (CGFloat((nickNameTF.text?.count)!) > 8) == true {
            self.presentHintMessage(hintMessgae: "昵称不能超过8个字", completion: nil)
            return
        }
        
        
        //MARK: - change the former vc's property
        let firstVC = self.retSegue?.source as! SelfInfomationTableViewController
        firstVC.nickNameLbl.text = nickName
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "提交中"
        self.progressView = progress
        self.view.addSubview(progress)
        // MARK:- upload avatar to the server
        NetWorkTool.shareInstance.updateProfile(access_token, cate: "nickname", content: nickName, content_sex: nil, image: nil, finished: { [weak self](result, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            // MARK:- update JMessage
            JMSGUser.updateMyInfo(withParameter: (self?.nickNameTF.text)!, userFieldType: .fieldsNickname, completionHandler: nil)
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                let source = self?.retSegue?.source as! SelfInfomationTableViewController
                source.nickNameLbl.text = self?.nickName
                self?.presentHintMessage(hintMessgae: "修改成功", completion: nil)
            } else {
                //print("request failed with exit code \(String(describing: result!["code"]))")
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
