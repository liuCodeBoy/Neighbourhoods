//
//  AppDelegate.swift
//  Neighbourhoods
//
//  Created by Weslie on 11/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import AFNetworking
import JMessage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, JPUSHRegisterDelegate {
    
    // MARK:- jmessgae
    let JMAPPKEY = "2e9e03b0d2c6fb033b440bf4"
    
    fileprivate var hostReachability: Reachability!
    
    deinit {
        hostReachability.stopNotifier()
    }
    
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
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        JMessage.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
    
    
    var window: UIWindow?
    
    static let mainVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
    static let InitialLoginVC = UIStoryboard.init(name: "InitialLogin", bundle: Bundle.main).instantiateInitialViewController()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.resetBadge()
        JMessage.resetBadge()
        
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
        entity.types = Int(UInt8(JPAuthorizationOptions.alert.rawValue) | UInt8(JPAuthorizationOptions.sound.rawValue))
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "2e9e03b0d2c6fb033b440bf4", channel: "Test", apsForProduction: false, advertisingIdentifier: advertisingId)
        
        // MARK:- initialize JMessage
        JMessage.setupJMessage(launchOptions, appKey: "2e9e03b0d2c6fb033b440bf4", channel: "Test", apsForProduction: false, category: nil, messageRoaming: false)
        
        JMessage.register(forRemoteNotificationTypes: (UInt(UInt8(UIUserNotificationType.sound.rawValue) | UInt8(UIUserNotificationType.alert.rawValue))), categories: nil)
        
        #if READ_VERSION
            print("-------------READ_VERSION------------")
            print("如果不需要支持已读未读功能")
            print("在 Build Settings 中，找到 Swift Compiler - Custom Flags，并在其中的 Other Swift Flags 删除 -D READ_VERSION")
            print("-------------------------------------")
        #endif
        
        //        DispatchQueue.main.async {
        //            if let window = self.window {
        //                let label = JCFPSLabel(frame: CGRect(x: window.bounds.width - 55 - 8, y: 10, width: 55, height: 20))
        //                label.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        //                window.addSubview(label)
        //                window.backgroundColor = .white
        //            }
        //        }
        if #available(iOS 11.0, *) {
            UITableView.appearance().estimatedRowHeight = 0
            UITableView.appearance().estimatedSectionFooterHeight = 0
            UITableView.appearance().estimatedSectionHeaderHeight = 0
        }
        
        JMessage.setupJMessage(launchOptions, appKey: JMAPPKEY, channel: nil, apsForProduction: true, category: nil, messageRoaming: true)
        _setupJMessage()
                
        hostReachability = Reachability(hostName: "www.apple.com")
        hostReachability.startNotifier()
        
        // MARK:- turn off console log
        JMessage.setLogOFF()
        JPUSHService.setLogOFF()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        JPUSHService.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        JPUSHService.resetBadge()
        JMessage.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        JPUSHService.setBadge(0)
        JPUSHService.resetBadge()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - private func
    private func _setupJMessage() {
        JMessage.add(self, with: nil)
        //        JMessage.setLogOFF()
        JMessage.setDebugMode()
        if #available(iOS 8, *) {
            JMessage.register(
                forRemoteNotificationTypes: UIUserNotificationType.sound.rawValue |  UIUserNotificationType.alert.rawValue,
                categories: nil)
        } else {
            // iOS 8 以前 categories 必须为nil
            JMessage.register(
                forRemoteNotificationTypes:
                    UIRemoteNotificationType.sound.rawValue |
                    UIRemoteNotificationType.alert.rawValue,
                categories: nil)
        }
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

//MARK: - JMessage Delegate
extension AppDelegate: JMessageDelegate {
    func onDBMigrateStart() {
        MBProgressHUD_JChat.showMessage(message: "数据库升级中", toView: nil)
    }
    
    func onDBMigrateFinishedWithError(_ error: Error!) {
        MBProgressHUD_JChat.hide(forView: nil, animated: true)
        MBProgressHUD_JChat.show(text: "数据库升级完成", view: nil)
    }
    
