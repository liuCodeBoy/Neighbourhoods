//
//  IssueMissionViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class IssueMissionViewController: UIViewController {
    @IBOutlet weak var missionTitle: UITextField!
    @IBOutlet weak var missionScoreTF: UITextField!
    @IBOutlet weak var missionDetialTextView: UITextView!
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func issueBtn(_ sender: UIButton) {
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(target: self, hintMessgae:  "你还未登录")
            return
        }
        guard  missionTitle.text != nil else{
            self.presentHintMessage(target: self, hintMessgae:  "话题不能为空")
            return
        }
        guard  missionDetialTextView.text != nil else{
            self.presentHintMessage(target: self, hintMessgae:  "话题描述不能为空")
            return
        }
        guard missionScoreTF.text != nil else {
            self.presentHintMessage(target: self, hintMessgae:  "金币数不能为空")
            return
        }
        NetWorkTool.shareInstance.task_publish(UserDefaults.standard.string(forKey: "token")!, title: missionTitle.text!, content: missionDetialTextView.text!, integral: Int(missionScoreTF.text!)!){ (info, error) in
            if info?["code"] as? String == "200"{
                let config = NoticeBarConfig(title: "发布成功", image: nil, textColor: UIColor.white, backgroundColor: UIColor.blue, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }else {
                let config = NoticeBarConfig(title: "服务器错误", image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
       }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
