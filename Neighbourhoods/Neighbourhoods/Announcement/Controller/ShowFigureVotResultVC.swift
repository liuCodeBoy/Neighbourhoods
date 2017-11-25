//
//  ShowFigureVotResultVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/25.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class ShowFigureVotResultVC: UIViewController {
    var  id : NSNumber?
    var  cate : NSNumber?
    var  status : NSNumber?
    lazy var  rotaionArray = [VoteOptionList]()
    @IBOutlet weak var figureVoteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        figureVoteTableView.delegate = self
        figureVoteTableView.dataSource = self
        setNavBarBackBtn()
        setNavBarTitle(title: "投票结束")
        lastedEndRequest( p: 1, status: status as! Int, cate: cate as! Int, id: cate as! Int)
        
    }
    
    
    func lastedEndRequest(p: Int, status: Int, cate: Int, id: Int) -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.option_list(token, p: p, status: status, cate:cate, id: id) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"]!["option"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = VoteOptionList.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.figureVoteTableView.reloadData()
            }else{
                //服务器
                self?.figureVoteTableView.mj_header.endRefreshing()
                self?.figureVoteTableView.mj_footer.endRefreshing()
            }
        }
    }
    
    
    
}

extension ShowFigureVotResultVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell") as! FigureVoteListTableViewCell
        if self.rotaionArray.count > 0 {
            cell.model = self.rotaionArray[indexPath.row]
            cell.rankLbl.text = "NO.\(indexPath.row + 1)"
            cell.voteBtn.setTitle("已投票", for: .normal)

        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

