//
//  Share.swift
//  Neighbourhoods
//
//  Created by Weslie on 25/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

//let closeShareNotification = "com.Neighbourhood.share.close"

class Share: UIView {

    var shareURL = URL(string: "https://github.com/iWeslie")
    
    var shareText: String = "分享的内容"
    var shareTitle: String = "分享的标题"
    var thumbImage: UIImage = #imageLiteral(resourceName: "share_smalll")
    
    @IBAction func closeBtnClicked(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name.init(closeSpringViewNotification), object: nil)
    }
    @IBAction func qq(_ sender: UIButton) {
        let shareParams = NSMutableDictionary()

        shareParams.ssdkSetupQQParams(byText: shareText, title: shareTitle, url: shareURL, thumbImage: thumbImage, image: nil, type: .auto, forPlatformSubType: .subTypeQQFriend)
        
        ShareSDK.share(platform: .subTypeQQFriend, parameters: shareParams)
    }
    
    @IBAction func moments(_ sender: UIButton) {
        let shareParams = NSMutableDictionary()
        
        shareParams.ssdkSetupWeChatParams(byText: shareText, title: shareTitle, url: shareURL, thumbImage: thumbImage, image: nil, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: .auto, forPlatformSubType: .subTypeWechatTimeline)
        
        ShareSDK.share(platform: .subTypeWechatTimeline, parameters: shareParams)
    }
    
    @IBAction func friends(_ sender: UIButton) {
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupWeChatParams(byText: shareTitle, title: shareTitle, url: shareURL, thumbImage: thumbImage, image: nil, musicFileURL: nil, extInfo: nil, fileData: nil, emoticonData: nil, type: .webPage, forPlatformSubType: .subTypeWechatSession)
        ShareSDK.share(platform: .subTypeWechatSession, parameters: shareParams)
    }
    
    @IBAction func qzone(_ sender: UIButton) {
        let shareParams = NSMutableDictionary()
        
        shareParams.ssdkSetupQQParams(byText: shareText, title: shareTitle, url: shareURL, thumbImage: thumbImage, image: nil, type: .auto, forPlatformSubType: .subTypeQZone)
        
        ShareSDK.share(platform: .subTypeQZone, parameters: shareParams)
    }
    
    
}
