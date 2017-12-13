//
//  EvaluationDetialTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 12/12/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class EvaluationDetialTableViewController: UITableViewController {
    
    var progressView: UIView?
    
    var uid: Int = UserDefaults.standard.integer(forKey: "uid")

    lazy var coverView = Bundle.main.loadNibNamed("NoMissionCoverView", owner: nil, options: nil)?.first as! NoMissionCoverView
    
    var evaluationArray = [EvaluationDetModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarTitle(title: "评价详情")
        setNavBarBackBtn()
        
        laodEvaluationDetial()
        
        // MARK:- set table view height
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func laodEvaluationDetial() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        NetWorkTool.shareInstance.checkEvaluation(access_token, uid: uid) { [weak self](result, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                self?.presentHintMessage(hintMessgae: "\(String(describing: error))", completion: { (_) in
                    return
                })
            } else if result!["code"] as! String == "400" {
                // MARK:- no evaluation
                self?.coverView.showLab.text = "暂无评价"
                self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                self?.tableView.addSubview((self?.coverView)!)
                return
                
            } else if result!["code"] as! String == "200" {
                
                guard let dictArray = result!["result"] as? [NSDictionary] else {
                    self?.coverView.showLab.text = "暂无评价"
                    self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                    self?.tableView.addSubview((self?.coverView)!)
                    return
                }
                
                for userDict in dictArray {
                    if let listModel = EvaluationDetModel.mj_object(withKeyValues: userDict) {
                        self?.evaluationArray.append(listModel)
                    }
                }
                self?.tableView.reloadData()
                
                if let count = self?.evaluationArray.count {
                    if CGFloat(count) == 0 {
                        self?.coverView.showLab.text = "暂无评价"
                        self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
                        self?.view.addSubview((self?.coverView)!)
                    }
                }
                
            } else {
                self?.presentHintMessage(hintMessgae: "post requst failed with exit code \(result!["code"] as! String)", completion: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evaluationArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluationDetialCell") as! EvaluationDetialTableViewCell
        cell.viewModel = evaluationArray[indexPath.row]
        cell.pushImageClouse = {(imageArr, index) in
            let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "ImageShowVCID") as!  ImageShowVC
            desVC.index  = index
            desVC.imageArr = imageArr
            self.present(desVC, animated: true, completion: nil)
        }
        return cell
    }

}
