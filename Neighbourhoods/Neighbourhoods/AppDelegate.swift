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
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    
    // MARK:- iOS 10.0 support
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.sound.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self) == true {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    // MARK:- iOS 9.0 support
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    

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
        
        // MARK:- initialize JPush
        let entity = JPUSHRegisterEntity()
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue) | UInt8(JPAuthorizationOptions.badge.rawValue) | UInt8(JPAuthorizationOptions.sound.rawValue))
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "5a271528ff179474042f1215", channel: "Test", apsForProduction: false, advertisingIdentifier: advertisingId)
        
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

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
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

