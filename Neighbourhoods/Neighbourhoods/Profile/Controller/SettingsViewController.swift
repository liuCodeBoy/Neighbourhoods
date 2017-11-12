//
//  SettingsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var cacheValue: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    var cacheSpace: Int = 0
    
    @IBAction func notificationSwitchedStatus(_ sender: UISwitch) {
    }
    
    @IBAction func clearCacheClicked(_ sender: UIButton) {
        
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first

        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        
        let alert = UIAlertController(title: "提示", message: "是否清除缓存", preferredStyle: UIAlertControllerStyle.alert)
        
        let alertConfirm = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (alertConfirm) -> Void in
            // 点击确定时开始删除
            for p in files!{
                // 拼接路径
                let path = cachePath!.appendingFormat("/\(p)")
                // 判断是否可以删除
                if(FileManager.default.fileExists(atPath: path)){
                    // 删除
                    try! FileManager.default.removeItem(atPath: path)
                }
            }
            //删除完重新计算
            self.cacheValue.text = "\(self.calculateCache())M"
        }
        alert.addAction(alertConfirm)
        let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel) { (cancle) -> Void in
            
        }
        alert.addAction(cancle)
        // 提示框弹出
        present(alert, animated: true) { () -> Void in
            
        }
    }

    
    @IBOutlet weak var confirmChangeBtn: UIButton!
    
    @IBAction func confirmChangeClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "确认退出", preferredStyle: .alert)
         weak var weakSelf = self
        let ok = UIAlertAction(title: "确认", style: .default, handler: { (_) in
            let deafult = UserDefaults.standard
            deafult.removeObject(forKey: "token")
            deafult.removeObject(forKey: "number")
            deafult.removeObject(forKey: "pwd")
            //登陆界面销毁
//           let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
//           mainVC.dismiss(animated: true, completion: nil)
            weakSelf?.navigationController?.dismiss(animated: true, completion: nil)
        })
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        weakSelf?.present(alert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationSwitch.onTintColor = defaultBlueColor
        setRoundRect(targets: [confirmChangeBtn])
        
        setNavBarBackBtn()
        setNavBarTitle(title: "设置")
        cacheValue.text = "\(calculateCache())M"
    }
    
    func calculateCache() -> Int {
        // 取出cache文件夹路径
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        // 取出文件夹下所有文件数组
        let files = FileManager.default.subpaths(atPath: cachePath!)
        // 用于统计文件夹内所有文件大小
        var big = Int()
        // 快速枚举取出所有文件名
        for p in files!{
            // 把文件名拼接到路径中
            let path = cachePath!.appendingFormat("/\(p)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path)
            // 用元组取出文件大小属性
            for (abc,bcd) in floder {
                // 只去出文件大小进行拼接
                if abc == FileAttributeKey.size{
                    big += (bcd as AnyObject).integerValue
                }
            }
        }
        
        cacheSpace = big/(1024*1024)
        return cacheSpace
    }
}
