//
//  LotteryDetailVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/12/11.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class LotteryDetailVC: UIViewController {
    @IBOutlet weak var distictText: UILabel!
    @IBOutlet weak var voteDetailText: UILabel!
    @IBOutlet weak var voteContentTextView: UITextView!
    @IBOutlet weak var voteJoinBtn: UIButton!
    @IBOutlet weak var ownerLab: UILabel!
    @IBOutlet weak var timeDetLab: UILabel!
    var  modeId : NSInteger? {
        didSet{
            //偏好设置
        let uid =  UserDefaults.standard.integer(forKey: "uid")
        NetWorkTool.shareInstance.lottery_det(id: modeId!, uid: uid) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
            let resultDict  = info!["result"] as! NSDictionary
            if  let dictModel = ActListModel.mj_object(withKeyValues: resultDict) {
                self?.distictText.text = dictModel.district
                self?.voteDetailText.text = dictModel.title
                self?.voteContentTextView.text = dictModel.content
                self?.ownerLab.text = dictModel.user
                if  dictModel.is_apply == 1{
                    self?.voteJoinBtn.setTitle("已报名", for: .normal)
                    self?.voteJoinBtn.backgroundColor = UIColor.lightGray
                    self?.voteJoinBtn.isEnabled = false
                }else{
                    self?.voteJoinBtn.setTitle("点击报名", for: .normal)
                    self?.voteJoinBtn.backgroundColor = #colorLiteral(red: 0.3764705956, green: 0.7882353067, blue: 0.9725490212, alpha: 1)
                    self?.voteJoinBtn.isEnabled = true
                 }
                    self?.timeDetLab.text = NSDate.createDateString(createAtStr: "\(dictModel.time ?? 0)")
                }
            }else if info?["code"] as? String == "400"{
                    self?.presentHintMessage(hintMessgae: "查询失败", completion: nil)
            }else{
                self?.presentHintMessage(hintMessgae: "系统错误", completion: nil)
            }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func voteJoinAction(_ sender: Any) {
        let token = UserDefaults.standard.string(forKey: "token")
        guard (token != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        guard self.modeId != nil  else {
            return
        }
        NetWorkTool.shareInstance.userVote(token: token! , id: modeId!) { [weak self](info, error) in
            if info?["code"] as? String == "200"{
                let config = NoticeBarConfig(title:"报名成功", image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: {
                    (finished) in
                    self?.navigationController?.popViewController(animated: true)
                })
            }else if info?["code"] as? String == "400"{
                let config = NoticeBarConfig(title:"你不是该小区成员，无法参与", image: nil, textColor: UIColor.white, backgroundColor: #colorLiteral(red: 0.9882352948, green: 0.2392156869, blue: 0.2235294133, alpha: 1), barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: {
                    (finished) in })
            }else if  info?["code"] as? String == "401"{
                let config = NoticeBarConfig(title:"报名失败", image: nil, textColor: UIColor.white, backgroundColor: #colorLiteral(red: 0.9882352948, green: 0.2392156869, blue: 0.2235294133, alpha: 1), barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: {
                    (finished) in })
            }else{
                self?.presentHintMessage(hintMessgae: "系统错误", completion: nil)
            }
        }
    }

}
