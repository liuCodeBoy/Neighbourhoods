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
    @IBOutlet weak var detialTextView: UITextView!
    @IBOutlet weak var image: UIImageView!
    
    var socialCharityDetial = SocialOrgDetModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavBarTitle(title: "社区公益组织")
        setNavBarBackBtn()
        
        //MARK: - load data
        NetWorkTool.shareInstance.socialCharityDetial(id: 1) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else {
                guard let resultDict = result else {
                    return
                }
                if let detialDict = resultDict["result"] {
                    let viewModel = SocialOrgDetModel.mj_object(withKeyValues: detialDict)
                    
                    self.charityAvatar.sd_setImage(with: URL.init(string: (viewModel?.head_pic!)!), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
                    self.charityName.text = viewModel?.name
                    self.location.text = viewModel?.address
                    self.phoneNumber.text = viewModel?.phone
                    self.emailAddress.text = viewModel?.email
                    self.detialTextView.text = viewModel?.content
                    self.image.sd_setImage(with: URL.init(string: "\(viewModel?.picture?.first)"), placeholderImage: #imageLiteral(resourceName: "id_card_authentication_succeeded"), options: .continueInBackground, completed: nil)
                }
                
            }
        }

    }


}
