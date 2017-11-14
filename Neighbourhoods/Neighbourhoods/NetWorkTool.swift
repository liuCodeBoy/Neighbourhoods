//
//  NetWorkTool.swift
//  E
//
//  Created by LiuXinQiang on 17/3/25.
//  Copyright © 2017年 LiuXinQiang. All rights reserved.
//

import AFNetworking
import NoticeBar



// MARK:- 定义枚举类型
enum RequestType : String {
      case GET = "GET"
      case POST = "POST"
}
enum Nbor_Sort : String {
    case  time  =  "time"
    case  love  =  "love"
}

enum LunTanType : String {
    case house = "house"
    case job = "job"
    case car = "car"
    case secondHand = "market"
    case cityWide = "friends"
}

class NetWorkTool: AFHTTPSessionManager {
    
    static   var   canConnect : Bool = true
    
    //let 是线程安全的,创建单例
    static let shareInstance : NetWorkTool = {
        let  tools = NetWorkTool()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
       return tools
    }()
    
    }


// MARK:-  封装请求方法
extension NetWorkTool {
    func startMonitoringNetwork() -> () {
        let mgr = AFNetworkReachabilityManager.shared()
        mgr.setReachabilityStatusChange { (Status) -> Void in
            switch(Status){
            case AFNetworkReachabilityStatus.notReachable:
                let config = NoticeBarConfig(title: "网络错误，请稍后再试", image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 2.0, completed: {
                    (finished) in
                    if finished {
                    }
                })
                NetWorkTool.canConnect = false
                break
            case AFNetworkReachabilityStatus.reachableViaWiFi:
                NetWorkTool.canConnect = true
                break
            case AFNetworkReachabilityStatus.reachableViaWWAN:
                NetWorkTool.canConnect = true
                break
            default:
                NetWorkTool.canConnect = true
                break
            }
        }
        
        mgr.startMonitoring()
    }
    
    func request(_ method: RequestType, urlString : String, parameters:[String :AnyObject]?, finished:@escaping (_ result : AnyObject?, _ error : Error?)->()){
        //网路监控
        startMonitoringNetwork()
        if(NetWorkTool.canConnect == true){
            //定义成功的回调闭包
            let successCallBack = {  (task: URLSessionDataTask?, result: Any?) -> Void in
                finished(result  as AnyObject, nil )
            }
            //定义失败的回调闭包
            let failureCallBack = { (task: URLSessionDataTask?, error: Error?) -> Void in
                finished(nil, error )
            }
            //发送网络请求
            if method == RequestType.GET {
                self.get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            } else {
                self.post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            }
        } else {
        }
    }
 }

// MARK:- 用户登录请求
extension NetWorkTool {
    //用户登录
    func UserLogin( _ account:String, password:String , type : String , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
      //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/login/login"
      //2.获取请求参数
        let parameters = ["account" : account , "password": password , "type" : type]
      //3.发送请求参数
       request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
        //获取字典数据
        guard let resultDict = result as? [String : AnyObject] else {
            finished(nil, error)
            return
         }
        //将数组数据回调给外界控制器
        finished(resultDict, error)
        }
    }
    //用户注册
    func UserRegister( _ account:String, password:String , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/login/register"
        //2.获取请求参数
        let parameters = ["account" : account , "password": password]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
}

  //MARK: - 邻里圈
extension NetWorkTool {
    //圈内动态 nbor / nbor_list
    func  nbor_list(_ sort:Nbor_Sort, p: NSInteger ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
       
        let urlString = "http://106.15.199.8/llb/api/nbor/nbor_list"
        //2.获取请求参数
        let parameters = ["sort" : sort.rawValue , "p" : p] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    //user/userInfo 点击头像查看用户详尽信息
    func  user_userInfo(_ token:String, uid : Int, p: NSInteger ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        let urlString = "http://106.15.199.8/llb/api/user/userInfo"
        //2.获取请求参数
        let parameters = ["uid" : uid , "p" : p] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //圈内动态 nbor / nbor_list
    func  nbor_Detail(id : NSInteger ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/nbor/nbor_det"
        //2.获取请求参数
        let parameters = ["id" :  id] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
//邻里圈单条详情
    func  nbor_com_det(id : NSInteger , p : NSInteger , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/nbor/nbor_com_det"
        //2.获取请求参数
        let parameters = ["id" :  id , "p" : p] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
 //nbor/topic_list
    func  topic_list(p : NSInteger , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/nbor/topic_list"
        //2.获取请求参数
        let parameters = ["p" : p] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
 //nbor/topic_det
    func topic_det(id : NSInteger , p:NSInteger, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/nbor/topic_det"
        //2.获取请求参数
        let parameters = ["id" : id ,"p" : p] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
}
extension NetWorkTool{
//    user/ postReply 评论接口
    func postReply(token : String, pid :NSNumber,to_uid :NSNumber, uid: NSNumber, post_id : NSNumber,
                   content:String, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://106.15.199.8/llb/api/user/postReply"
        //2.获取请求参数
        let parameters = ["pid" : pid,"to_uid" : to_uid,"uid" : uid,"post_id" : post_id, "content" : content] as [String : Any]
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
  //点赞接口user/nbor_zan
   
//    func nbor_zan(token : String, nbor_id : NSNumber , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
//        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
//        //1.获取请求的URLString
//        let urlString = "http://106.15.199.8/llb/api/user/postReply"
//        //2.获取请求参数
//        let parameters = ["pid" : pid,"to_uid" : to_uid,"uid" : uid,"post_id" : post_id, "content" : content] as [String : Any]
//        //3.发送请求参数
//        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject] ) { (result, error) -> () in
//            //获取字典数据
//            guard let resultDict = result as? [String : AnyObject] else {
//                finished(nil, error)
//                return
//            }
//            //将数组数据回调给外界控制器
//            finished(resultDict, error)
//        }
//    }
    
    
}


