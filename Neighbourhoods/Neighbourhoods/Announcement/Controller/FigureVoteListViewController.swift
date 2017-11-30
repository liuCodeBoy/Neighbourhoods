//
//  FigureVoteListViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
class FigureVoteListViewController: UIViewController {
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
        setNavBarTitle(title: "正在投票")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        rotaionArray.removeAll()
        
        lastedRequest( p: 1, status: status as! Int, cate: cate as! Int, id: id as! Int)
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
                self?.figureVoteTableView.reloadData()
                }else{
                //服务器
                self?.figureVoteTableView.mj_header.endRefreshing()
                self?.figureVoteTableView.mj_footer.endRefreshing()
                }
            }
     }
    
    
}

extension FigureVoteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let  cell =  tableView.dequeueReusableCell(withIdentifier: "FigureVoteCell") as! FigureVoteListTableViewCell
        if self.rotaionArray.count > 0 {
            cell.model = self.rotaionArray[indexPath.row]
            cell.rankLbl.text = "NO.\(indexPath.row + 1)"
        }
        
        //跳出用户详情
        cell.headImagePushClouse = { (otherID) in
            let userInfoVc = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "OthersMomentsID") as? OthersMomentsViewController
            userInfoVc?.uid = otherID as? Int
            if  UserDefaults.standard.string(forKey: "token") == nil{
                self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            }else{
                self.navigationController?.pushViewController(userInfoVc!, animated: true)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      let   figureVoteDetialVC =   self.storyboard?.instantiateViewController(withIdentifier: "FigureVoteDetialVCID") as! FigureVoteDetialViewController
        if self.rotaionArray.count > 0 {
            let model = self.rotaionArray[indexPath.row]
            figureVoteDetialVC.index = indexPath.row + 1
            figureVoteDetialVC.id = model.id
            figureVoteDetialVC.voteId = self.id
            figureVoteDetialVC.chooseId = model.vote_id
        }
        self.navigationController?.pushViewController(figureVoteDetialVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
