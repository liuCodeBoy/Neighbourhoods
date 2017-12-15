//
//  Share.swift
//  DetialsOfAntDemo
//
//  Created by Weslie on 2017/7/17.
//  Copyright © 2017年 Weslie. All rights reserved.
//

import UIKit

class Share: UIView {
    
    var shareURL = URL(string: "https://github.com/iWeslie")
    
    var shareText: String = "分享的内容"
    var shareTitle: String = "分享的标题"
    var thumbImage: UIImage = #imageLiteral(resourceName: "img_loading_placeholder")
    

    
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
    
    @IBAction func sinaweibo(_ sender: UIButton) {
        let shareParams = NSMutableDictionary()
        shareParams.ssdkSetupShareParams(byText: shareText, images : nil, url : shareURL, title : shareTitle, type : SSDKContentType.auto)
        ShareSDK.share(platform: .typeSinaWeibo, parameters: shareParams)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        // Initialization code
    }

}
