//
//  SelectDistrictSecondLevelTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 15/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SelectDistrictSecondLevelTableViewController: UITableViewController {
    
    var secondLevelList = [SelectDistrictModel]()
    
    var progressView: UIView?

    var district: Int?
    
    var pid: Int?
    
    var id: Int? {
        didSet {
            thirdVC?.pid         = self.id
            
            thirdVC?.district    = self.district
            thirdVC?.dong        = self.id
        }
    }
    
    var thirdVC: SelectDistrictThirdLevelTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "当前小区")

        loadFirstLevel()
    }
    
    func loadFirstLevel() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        NetWorkTool.shareInstance.selectDistrict(access_token, level: 2, pid: self.pid!) { [weak self](result, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                for dict in result!["result"] as! [[String : AnyObject]] {
                    let model = SelectDistrictModel.mj_object(withKeyValues: dict)!
                    self?.secondLevelList.append(model)
                }
            } else {
                print("post failed with exit code \(String(describing: result!["code"]))")
            }
            self?.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secondLevelList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard secondLevelList.count > 0 else {
            return
        }
        id = secondLevelList[indexPath.row].id as? Int
        pid = secondLevelList[indexPath.row].pid as? Int
//        secondDName = firstDName! + secondLevelList[indexPath.row].name!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictSecondListCell")
        guard self.secondLevelList.count > 0 else {
            return cell!
        }
        cell?.textLabel?.text = self.secondLevelList[indexPath.row].name
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SelectDistrictThirdLevelTableViewController
        thirdVC = dest
    }

}
