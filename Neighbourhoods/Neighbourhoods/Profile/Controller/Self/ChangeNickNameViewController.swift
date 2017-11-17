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
        
        nickName = nickNameTF.text
        
        //MARK: - change the former vc's property
        let firstVC = self.retSegue?.source as! SelfInfomationTableViewController
        firstVC.nickNameLbl.text = nickName
        
        self.navigationController?.popViewController(animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "修改昵称")
        setRoundRect(targets: [nameBackVIew, confirmChangeBtn])

    }
    

}
