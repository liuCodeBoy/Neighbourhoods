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
            if let  is_black = userModel?.is_black{
                if is_black == 1 {
                    self.shieldBtn?.setTitle("已拉黑", for: .normal)
                }else{
                    self.shieldBtn?.setTitle("拉黑", for: .normal)
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
            if   userModel?.is_black == 0 {
                blackType = 1
            }else if userModel?.is_black == 1{
                blackType = 2
            }
        }
    }
    var type : Int?
    var blackType : Int?
    lazy var  rotaionArray = [NborCircleModel]()
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var othersMomentsTableView: UITableView!
    @IBOutlet weak var fcousNumLab: UILabel!
    @IBOutlet weak var fansNum: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var niChen: UILabel!
    private var listView : UIView?
    private var arrow : UIBarButtonItem?
    private var arrowStatus = false
    private var shieldBtn : UIButton?
    var nomission : NoMissionCoverView?
    override func viewDidLoad() {
        super.viewDidLoad()
        othersMomentsTableView.delegate = self
        othersMomentsTableView.dataSource = self
        othersMomentsTableView.showsVerticalScrollIndicator = false
        self.nomission = Bundle.main.loadNibNamed("NoMissionCoverView", owner: self, options: nil)?.first as? NoMissionCoverView
        setNavBarBackBtn()
        setNavBarTitle(title: "他的")
        //设置导航栏下拉控件
        setNavBarArrowBtn()
        //加载刷新控件
        loadRefreshComponet()
        endrefresh()
        loadListView()
    }
    
    func loadListView() {
        let listView = UIView.init(frame: CGRect.init(x: screenWidth - 100, y: 64, width: 100, height: 70))
        listView.backgroundColor = #colorLiteral(red: 0.3764705956, green: 0.7882353067, blue: 0.9725490212, alpha: 1)
        let shieldBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 35))
        shieldBtn.addTarget(self, action: #selector(shieldFriend), for: .touchUpInside)
        shieldBtn.setTitle("拉黑", for: .normal)
        listView.addSubview(shieldBtn)
        self.shieldBtn = shieldBtn
        let chattingBtn = UIButton.init(frame: CGRect.init(x: 0, y: 35, width: 100, height: 35))
        chattingBtn.addTarget(self, action: #selector(chattingAction), for: .touchUpInside)
        chattingBtn.setTitle("私信", for: .normal)
        listView.addSubview(chattingBtn)
        self.view.addSubview(listView)
        self.listView = listView
        self.listView?.alpha = 0
    }
    //屏蔽方法
    @objc func shieldFriend() -> (){
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        guard uid! > 0  else {
            return
        }
        NetWorkTool.shareInstance.blacklist(access_token, uid: uid!, type: blackType!) { [weak self](result, error) in
            if error != nil {
                //print(error as AnyObject)
                return
            }
            var  showText : String?
            switch result!["code"] as! String {
            case "200" :
                if self?.blackType == 1 {
                    showText = "已拉黑"
                    self?.shieldBtn?.setTitle("已拉黑", for: .normal)
                    self?.blackType = 2
                }else{
                    showText = "取消拉黑成功"
                    self?.shieldBtn?.setTitle("拉黑", for: .normal)
                    self?.blackType = 1
                }
            case "400" :
                if self?.blackType == 1 {
                    showText = "拉黑失败"
                    
                }else{
                    showText = "取消拉黑失败"
                }
            case "402" : showText = "请传入type参数"
            default    : break
            }
            self?.presentHintMessage(hintMessgae: showText!, completion: nil)
        }
        
    }
    //聊天方法
    @objc func chattingAction()->(){
        guard let userModel = self.userModel else {
            return
        }
        
        vc.to_uid = userModel.uid as? Int
        vc.isConsultingChat = false
        vc.setNavBarTitle(title: userModel.nickname!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setNavBarArrowBtn() {
        self.arrow = UIBarButtonItem(image: UIImage.init(named: "arrowDown"), style: .done, target: self, action: #selector(showList))
        self.navigationItem.setRightBarButton(arrow, animated: true)
    }
    
    @objc func showList() {
        arrowStatus =  !arrowStatus
        self.arrow?.image = arrowStatus ? UIImage.init(named: "arrowDown") :  UIImage.init(named: "arrowUp")
        if arrowStatus {
            UIView.animate(withDuration: 0.7, animations: {
                self.listView?.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.7, animations: {
                self.listView?.alpha = 0
            })
        }
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
