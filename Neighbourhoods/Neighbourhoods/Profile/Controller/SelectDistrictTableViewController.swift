//
//  SelectDistrictTableViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let district = ["111", "222", "333", "444", "555", "666", "777", "888", "999", "000"]
class SelectDistrictTableViewController: UITableViewController {
    
    var retSegue: UIStoryboardSegue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        setNavBarTitle(title: "当前小区")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DistrictNameCell")
        
        cell?.textLabel?.text = district[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ok = UIAlertAction(title: "确定", style: .default) { (_) in
            let vc = self.retSegue?.source as! SelfInfomationTableViewController
            vc.discrictLbl.text = district[indexPath.row]
            
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "提示", message: "确定选择小区", preferredStyle: .alert)
        alert.addAction(cancel)
        alert.addAction(ok)

        self.present(alert, animated: true, completion: nil)
        

        
    }
    
    

    
}
