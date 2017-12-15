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
        let urlString = "http://www.netqlv.com/llb/api/login/login"
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
    func UserRegister( _ account:String, password:String, invite_code: String? , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/login/register"
        //2.获取请求参数
        var parameters = ["account" : account , "password": password]
        if invite_code != nil {
            parameters.updateValue(invite_code!, forKey: "invite_code")
        }
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
    func  nbor_list(_ sort:Nbor_Sort, p: NSInteger ,uid : NSInteger,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
       
        let urlString = "http://www.netqlv.com/llb/api/nbor/nbor_list"
        //2.获取请求参数
        let parameters = ["sort" : sort.rawValue , "p" : p, "uid" :uid ] as [String : Any]
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
    //个人圈动态user/dynamic
    func  dynamic(_ token:String, p: NSInteger ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
          self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/dynamic"
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
    
    //关注动态user/atten_nbor
    func  atten_nbor(_ token:String,uid : NSInteger, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/atten_nbor"
        //2.获取请求参数
        let parameters = ["uid" :uid] as [String : Any]
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
    
    
    
    //user/userInfo 点击头像查看用户详尽信息
    func  user_userInfo(_ token:String, uid : Int, p: NSInteger ,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        let urlString = "http://www.netqlv.com/llb/api/user/userInfo"
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
    
    //
    
    //圈内动态 nbor / nbor_list
    func  nbor_Detail(id : NSInteger, uid : Int,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/nbor_det"
        //2.获取请求参数
        let parameters = ["uid" : uid ,"id" :  id] as [String : Any]
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
    
    //nbor/topic_com
    func  topic_com(id : NSInteger, uid : Int,p : Int,finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/topic_com"
        //2.获取请求参数
        let parameters = ["uid" : uid ,"id" :  id, "p" : p] as [String : Any]
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
        let urlString = "http://www.netqlv.com/llb/api/nbor/nbor_com_det"
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
    
//话题单挑评论详情
    func  topic_com_det(id : NSInteger , p : NSInteger , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/topic_com_det"
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
        let urlString = "http://www.netqlv.com/llb/api/nbor/topic_list"
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
    
    
    func  choice_topic(p : NSInteger , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/choice_topic"
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
    func topic_det(id : NSInteger , p:NSInteger,uid:NSInteger, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/nbor/topic_det"
        //2.获取请求参数
        let parameters = ["id" : id ,"p" : p,"uid":uid] as [String : Any]
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
        let urlString = "http://www.netqlv.com/llb/api/user/postReply"
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
    //user/ topicReply
    func topicReply(token : String, pid :NSNumber,to_uid :NSNumber, uid: NSNumber, post_id : NSNumber,
                   content:String, finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/topicReply"
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
 //topic_post_publish
    func topic_post_publish(_ token: String,
                   topic_id  : NSInteger,
                   image  : [UIImage],
                   content : String,
                   finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/topic_post_publish"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters =  ["content":content,"topic_id":topic_id] as [String : Any]
        var up_cate = 0
        if image.count > 0 {
            up_cate = image.count == 1 ? 1 : 2
            parameters.updateValue(up_cate, forKey: "up_cate")
        }
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //确定选择类型
            if image.count > 0 {
                var  cateName =  ""
                cateName =  image.count > 1 ?  "image[]" :  "image"
                for pic in image {
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
                }
            }
            }, progress: { (Progress) in
        }, success: { (URLSessionDataTask, success) in         //获取字典数据
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    
    
  //点赞接口user/nbor_zan
    func nbor_zan(token : String, nbor_id : NSNumber , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/nbor_zan"
        //2.获取请求参数
        let parameters = ["nbor_id" : nbor_id] as [String : Any]
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
    //topic  moment  click for like topic_zan
        func topic_zan(token : String, nbor_id : NSNumber , finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/topic_zan"
        //2.获取请求参数
        let parameters = ["nbor_id" : nbor_id] as [String : Any]
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
//topic_comtZan
    func topic_comtZan(token : String, nbor_id : NSNumber,id: NSNumber,
                      finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/topic_comtZan"
        //2.获取请求参数
        let parameters = ["nbor_id" : nbor_id ,"id" :id] as [String : Any]
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
    //commment Clik for liked
    func nbor_comtZan(token : String, nbor_id : NSNumber,id: NSNumber,
 finished:@escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/nbor_comtZan"
        //2.获取请求参数
        let parameters = ["nbor_id" : nbor_id ,"id" :id] as [String : Any]
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


//发布功能模块
extension NetWorkTool {
    // MARK:- 论坛发布信息
    func nbor_publish(_ token: String,
                     image  : [UIImage],
                     content : String,
                     finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/nbor_publish"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters =  ["content" : content ] as [String : Any]
        var up_cate = 0
        if image.count > 0 {
         up_cate = image.count == 1 ? 1 : 2
           parameters.updateValue(up_cate, forKey: "up_cate")
        }
        
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //确定选择类型
            if image.count > 0 {
                var  cateName =  ""
                cateName =  image.count > 1 ?  "image[]" :  "image"
                for pic in image {
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
                }
            }
            }, progress: { (Progress) in
        }, success: { (URLSessionDataTask, success) in         //获取字典数据
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
        finished(nil , error)
        }
    }
    func getNowTime() -> (String){
        let date = NSDate.init(timeIntervalSinceNow: 0)
        let a  =  date.timeIntervalSince1970
        let timesString = "\(a).png"
        return  timesString
    }
    
    //话题发布user/ topic_publish
    func topic_publish(_ token: String,
                      image  : [UIImage],
                      name : String,
                      content : String,
                      finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/topic_publish"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters =  ["content" : content , "name" : name] as [String : Any]
        var up_cate = 0
        if image.count > 0 {
            up_cate = 1
            parameters.updateValue(up_cate, forKey: "up_cate")
        }
        
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //确定选择类型
            if image.count > 0 {
                var  cateName =  ""
                cateName =  image.count > 1 ?  "image[]" :  "image"
                for pic in image {
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
                }
            }
            }, progress: { (Progress) in
        }, success: { (URLSessionDataTask, success) in         //获取字典数据
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    //举报 user/ report
    func report(_ token: String,
                       image  : [UIImage],
                       content : String,
                       finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/report"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters =  ["content" : content ] as [String : Any]
        var up_cate = 0
        if image.count > 0 {
            up_cate = image.count == 1 ? 1 : 2
            parameters.updateValue(up_cate, forKey: "up_cate")
        }
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //确定选择类型
            if image.count > 0 {
                var  cateName =  ""
                cateName =  image.count > 1 ?  "image[]" :  "image"
                for pic in image {
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
                }
            }
            }, progress: { (Progress) in
        }, success: { (URLSessionDataTask, success) in         //获取字典数据
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    //发布任务
    //user/ task_publish
    func task_publish(_ token: String,
                       title  : String,
                       content : String,
                       integral : Int,
                       finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/task_publish"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["title":title,"integral" : integral, "content" : content ] as [String : Any]
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


//发布摇号列表功能模块 notice/lottery_list
extension NetWorkTool {
    func lottery_list(finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/notice/lottery_list"
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters:nil ) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
 //身份认证 user/lottery_judeg
    func lottery_judeg(_ token: String,
                      id : Int,
                      finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/lottery_judeg"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["id":id] as [String : Any]
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
    //摇号详情
    func lottery_det(id : Int, uid : Int,
                     finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/notice/lottery_det"
        //2.获取请求参数
        let parameters =  ["id":id , "uid" : uid] as [String : Any]
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
    
    // 加入协商群聊（user/join_group_chat
    func join_group_chat(token : String, gid : Int,
                     finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/join_group_chat"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["gid" : gid] as [String : Any]
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
    
    //摇号报名
    func userVote(token: String, id : Int,
                  finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/lottery_apply"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["id":id] as [String : Any]
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
    //投票 user/ play_lottery
    func play_lottery(_ token: String,
                       id : Int,
                       finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/play_lottery"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["id":id] as [String : Any]
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
    
    //notice/ act_list
    func act_list(p : Int,
                      finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/notice/act_list"
        //2.获取请求参数
        let parameters =  ["p":p] as [String : Any]
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
    //活动投票详情（notice/act_det）
    func act_det(id : Int,
                  finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/notice/act_det"
        //2.获取请求参数
        let parameters =  ["id":id] as [String : Any]
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
    //user/ option_list
    func option_list(_ token: String,
                      p  : Int,
                      status : Int,
                      cate : Int,
                      id : Int,
                      finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/option_list"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["p":p, "status": status, "cate" : cate ,"id":id] as [String : Any]
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
    //user/ join_vote 参与投票
    func join_vote(_ token: String,
                     name  : String,
                     image  : [UIImage],
                     id : Int,
                     finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/join_vote"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters =  ["name":name,"id":id] as [String : Any]
        if image.count > 0 {
            let up_cate = 1
            parameters.updateValue(up_cate, forKey: "up_cate")
        }
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //确定选择类型
            if image.count > 0 {
                var  cateName =  ""
                cateName =  image.count > 1 ?  "image[]" :  "image"
                for pic in image {
                    if let imageData = UIImageJPEGRepresentation(pic, 0.5){
                        let imageName =  self?.getNowTime()
                        formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                    }
                }
            }
            }, progress: { (Progress) in
        }, success: { (URLSessionDataTask, success) in         //获取字典数据
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    //user/ vote 投票
    func vote(_ token: String,
                   vote_id  : Int,
                   option_id : Int,
                   finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/vote"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["vote_id":vote_id, "option_id": option_id] as [String : Any]
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
  //user/ people_det 查看选项详情
    func people_det(_ token: String,
              id  : Int,
              finished: @escaping (_ result: [String: AnyObject]?, _ error: Error?) -> ()) {
        //1.获取请求的URLString
        let urlString = "http://www.netqlv.com/llb/api/user/people_det"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters =  ["id" : id] as [String : Any]
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
    
    
    
    //MARK: - 社区公告列表
    func announcementNotice_list(p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://www.netqlv.com/llb/api/notice/notice_list"
        //2.获取请求参数
        let parameters = ["p": p]
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
    
    //notice/notice_det
    func announcementNotice_det(id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://www.netqlv.com/llb/api/notice/notice_det"
        //2.获取请求参数
        let parameters = ["id": id]
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




