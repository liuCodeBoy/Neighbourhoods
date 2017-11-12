//
//  AppDelegate.swift
//  Neighbourhoods
//
//  Created by Weslie on 11/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import AFNetworking
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let mainVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
    static let InitialLoginVC = UIStoryboard.init(name: "InitialLogin", bundle: Bundle.main).instantiateInitialViewController()!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = navAndTabBarTintColor
        UINavigationBar.appearance().tintColor = navAndTabBarTintColor
        //读取偏好设置数据
        let deafult = UserDefaults.standard
        if deafult.string(forKey: "token") != nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.backgroundColor = UIColor.white
            window?.rootViewController = AppDelegate.mainVC
            window?.makeKeyAndVisible()
        }else{
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.backgroundColor = UIColor.white
            window?.rootViewController = AppDelegate.InitialLoginVC
            window?.makeKeyAndVisible()
        }
        
        //MARK: - initialize the mob
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue
            ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.typeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform
                {
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
                                                appSecret: "38a4f8204cc784f81f9f0daaf31e02e3",
                                                redirectUri: "http://www.sharesdk.cn",
                                                authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: "wx4868b35061f87885",
                                             appSecret: "64020361b8ec4c99936c0e3999a9f249")
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "100371282",
                                         appKey: "aed9b0303e3ed1e27bae87c33761161d",
                                         authType: SSDKAuthTypeWeb)
                default:
                    break
                }
        })
        
        return true
    }

   
    
 
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        let mgr = AFNetworkReachabilityManager.shared()
        mgr.stopMonitoring()
//        //偏好设置
//        let userDefault =  UserDefaults.standard
//        //存储数据
//        userDefault.set(appdelgate?.fontSize, forKey: "font")
//        //同步数据
//        userDefault.synchronize()
        
    }
    
}

