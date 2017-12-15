//
//  InvitationCodeTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 13/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class InvitationCodeTableViewController: UITableViewController {
    
    lazy var coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    var codeListArray = [InvitationCodeModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        setNavBarTitle(title: "我的邀请码")
        loadInvitationCodeDetial()
    }
    
    func loadInvitationCodeDetial() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.myInvitationCode(access_token) { [weak self](result, error) in
            if error != nil {
                self?.presentHintMessage(hintMessgae: "\(error as AnyObject)", completion: { (_) in
                    return
                })
            } else if result!["code"] as! String == "200" && result!["msg"] as! String == "暂无邀请码" {
                self?.coverView.showLab.text = "暂无邀请码"
                self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self?.view.addSubview((self?.coverView)!)
            } else if result!["code"] as! String == "200" {
                for dict in result!["result"] as! [NSDictionary] {
                    let model = InvitationCodeModel.mj_object(withKeyValues: dict)
                    self?.codeListArray.append(model!)
                }
                self?.tableView.reloadData()
            } else {
                self?.presentHintMessage(hintMessgae: "\(result!["code"] as! String)", completion: { (_) in
                    return
                })
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codeListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationCodeCell") as! InvitationCodeTableViewCell
        cell.viewModel = codeListArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }

}
