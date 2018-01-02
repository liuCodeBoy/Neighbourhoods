//
//  CheckForUpdatesViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class CheckForUpdatesTableViewController: UITableViewController {

    @IBOutlet weak var versionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "关于我们")
        setNavBarBackBtn()
        
        versionLbl.text = "V" + localVersion

        
        
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            NetWorkTool.shareInstance.checkVersion(access_token, version_code: localVersion) { [weak self](result, error) in
                if result!["code"] as! String == "200" {
                    let alert = UIAlertController(title: "提示", message: "检查到新版本，是否更新？", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "更新", style: .default, handler: { (_) in
                        // MARK:- jump to app store
                        let AppID = "1316363309"
                        if let URL = NSURL(string: "https://itunes.apple.com/us/app/id\(AppID)?ls=1&mt=8") {
                            UIApplication.shared.openURL(URL as URL)
                        }
                        
                        
                    })
                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    
                    alert.addAction(cancel)
                    alert.addAction(ok)
                    
                    self?.present(alert, animated: true, completion: nil)
                } else {
                    self?.presentHintMessage(hintMessgae: "目前已是最新版本", completion: nil)
                }
            }
           
        }
    }


}
