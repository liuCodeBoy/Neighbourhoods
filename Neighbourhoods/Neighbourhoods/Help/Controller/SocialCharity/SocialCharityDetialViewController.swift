//
//  SocialCharityDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 28/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh

class SocialCharityDetialViewController: UIViewController {
    
    @IBOutlet weak var charityAvatar: UIImageView!
    @IBOutlet weak var charityName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var emailAddress: UILabel!
    @IBOutlet weak var detialWeb: UIWebView!
    
    lazy var vc = UIStoryboard.init(name: "QuickViewMessgaes", bundle: nil).instantiateViewController(withIdentifier: "ChattingVC") as! ChattingViewController
    
    var progressView: UIView?

    var rootVC: UIViewController?
    
    var socialCharityDetial = SocialOrgDetModel()
    
    var to_uid: Int?
    
    var urlString: String?
    
    var id : NSNumber?
    @IBAction func consultBtnClicked(_ sender: UIButton) {
        
        if UserDefaults.standard.string(forKey: "token") == nil {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        vc.to_uid = self.to_uid
        vc.isConsultingChat = false
        vc.setNavBarTitle(title: "咨询")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func dismissRootVC() {
        rootVC?.dismiss(animated: true, completion: nil)  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "社会服务机构、组织")
        setNavBarBackBtn()
        
        //MARK: - load data
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "加载中"
        self.progressView = progress
        self.view.addSubview(progress)
        loadWebView(id: id)

    }
    
    func loadWebView(id : NSNumber?) {
        
        guard let urlString = urlString else {
            return
        }
        let urlRequest = URLRequest(url: URL.init(string: urlString)!)
        detialWeb.loadRequest(urlRequest)
        
        NetWorkTool.shareInstance.socialCharityDetial(id: id as! Int) { [weak self](result, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if error != nil {
                //print(error as AnyObject)
            } else {
                guard let resultDict = result else {
                    return
                }
                if let detialDict = resultDict["result"] {
                    let viewModel = SocialOrgDetModel.mj_object(withKeyValues: detialDict)
                    
                    self?.charityAvatar.sd_setImage(with: URL.init(string: (viewModel?.head_pic!)!), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
                    self?.charityName.text = viewModel?.name
                    self?.location.text = viewModel?.address
                    self?.phoneNumber.text = viewModel?.phone
                    self?.emailAddress.text = viewModel?.email
                    self?.to_uid = viewModel?.uid as? Int
                }
                
            }
        }
        
        
    }

}
