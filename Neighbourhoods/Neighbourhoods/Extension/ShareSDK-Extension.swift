//
//  ShareSDK-Extension.swift
//  Ant
//
//  Created by Weslie on 2017/8/15.
//  Copyright © 2017年 Weslie. All rights reserved.
//

import Foundation

extension ShareSDK {
    
    class func share(platform: SSDKPlatformType, parameters: NSMutableDictionary) {
        ShareSDK.share(platform, parameters: parameters) { (state: SSDKResponseState, userData: [AnyHashable : Any]?, entity: SSDKContentEntity?, error: Error?) in
            switch state {
            case .success: print("分享成功")
            case .fail: print("分享失败,错误描述:\(String(describing: error))")
            case .cancel: print("分享取消")
            default:
                break
            }
            
        }
    }
    
    class func showShareActionSheet(view: UIView!, shareParams: NSMutableDictionary) {
        ShareSDK.showShareActionSheet(view, items: nil, shareParams: shareParams) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [AnyHashable : Any]?, contentEnity : SSDKContentEntity?, error : Error?, end) in
            
            switch state{
                
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("分享失败,错误描述:\(String(describing: error))")
            case SSDKResponseState.cancel:  print("分享取消")
                
            default:
                break
            }
        }
        
    }
}
