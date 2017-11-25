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

    
    var msgListArray = [MsgListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
//
//                let result  = info!["result"]!["list"] as! [NSDictionary]
//                for i in 0..<result.count {
//                    let taskDict =  result[i]
//                    if  let taskListModel = MsgListModel.mj_object(withKeyValues: taskDict) {
//                        self?.msgListArray.append(taskListModel)
//                    }
//                }
//                self?.tableView.reloadData()
//                if p == self?.pages {
//                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
//                }else{
//                    self?.tableView.mj_footer.endRefreshing()
//                }
//                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
//                    self?.page += 1
//                }
//
//                //服务器
//                self?.tableView.mj_header.endRefreshing()
//                self?.tableView.mj_footer.endRefreshing()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageList") as! MessageListTableViewCell
        
        if msgListArray.count > 0 {
            cell.viewModel = msgListArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
