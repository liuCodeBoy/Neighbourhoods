//
//  EditProfileViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 27/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var editTableVIew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTableVIew.delegate = self
        editTableVIew.dataSource = self
        self.setNavBarTitle(title: "我的")
        self.setNavBarBackBtn()

    }

}

extension EditProfileViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEditingCell")
        
        switch indexPath.row {
        case 0: cell?.textLabel?.text = "个人资料"
        case 1: cell?.textLabel?.text = "修改密码"
        case 2: cell?.textLabel?.text = "我的认证"
        case 3: cell?.textLabel?.text = "我的地址"
        case 4: cell?.textLabel?.text = "意见反馈"
        case 5: cell?.textLabel?.text = "关于我们"
        default: cell?.textLabel?.text = ""
            
        }
        
        return cell!
    }
}
