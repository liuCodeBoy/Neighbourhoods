//
//  SelectDistrictTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SelectDistrictTableViewController: UITableViewController {
    
    var firstLevelList = [SelectDistrictModel]()
    
    var secondVC: SelectDistrictSecondLevelTableViewController?
    
//    var firstDName: String? {
//        didSet {
//            secondVC?.firstDName = self.firstDName
//        }
//    }
    
    
    var pid: Int?
    
    var id: Int? {
        didSet {
            secondVC?.pid        = self.id
            
            secondVC?.district   = self.id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "当前小区")
        
        loadFirstLevel()
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        let ok = UIAlertAction(title: "确定", style: .default) { (_) in
//            let vc = self.retSegue?.source as! SelfInfomationTableViewController
//            vc.discrictLbl.text = self.firstDName
//            
//        }
//        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
//        let alert = UIAlertController(title: "提示", message: "确定选择小区", preferredStyle: .alert)
//        alert.addAction(cancel)
//        alert.addAction(ok)
//        
//        self.present(alert, animated: true, completion: nil)
//    }

    
    func loadFirstLevel() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.selectDistrict(access_token, level: 1, pid: 0) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                for dict in result!["result"] as! [[String : AnyObject]] {
                    let model = SelectDistrictModel.mj_object(withKeyValues: dict)!
                    self.firstLevelList.append(model)
                }
            } else {
                print("post failed with exit code \(String(describing: result!["code"]))")
            }
            self.tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstLevelList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictNameCell")
        guard self.firstLevelList.count > 0 else {
            return cell!
        }
        cell?.textLabel?.text = self.firstLevelList[indexPath.row].name
        return cell!

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = firstLevelList[indexPath.row].id as? Int
        pid = firstLevelList[indexPath.row].pid as? Int
//        firstDName = firstLevelList[indexPath.row].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! SelectDistrictSecondLevelTableViewController
        secondVC = dest
    }
    
    

    
}
