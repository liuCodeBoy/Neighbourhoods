//
//  CircleMomentsTableViewCell.swift
//  Neighbourhoods
//
//  Created by Weslie on 02/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar

class CircleMomentsTableViewCell: UITableViewCell {
    
    // MARK:- click the image to call the clasure
    var pushImageClouse : MonentImageType?
    
    var deleteClosure: (() -> ())?
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else { return  }
        
        NetWorkTool.shareInstance.deleteMyMoments(access_token, id: viewModel?.id as! Int) { (result, error) in
            if error != nil {
                print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                
                // MARK:- delete successful
                let config = NoticeBarConfig(title:"删除成功", image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.5, completed: nil)
            } else {
                print("post request failed with exit code \(result!["code"] as! String)")
            }
        }
    }
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var certifyLbl: UILabel!
    @IBOutlet weak var gender: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var textLbl: UILabel!

    @IBOutlet weak var imageLeft: UIImageView!
    @IBOutlet weak var imageRight: UIImageView!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var viewModel: MyCircleMomentsModel? {
        didSet {
            if let avatar = viewModel?.user?.head_pic {
                self.avatar.sd_setImage(with: URL.init(string: avatar), placeholderImage: #imageLiteral(resourceName: "profile_avatar_placeholder"), options: .continueInBackground, completed: nil)
            }
            if let nickname = viewModel?.user?.nickname {
                self.nickName.text = nickname
            }
            if let verify = viewModel?.user?.type {
                self.certifyLbl.text = verify
            }
            if let gender = viewModel?.user?.sex {
                if gender == 1 {
                    self.gender.image = #imageLiteral(resourceName: "male")
                } else if gender == 2 {
                    self.gender.image = #imageLiteral(resourceName: "female")
                }
            }
            if let location = viewModel?.user?.address {
                self.location.text = location
            } else {
                self.locationImg.isHidden = true
                self.location.isHidden = true
            }
            if let time = viewModel?.time {
                self.createTime.text = NSDate.createDateString(createAtStr: "\(time)")
            }
            if let content = viewModel?.content {
                self.textLbl.text = content
            }
            
            // MARK:- set image
            if let pictureStringArr = viewModel?.picture{
                imageHeightConstraint.constant = 90
                let leftImage = pictureStringArr[0]
                self.imageLeft.sd_setImage(with: URL.init(string: leftImage), placeholderImage: UIImage(), options: .continueInBackground, progress: nil, completed: nil)
                let  tap = UITapGestureRecognizer.init(target: self, action:#selector(showImageVC))
                imageLeft.addGestureRecognizer(tap)
                self.imageRight.isUserInteractionEnabled = false
                self.imageRight.image = nil
                if  pictureStringArr.count >= 2 {
                    let rightImage = pictureStringArr[1]
                    self.imageRight.isUserInteractionEnabled = true
                    let  tapSecond = UITapGestureRecognizer.init(target: self, action:#selector(showSecondVC))
                    imageRight.addGestureRecognizer(tapSecond)
                    self.imageRight.sd_setImage(with: URL.init(string: rightImage), completed: nil)
                }
                
            }else{
                imageHeightConstraint.constant = 0
            }
            
        }
    }
    
    @objc private func showImageVC(){
        if let pictureStringArr = viewModel?.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr as NSArray ,0)
            }
        }
    }
    @objc private func showSecondVC(){
        if let pictureStringArr = viewModel?.picture{
            if self.pushImageClouse != nil{
                self.pushImageClouse!(pictureStringArr as NSArray ,1)
            }
        }
    }


}
