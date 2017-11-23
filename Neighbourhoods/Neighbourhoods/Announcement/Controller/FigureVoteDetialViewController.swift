//
//  FigureVoteDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import SDWebImage
import NoticeBar
class FigureVoteDetialViewController: UIViewController {
    var  id   : NSNumber?
    var index : Int?
    var model : User_detModel?
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var rankLbl: UILabel!
    @IBOutlet weak var detialTextView: UITextView!
    @IBOutlet weak var detialImage: UIImageView!
    @IBOutlet weak var votedCountLbl: UILabel!
    @IBOutlet weak var voteForHimHer: UIButton!
    @IBAction func voteForHimHerClicked(_ sender: UIButton) {
        guard  model != nil else {
            return
        }
        voteRequest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        self.rankLbl.text = "NO.\(String(describing: index!))"
        setNavBarTitle(title: "某某人")
        lastedRequest(id: id as! Int)
    }

  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let desVC =  segue.destination as! FigureVoteJoinViewController
    }
    
    
    
    
    func voteRequest() -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.vote(token, vote_id: model?.vote_id as! Int, option_id: model?.uid as! Int) { (info, error) in
            if info?["code"] as? String == "200"{
                let result = info?["result"]
                let config = NoticeBarConfig(title:result as? String, image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: {
                    (finished) in
                    if finished {
                    }
                })
            }else{
                //服务器
                let result = info?["result"]
                let config = NoticeBarConfig(title:result as? String, image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: {
                    (finished) in
                    if finished {
                    }
                })
            }
        }
    }

    
    func lastedRequest(id: Int) -> () {
        var token = ""
        guard (UserDefaults.standard.string(forKey: "token") != nil) else {
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        token = UserDefaults.standard.string(forKey: "token")!
        NetWorkTool.shareInstance.people_det( token ,id : id) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let result  = info!["result"] as! NSDictionary
                    if  let model = User_detModel.mj_object(withKeyValues:result)
                    {    self?.model = model
                        if let avatarString  =  model.user?.head_pic {
                            self?.avatar.sd_setImage(with: URL.init(string: avatarString), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                        }
                        if  let nickName = model.user?.nickname{
                            self?.nickName.text = nickName
                        }
                        if let  sex = model.user?.sex?.intValue {
                            if sex == 1 || sex == 2 {
                                self?.gender.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
                            }
                        }
                        if let title = model.name{
                            self?.detialTextView.text = title
                        }
                        if let picture = model.picture{
                            self?.detialImage.sd_setImage(with: URL.init(string: picture), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: SDWebImageOptions.continueInBackground, progress: nil, completed: nil)
                        }
                        if let rank = self?.index{
                        self?.rankLbl.text = "NO.\(String(describing: rank))"
                        }
                        if let number = model.number{
                            if number == 0{
                            self?.votedCountLbl.text = "快为他投上一票"
                                return
                            }
                            self?.votedCountLbl.text = "已有\(number)人为他投票"
                        }
                    }
                
            }else{
                //服务器
            }
        }
        
    }

}
