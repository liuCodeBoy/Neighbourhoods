//
//  MessagesListViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class MessagesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView

    var msgListArray = [MsgListModel]()
    
    var destnation: ChattingViewController? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setNavBarBackBtn()
        setNavBarTitle(title: "私信")
        
        loadData()
        
        coverView.showLab.text = "暂无消息"
        coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.view.addSubview(coverView)

    }
    
    func loadData() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.infoList(access_token) { [weak self](result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                if let result = result!["result"] as? [[String: AnyObject]] {
                    for dict in result {
                        if let model = MsgListModel.mj_object(withKeyValues: dict) {
                            self?.msgListArray.append(model)
                        }
                    }
                    self?.tableView.reloadData()
                    if CGFloat((self?.msgListArray.count)!) > 0 {
                        self?.coverView.removeFromSuperview()
                    }
                } else {
                    return
                }
                
            } else {
                print("post request failed with exit code \(result!["code"] as! String)")
            }
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell") as! MessageListTableViewCell
        
        if msgListArray.count > 0 {
            cell.viewModel = msgListArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK:- pass dest user's uid to next vc
        destnation?.to_uid = msgListArray[indexPath.row].from_user?.uid as? Int
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ChattingViewController
        self.destnation = dest
        
    }
    
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//
//    //MARK: - left slide to delete row
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        //TODO: remove form data source
//        if editingStyle == .delete {
//            tempCellData.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除"
//    }

    

}
