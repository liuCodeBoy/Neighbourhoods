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
    var userModel : UserModel? {
        didSet{
            if let  avatarStr = userModel?.head_pic {
            self.avatarImageView.sd_setImage(with: URL.init(string: avatarStr), completed: nil)
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
            
            
        }
    }
    lazy var  rotaionArray = [NborCircleModel]()
    @IBOutlet weak var othersMomentsTableView: UITableView!
    @IBOutlet weak var fcousNumLab: UILabel!
    @IBOutlet weak var fansNum: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var addressBtn: UIButton!
    @IBOutlet weak var niChen: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        othersMomentsTableView.delegate = self
        othersMomentsTableView.dataSource = self
        setNavBarBackBtn()
        setNavBarTitle(title: "他的")
        //加载刷新控件
        loadRefreshComponet()
        //
        endrefresh()
    }
 
    @IBAction func addFocus(_ sender: Any) {
        
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
//    user_userInfo
    //MARK: - 最新发布网络请求
    private func  lastedRequest(p : Int ,token : String ,uid :Int) -> () {
            NetWorkTool.shareInstance.user_userInfo(token, uid :uid , p: p) {[weak self](info, error) in
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"]
                {
                    self?.pages = (pages as! Int)
                }
                if  CGFloat((self?.page)!) <  CGFloat((self?.pages)!){
                    self?.page += 1
                }
                let userInfo    = info!["result"]!
                self?.userModel = UserModel.mj_object(withKeyValues: userInfo)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "OthersMomentsCell")!
    }
}
