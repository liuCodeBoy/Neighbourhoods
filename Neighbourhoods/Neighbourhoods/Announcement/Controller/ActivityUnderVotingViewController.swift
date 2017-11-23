//
//  ActivityUnderVotingViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class ActivityUnderVotingViewController: UIViewController {
    var  id : NSNumber?
    var  cate : NSNumber?
    var  status : NSNumber?
    @IBOutlet weak var activityUnderTableView: UITableView!
    lazy var  rotaionArray = [VoteOptionList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        activityUnderTableView.delegate = self
        activityUnderTableView.dataSource = self
        lastedRequest(p: 1, status: status as! Int, cate: cate as! Int, id: id as! Int)

    }

    func lastedRequest(p: Int, status: Int, cate: Int, id: Int) -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.option_list(token, p: p, status: status, cate:cate, id: id) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = VoteOptionList.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.activityUnderTableView.reloadData()
            }else{
                //服务器
            }
        }
    }
}


extension ActivityUnderVotingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "ActivityUnderCellID") as! ActivityUnderVotingCell
        if self.rotaionArray.count > 0 {
            cell.model = self.rotaionArray[indexPath.row]
    
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.rotaionArray.count > 0 {
            let model = self.rotaionArray[indexPath.row]
            var token = ""
            guard (UserDefaults.standard.string(forKey: "token") != nil) else {
                self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
                return
            }
            token = UserDefaults.standard.string(forKey: "token")!
            NetWorkTool.shareInstance.vote(token, vote_id: model.vote_id as! Int, option_id: model.id as! Int, finished: { [weak self](info, error) in
                  let result = info?["result"]
                if info?["code"] as? String == "200"{
                    let config = NoticeBarConfig(title: result as? String, image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                    let noticeBar = NoticeBar(config: config)
                    noticeBar.show(duration: 0.25, completed: {
                        (finished) in
                        if finished {
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }else {
                    let config = NoticeBarConfig(title: result as? String, image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                    let noticeBar = NoticeBar(config: config)
                    noticeBar.show(duration: 0.25, completed: {
                        (finished) in
                        if finished {
                            self?.navigationController?.popViewController(animated: true)
                        }})
                }
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