    func onReceive(_ event: JMSGNotificationEvent!) {
        switch event.eventType {
        case .receiveFriendInvitation, .acceptedFriendInvitation, .declinedFriendInvitation:
            cacheInvitation(event: event)
        case .loginKicked, .serverAlterPassword, .userLoginStatusUnexpected:
            _logout()
        case .deletedFriend, .receiveServerFriendUpdate:
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        default:
            break
        }
    }
    
    private func cacheInvitation(event: JMSGNotificationEvent) {
        let friendEvent =  event as! JMSGFriendNotificationEvent
        let user = friendEvent.getFromUser()
        let reason = friendEvent.getReason()
        let info = JCVerificationInfo.create(username: user!.username, nickname: user?.nickname, appkey: user!.appKey!, resaon: reason, state: JCVerificationType.wait.rawValue)
        switch event.eventType {
        case .receiveFriendInvitation:
            info.state = JCVerificationType.receive.rawValue
            JCVerificationInfoDB.shareInstance.insertData(info)
        case .acceptedFriendInvitation:
            info.state = JCVerificationType.accept.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
            NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateFriendList), object: nil)
        case .declinedFriendInvitation:
            info.state = JCVerificationType.reject.rawValue
            JCVerificationInfoDB.shareInstance.updateData(info)
        default:
            break
        }
        if UserDefaults.standard.object(forKey: kUnreadInvitationCount) != nil {
            let count = UserDefaults.standard.object(forKey: kUnreadInvitationCount) as! Int
            UserDefaults.standard.set(count + 1, forKey: kUnreadInvitationCount)
        } else {
            UserDefaults.standard.set(1, forKey: kUnreadInvitationCount)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUpdateVerification), object: nil)
    }
    
    func _logout() {
        JCVerificationInfoDB.shareInstance.queue = nil
        UserDefaults.standard.removeObject(forKey: kCurrentUserName)
        let alertView = UIAlertView(title: "您的账号在其它设备上登录", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "重新登录")
        alertView.show()
    }
}

extension AppDelegate: UIAlertViewDelegate {
    
    private func pushToLoginView() {
        UserDefaults.standard.removeObject(forKey: kCurrentUserPassword)
        if let appDelegate = UIApplication.shared.delegate,
            let window = appDelegate.window {
            window?.rootViewController = JCNavigationController(rootViewController: JCLoginViewController())
        }
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            // remove user defaults
//            let deafult = UserDefaults.standard
//            deafult.removeObject(forKey: "token")
//            deafult.removeObject(forKey: "number")
//            deafult.removeObject(forKey: "pwd")
//            let window = UIApplication.shared.delegate?.window as? UIWindow
//            window?.rootViewController = AppDelegate.InitialLoginVC
            
            guard let username = UserDefaults.standard.object(forKey: "number") as? String  else {
                let window = UIApplication.shared.delegate?.window as? UIWindow
                window?.rootViewController = AppDelegate.InitialLoginVC
                return
            }
            MBProgressHUD_JChat.showMessage(message: "登录中", toView: nil)
            NetWorkTool.shareInstance.UserLogin(UserDefaults.standard.string(forKey: "number")!, password: UserDefaults.standard.string(forKey: "pwd")!, type: "pas", finished: { (userInfo, error) in
                if error == nil {
                    let  userInfoDict = userInfo!
                    let loginStaus =  userInfoDict["code"] as? String
                    if  loginStaus == "200" {
                        
                        let  resultDict = userInfoDict["result"] as? NSDictionary
                        if  let token = resultDict?["token"]{
                            UserDefaults.standard.set(token, forKey: "token")
                        }
                    }
                }
                })
            JMSGUser.login(withUsername: username, password: "llb2580.") { (result, error) in
                MBProgressHUD_JChat.hide(forView: nil, animated: true)
                if error == nil {
                    UserDefaults.standard.set(username, forKey: "number")
                } else {
                    let window = UIApplication.shared.delegate?.window as? UIWindow
                    window?.rootViewController = AppDelegate.InitialLoginVC
                    
                    MBProgressHUD_JChat.show(text: "\(String.errorAlert(error! as NSError))", view: self.window?.rootViewController?.view, 2)
                }
            }
        } else {
            let window = UIApplication.shared.delegate?.window as? UIWindow
            window?.rootViewController = AppDelegate.InitialLoginVC
        }
    }
}


