//
//  OthersMomentsViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage
class OthersMomentsViewController: UIViewController {
    
    private var tokenStr = UserDefaults.standard.string(forKey: "token")
    
    var uid   : Int?
    var page  = 1
    var pages : Int?
    
    lazy var vc = UIStoryboard.init(name: "QuickViewMessgaes", bundle: nil).instantiateViewController(withIdentifier: "ChattingVC") as! ChattingViewController
    
    @IBOutlet weak var focusBtn: UIButton!
    
    var userModel : UserModel? {
        didSet{
            if let  avatarStr = userModel?.head_pic {
                self.avatarImageView.sd_setImage(with: URL.init(string: avatarStr), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if  let name = userModel?.nickname{
              self.niChen.text = name
            }
            if let address = userModel?.address{
                self.addressBtn.setTitle(address, for: .normal)
            }
            let  sex = userModel?.sex?.intValue
            if sex == 1 || sex == 2 {
                self.sexImageView.image =   sex == 1 ? UIImage.init(named: "male") : UIImage.init(named: "female")
            }else{
            }
            if let focusNum = userModel?.atten {
                self.fcousNumLab.text = "\(focusNum)"
            }
            if let fansNum = userModel?.fans{
                self.fansNum.text = "\(fansNum)"
            }
            if let  is_atten = userModel?.is_atten{
                if is_atten == 1 {
                    self.focusBtn.setTitle("已关注", for: .normal)
                }else{
                    self.focusBtn.setTitle(" +关注 ", for: .normal)
                }
            }
            guard userModel?.is_atten != nil else {
                return
            }
            if   userModel?.is_atten == 0 {
                type = 1
            }else if userModel?.is_atten == 1{
                type = 2
            }
            
            
            
        }
    }
    var type : Int?
    lazy var  rotaionArray = [NborCircleModel]()
    @IBOutlet weak var othersMomentsTableView: UITableView!
    @IBOutlet weak var fcousNumLab: UILabel!
    @IBOutlet weak var fansNum: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var niChen: UILabel!
    var nomission : NoMissionCoverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        othersMomentsTableView.delegate = self
        othersMomentsTableView.dataSource = self
        othersMomentsTableView.showsVerticalScrollIndicator = false
        self.nomission = Bundle.main.loadNibNamed("NoMissionCoverView", owner: self, options: nil)?.first as? NoMissionCoverView
        setNavBarBackBtn()
        setNavBarTitle(title: "他的")
        //加载刷新控件
        loadRefreshComponet()
        endrefresh()
        
        
    }
 
    @IBAction func addFocus(_ sender: Any) {
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        guard uid! > 0  else {
            return
        }
    
        
        NetWorkTool.shareInstance.changeFollowStatus(access_token, uid: uid!, type: type!) { [weak self](result, error) in
            if error != nil {
                //print(error as AnyObject)
                return
            }
            var  showText : String?
            switch result!["code"] as! String {
            case "200" :
                if self?.type == 1 {
                    showText = "关注成功"
                    self?.focusBtn.setTitle("已关注", for: .normal)
                    self?.type = 2
                }else{
                    showText = "取消关注成功"
                    self?.focusBtn.setTitle(" +关注 ", for: .normal)
                    self?.type = 1
                }
            case "400" :
                if self?.type == 1 {
                    showText = "关注失败"
             
                }else{
                    showText = "取消关注失败"
                }
            case "402" : showText = "请传入type参数"
            default    : break
            }
            self?.presentHintMessage(hintMessgae: showText!, completion: nil)
        }
    }
    
    @IBAction func sendMsgClicked(_ sender: UIButton) {
        
        guard let userModel = self.userModel else {
            return
        }
        
        vc.to_uid = userModel.uid as? Int
        vc.isConsultingChat = false
        vc.setNavBarTitle(title: userModel.nickname!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func loadRefreshComponet() -> () {
        //上拉刷新
        othersMomentsTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(endrefresh))
        //自动根据有无数据来显示和隐藏
        othersMomentsTableView.mj_footer.isAutomaticallyHidden = true
    }
    @objc func  endrefresh() -> (){
        if uid != nil {
            lastedRequest(p: page, token: tokenStr!, uid: uid!)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.nomission?.removeFromSuperview()
    }
//    user_userInfo
    //MARK: - 最新发布网络请求
    private func  lastedRequest(p : Int ,token : String ,uid :Int) -> () {
            NetWorkTool.shareInstance.user_userInfo(token, uid :uid , p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                let userInfo    = info!["result"]!
                self?.userModel = UserModel.mj_object(withKeyValues: userInfo)
                if let pages  = info!["result"]!["pages"]
                {
                    guard  pages != nil else{
                        self?.nomission?.frame = CGRect(x: 0, y: 0, width: (self?.othersMomentsTableView.bounds.width)!, height: (self?.othersMomentsTableView.bounds.height)!)
                        self?.nomission?.showLab.text = "该用户未发表动态"
                        self?.othersMomentsTableView.addSubview((self?.nomission)!)
                        self?.othersMomentsTableView.isScrollEnabled = false
                        return
                    }
                    self?.nomission?.removeFromSuperview()
                    self?.pages = (pages as! Int)
                }
               
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                let result   = info!["result"]!["nbor_list"] as! [NSDictionary]
                for i in 0..<result.count
                {
                    let  circleInfo  =  result[i]
                    if  let rotationModel = NborCircleModel.mj_object(withKeyValues: circleInfo)
                    {
                        self?.rotaionArray.append(rotationModel)
                    }
                }
                self?.othersMomentsTableView.reloadData()
                if self?.page == self?.pages {
                    self?.othersMomentsTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }else{
                //服务器
                self?.othersMomentsTableView.mj_footer.endRefreshing()
            }
        }
    }
}

extension OthersMomentsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rotaionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let  cell = tableView.dequeueReusableCell(withIdentifier: "OthersMomentsCell") as! OthersMomentsTableViewCell
        guard rotaionArray.count > 0  else {
            return cell
        }
        let  model = rotaionArray[indexPath.row]
        cell.momentsCellModel = model
        cell.pushImageClouse = {(imageArr, index) in
            let desVC = UIStoryboard(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "ImageShowVCID") as!  ImageShowVC
            desVC.index  = index
            desVC.imageArr = imageArr
            self.present(desVC, animated: true, completion: nil)
        }
        //跳出评论
        cell.showCommentClouse = {(pid ,to_uid ,uid,post_id,indexRow) in
            let commentVc = UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "WriteCommentIdent") as? WriteCommentViewController
            commentVc?.pid = 0
            commentVc?.row = indexRow
            commentVc?.to_uid  = model.uid
            commentVc?.uid     = model.uid
            commentVc?.post_id = model.id
            self.navigationController?.pushViewController(commentVc!, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let   momentsCommentDetialVC =  UIStoryboard.init(name: "Circle", bundle: nil).instantiateViewController(withIdentifier: "MomentsCommentDetialViewController") as! MomentsCommentDetialViewController
        let modelArr =  self.rotaionArray
        guard modelArr.count > 0 else {
            return
        }
        let  model =  modelArr[indexPath.row]
        momentsCommentDetialVC.id = model.id
        self.navigationController?.pushViewController(momentsCommentDetialVC, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FollowersSegue" {
            let dest = segue.destination as! MyFollowersViewController
            dest.uid = userModel?.uid
        } else if segue.identifier == "FollowingsSegue" {
            let dest = segue.destination as! MyFollowingsViewController
            dest.uid = userModel?.uid
        }
    }
}
