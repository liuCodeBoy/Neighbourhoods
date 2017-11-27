//
//  SelectDistrictThirdLevelTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 15/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let locationNotification = "com.app.profile.location"

class SelectDistrictThirdLevelTableViewController: UITableViewController {
    
    var thirdLevelList = [SelectDistrictModel]()
    
    var progressView: UIView?
    
    var district: Int?
    var dong    : Int?
    var door    : Int?
    
    var pid: Int?
    
    var id: Int? {
        didSet {
            self.door = self.id
        }
    }

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
        
        NetWorkTool.shareInstance.selectDistrict(access_token, level: 3, pid: self.pid!) { [weak self](result, error) in
            
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
                    self?.thirdLevelList.append(model)
                }
            } else {
                print("post failed with exit code \(String(describing: result!["code"]))")
            }
            self?.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thirdLevelList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = thirdLevelList[indexPath.row].id as? Int
        pid = thirdLevelList[indexPath.row].pid as? Int
//        thirdDName = secondDName! + thirdLevelList[indexPath.row].name!
        let ok = UIAlertAction(title: "确定", style: .default) { (_) in
            
            // MARK: - pass data to designate vc
//            NotificationCenter.default.post(name: NSNotification.Name.init(locationNotification), object: self.thirdDName!)

            // MARK:- upload district
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            
            // MARK:- fetching data
            let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
            progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            progress.loadingHintLbl.text = "上传中"
            self.progressView = progress
            self.view.addSubview(progress)
            
            NetWorkTool.shareInstance.upDistrict(access_token, district: self.district!, dong: self.dong!, door: self.door!, finished: { [weak self](result, error) in
                
                // MARK:- data fetched successfully
                UIView.animate(withDuration: 0.25, animations: {
                    self?.progressView?.alpha = 0
                }, completion: { (_) in
                    self?.progressView?.removeFromSuperview()
                })
                
                if error != nil {
                    print(error as AnyObject)
                    self?.presentHintMessage(hintMessgae: error as! String, completion: nil)
                } else if result!["code"] as! String == "200" {
                    let index = self?.navigationController?.viewControllers.index(after: 0)
                    self?.navigationController?.popToViewController((self?.navigationController?.viewControllers[index!])!, animated: true)
                } else {
                    self?.presentHintMessage(hintMessgae: "修改失败", completion: nil)
                    print("post failed with exit code \(String(describing: result!["code"]))")
                }
            })
            // MARK: - pop to designate vc
            
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "提示", message: "确定选择小区？", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(ok)

        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictThirdListCell")
        guard self.thirdLevelList.count > 0 else {
            return cell!
        }
        cell?.textLabel?.text = self.thirdLevelList[indexPath.row].name
        return cell!
    }

}
