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
    
}
