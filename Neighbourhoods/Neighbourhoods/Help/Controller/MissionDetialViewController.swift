//
//  MissionDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 31/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

class MissionDetialViewController: UIViewController {

    var missionID: Int? {
        didSet {
            guard let id = self.missionID else {
                return
            }
            
            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
                return
            }
            NetWorkTool.shareInstance.taskDet(access_token, id: id) { [weak self](info, error) in
                if info?["code"] as? String == "200"{
                    let result = info!["result"] as! NSDictionary
                    self?.viewModel = TaskDetModel.mj_object(withKeyValues: result)
                }
            }
        }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var cartifyLbl: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var marginView: UIView!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detialLbl: UILabel!
    @IBOutlet weak var missionStatusBtn1: UIButton!
    @IBOutlet weak var missionStatusBtn2: UIButton!
    @IBOutlet weak var missionStatusBtn3: UIButton!
    @IBOutlet weak var receiverAvatar: UIImageView!
    @IBOutlet weak var receiveStatusLbl: UILabel!
    
    var viewModel: TaskDetModel? {
        didSet {
            if let avatarStr = viewModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatarStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let userName = viewModel?.user?.nickname {
                self.nickName.text = userName
            }
            if let verify = viewModel?.user?.type {
                cartifyLbl.text = " " + verify + " "
            }
            if let location = viewModel?.user?.address {
                if location == "" {
                    self.location.text = location
                    self.locationImg.isHidden = true
                }
            }
            if let gender = viewModel?.user?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2 {
                    self.gender.image = #imageLiteral(resourceName: "female")
                } else {
                    self.gender.isHidden = true
                }
            }
            if let score = viewModel?.integral {
                self.scoreBtn.setTitle("\(score)", for: .normal)
            }
            if let title = viewModel?.title {
                self.titleLbl.text = title
            }
            if let detial = viewModel?.content {
                self.detialLbl.text = detial
            }
            if let receiveUserAvatar = viewModel?.receive?.head_pic, let receiveUserInfo = viewModel?.receive?.nickname {
                self.receiverAvatar.sd_setImage(with: URL.init(string: receiveUserAvatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
                self.receiveStatusLbl.text = receiveUserInfo + "已领取任务"
                self.receiverAvatar.isHidden   = false
                self.receiveStatusLbl.isHidden = false
            } else {
                self.receiverAvatar.isHidden   = true
                self.receiveStatusLbl.isHidden = true
            }
            if let missionStatus = viewModel?.task_status {
                if let user = viewModel?.is_user {
                    switch user {
                    // mission's host
                    case 1:
                        switch missionStatus {
                        case 0:
                            missionStatusBtn1.isHidden = true
                            missionStatusBtn2.isHidden = false
                            missionStatusBtn3.isHidden = false
                            
                            missionStatusBtn2.setTitle("待领取", for: .normal)
                            missionStatusBtn2.backgroundColor = mission_complete
                            missionStatusBtn3.setTitle("取消任务", for: .normal)
                            missionStatusBtn3.addTarget(self, action: #selector(userCancelMission), for: .touchUpInside)
                            missionStatusBtn3.backgroundColor = mission_going
                        case 1:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true

                            missionStatusBtn1.setTitle("进行中", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        case 2:
                            missionStatusBtn1.isHidden = true
                            missionStatusBtn2.isHidden = false
                            missionStatusBtn3.isHidden = false
                            self.receiveStatusLbl.text = (viewModel?.receive?.nickname!)! + "已提交任务"
                            missionStatusBtn2.setTitle("确认完成", for: .normal)
                            missionStatusBtn2.backgroundColor = mission_complete
                            missionStatusBtn2.addTarget(self, action: #selector(userConfirmMissionComplete), for: .touchUpInside)
                            
                            missionStatusBtn3.setTitle("驳回", for: .normal)
                            missionStatusBtn3.backgroundColor = mission_going
                            missionStatusBtn3.addTarget(self, action: #selector(userRejectMission), for: .touchUpInside)
                        case 3:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            self.receiveStatusLbl.text = (viewModel?.receive?.nickname!)! + "已完成任务"
                            missionStatusBtn1.setTitle("已确认", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_complete
                        case 4:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("已驳回", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        default: break
                        }
                    // mission's receiver
                    case 2:
                        switch missionStatus {
                        case 0:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("领取任务", for: .normal)
                            missionStatusBtn1.addTarget(self, action: #selector(userReceiveMission), for: .touchUpInside)
                            missionStatusBtn3.backgroundColor = mission_complete
                        case 1:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("提交任务", for: .normal)
                            missionStatusBtn1.addTarget(self, action: #selector(userSubmitMission), for: .touchUpInside)
                            missionStatusBtn1.backgroundColor = mission_going
                        case 2:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("待确认", for: .normal)
                            missionStatusBtn3.backgroundColor = mission_going
                        case 3:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            self.receiveStatusLbl.text = (viewModel?.receive?.nickname!)! + "已完成任务"
                            missionStatusBtn1.setTitle("已完成", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_complete
                        case 4:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("被驳回", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        default: break
                        }
                    // other people
                    // interaction disabled
                    case 3:
                        switch missionStatus {
                        case 0:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("领取任务", for: .normal)
                            missionStatusBtn1.addTarget(self, action: #selector(userReceiveMission), for: .touchUpInside)
                            missionStatusBtn3.backgroundColor = mission_complete
                        case 1:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("进行中", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        case 2:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            self.receiveStatusLbl.text = (viewModel?.receive?.nickname!)! + "已提交任务"
                            missionStatusBtn1.setTitle("进行中", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        case 3:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            self.receiveStatusLbl.text = (viewModel?.receive?.nickname!)! + "已完成任务"
                            missionStatusBtn1.setTitle("已完成", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_complete
                        case 4:
                            missionStatusBtn1.isHidden = false
                            missionStatusBtn2.isHidden = true
                            missionStatusBtn3.isHidden = true
                            
                            missionStatusBtn1.setTitle("已驳回", for: .normal)
                            missionStatusBtn1.backgroundColor = mission_going
                        default: break
                        }
                        
                    default: break
                    }
                }
                
            }

        }
        
    }
    
//    var id: Int? {
//        didSet {
//            guard let id = self.id else {
//                return
//            }
//
//            guard let access_token = UserDefaults.standard.string(forKey: "token") else {
//                return
//            }
//            NetWorkTool.shareInstance.taskDet(access_token, id: id) { [weak self](info, error) in
//                if info?["code"] as? String == "200"{
//                    let result = info!["result"] as! NSDictionary
//                    self?.viewModel = TaskDetModel.mj_object(withKeyValues: result)
//                }
//            }
//        }
//    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
//            return
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func userCancelMission() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.cancelTask(access_token, id: self.missionID!) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(hintMessgae: "任务删除成功", completion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else if result!["code"] as! String == "401" {
                self.presentHintMessage(target: self, hintMessgae: "任务删除失败")
            } else if result!["code"] as! String == "403" {
                self.presentHintMessage(target: self, hintMessgae: "任务进行中，无法删除")
            } else {
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    
    @objc func userReceiveMission() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.receiveTask(access_token, id: self.missionID!) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(hintMessgae: "领取成功", completion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    
    @objc func userSubmitMission() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.operateTask(access_token, id: self.missionID!, type: .submit) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(hintMessgae: "提交成功", completion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else if result!["code"] as! String == "401" {
                self.presentHintMessage(target: self, hintMessgae: "提交失败")
            } else if result!["code"] as! String == "400" {
                self.presentHintMessage(target: self, hintMessgae: "查询失败")
            } else {
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    
    @objc func userConfirmMissionComplete() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.operateTask(access_token, id: self.missionID!, type: .done) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(hintMessgae: "确认成功", completion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else if result!["code"] as! String == "401" {
                self.presentHintMessage(target: self, hintMessgae: "确认失败")
            } else if result!["code"] as! String == "400" {
                self.presentHintMessage(target: self, hintMessgae: "查询失败")
            } else {
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }
    
    @objc func userRejectMission() {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        NetWorkTool.shareInstance.operateTask(access_token, id: self.missionID!, type: .reject) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self.presentHintMessage(hintMessgae: "驳回成功", completion: { (_) in
                    self.navigationController?.popViewController(animated: true)
                })
            } else if result!["code"] as! String == "401" {
                self.presentHintMessage(target: self, hintMessgae: "驳回失败")
            } else if result!["code"] as! String == "400" {
                self.presentHintMessage(target: self, hintMessgae: "查询失败")
            } else {
                print("post request failed with exit code \(String(describing: result!["code"]))")
            }
        }
    }


}
