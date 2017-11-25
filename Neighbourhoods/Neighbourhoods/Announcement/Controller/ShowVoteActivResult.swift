//
//  ShowVoteActivResult.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/23.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

class ShowVoteActivResult: UIViewController {
    var  id : NSNumber?
    var  cate : NSNumber?
    var  status : NSNumber?
    var  number : NSNumber?
    @IBOutlet weak var voteResultTableView: UITableView!
    
    lazy var  rotaionArray = [VoteResultModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        voteResultTableView.delegate = self
        voteResultTableView.dataSource = self
        lastedRequest(p: 1 , status: status as! Int, cate: cate as! Int, id: id as! Int)
        
    }
    

    //MARK: - 最新发布网络请求
    func lastedRequest(p: Int, status: Int, cate: Int, id: Int) -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.option_list(token, p: p, status: status, cate:cate, id: id) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                self?.number = info!["result"]!["number"] as? NSNumber
                let result  = info!["result"]!["option"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = VoteResultModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.voteResultTableView.reloadData()
            }else{
                //服务器
 
            }
        }
    }
}

extension ShowVoteActivResult: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell =  tableView.dequeueReusableCell(withIdentifier: "ShowVoteActCellID") as! ShowVoteActCell
        if self.rotaionArray.count > 0 {
            cell.model = self.rotaionArray[indexPath.row]
        }
        return cell
    }
    

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.rotaionArray.count
        }



     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 90
        }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          let numberView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
          let numLabel = UILabel.init(frame: CGRect.init(x: screenWidth - 150, y: 0, width: 150, height: 50))
          numLabel.textColor = UIColor.lightGray
          guard self.number != nil else {
            return numberView
          }
          numLabel.text = "已有\(String(describing: self.number!))人投票"
          numberView.addSubview(numLabel)
          return  numberView
    }
}

