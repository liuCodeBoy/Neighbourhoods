//
//  NetWorkTool.swift
//  E
//
//  Created by LiuXinQiang on 17/3/25.
//  Copyright © 2017年 LiuXinQiang. All rights reserved.
//

import AFNetworking
import NoticeBar

extension NetWorkTool {
    //MARK: - 任务列表
    func taskList(sort: String, p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/task/task_list"
        //2.获取请求参数
        let parameters = ["sort" : sort , "p": p] as [String : Any]
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
    
    //MARK: - 任务详情
    func taskDetial(id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/task/task_det"
        //2.获取请求参数
        let parameters = ["id": id] as [String : Any]
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
    
    //MARK: - 社会公益组织列表
    func socialCharityList(p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/task/social_org_list"
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
    
    //MARK: - 社会公益组织详情
    func socialCharityDetial(id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/task/social_org_det"
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
    
    //MARK: - 我发布接受的任务
    func myTask(_ token: String, type: Int, p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/my_task"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["type": type, "p": p] as [String : Any]
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
    
    //MARK: - 任务详情
    func taskDet(_ token: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/task_det"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
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
    
    //MARK: - 社区公告列表
    func announcementList(id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/notice/act_list"
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
    
    //MARK: - 邻里圈发布
//    func nborPublish(content: String, up_cate: Int,  finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
//        //1.获取请求的URLString
//
//        let urlString = "http://106.15.199.8/llb/api/notice/act_list"
//        //2.获取请求参数
////        let parameters = ["id": id]
//        //3.发送请求参数
//        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
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


