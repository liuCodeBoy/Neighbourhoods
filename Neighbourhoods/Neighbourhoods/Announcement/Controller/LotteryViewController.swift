//
//  LotteryTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
class LotteryViewController: UIViewController{
    var  progressView: UIView?
    lazy var  rotaionArray = [LotteryListModel]()
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
    //添加进度
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.tableview.addSubview(progress)
        self.progressView = progress
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.rotaionArray.removeAll()
        lastedRequest()
    }
    //MARK: - 最新发布网络请求
    func lastedRequest() -> () {
        NetWorkTool.shareInstance.lottery_list() {[weak self](info, error) in
            if info?["code"] as? String == "200"{
              
                let result  = info!["result"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = LotteryListModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                if self?.progressView != nil {
                    self?.progressView?.removeFromSuperview()
                }
                self?.tableview.reloadData()
            }else{
                //服务器error
            }
        }
    }
      //MARK: -   权限控制
    func lottery_judeg(token : String ,id : Int) -> () {
        let detailLotteryDetialVC = self.storyboard?.instantiateViewController(withIdentifier: "LotteryDetialVC") as! LotteryDetialViewController
        let AccessDeniedNotVC = UIStoryboard.init(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "AccessDeniedNotVerified")
        NetWorkTool.shareInstance.lottery_judeg(token, id: id) { (info, error) in
            if info?["code"] as? String == "200"{
                let  result =  "已摇号".compare( info?["msg"] as! String).rawValue
                if result == 0{
                     detailLotteryDetialVC.showText = info?["result"] as? String
                }else{
                     detailLotteryDetialVC.id  = id
                }
                self.navigationController?.pushViewController(detailLotteryDetialVC, animated: true)
            }else if(info?["code"] as? String == "401"){
                //服务器error 
                 self.navigationController?.pushViewController(AccessDeniedNotVC, animated: true)
            }
        }
    }
}

extension LotteryViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LotteryCell") as! LotteryTableViewCell
        if rotaionArray.count > 0 {
         cell.lotterModel = rotaionArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
             self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        if rotaionArray.count > 0 {
        let lotterModel = rotaionArray[indexPath.row]
        guard (lotterModel.status != 1 && lotterModel.status != -1) else {
            return
            }
        }
        if rotaionArray.count > 0 {
        let model = rotaionArray[indexPath.row]
            lottery_judeg(token : UserDefaults.standard.string(forKey: "token")! ,id : model.id as! Int)
     }
        
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

}
