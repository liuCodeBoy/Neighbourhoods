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
    func taskDetial(_ token: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/task_det"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
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
    
    //MARK: - 领取任务
    func receiveTask(_ token: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/task_rec"
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
    
    //MARK: - 取消任务
    func cancelTask(_ token: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/task_cancel"
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
    
    //MARK: - 任务操作
    func operateTask(_ token: String, id: Int, type: MissionOperation, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/task_operate"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["id": id, "type": type.rawValue + 1] as [String : Any]
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
    
    //MARK: - 查看用户信息
    func userInfo(_ token: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/userInfo"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //MARK: - 关注列表
    func userAttention(_ token: String, uid: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/attention"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.发送请求参数
        let parameters = ["uid": uid] as [String : AnyObject]
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }

    //MARK: - 粉丝列表
    func userFans(_ token: String, uid: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/fans_list"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.发送请求参数
        let parameters = ["uid": uid] as [String : AnyObject]
        
        request(.POST, urlString: urlString, parameters: parameters) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //MARK: - 关注或取消关注
    func changeFollowStatus(_ token: String, uid: Int, type: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/cancel_atten"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["uid": uid, "type": type] as [String : Any]
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

    //MARK: - 我的积分
    func myScore(_ token: String, p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/my_integral"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["p": p] as [String : Any]
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
    
    //MARK: - 我的圈动态
    func myCircleMoments(_ token: String, p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/dynamic"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["p": p] as [String : Any]
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
    
    //MARK: - 删除动态
    func deleteMyMoments(_ token: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/del_nbor"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
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
    
    
    //MARK: - 选择小区
    func selectDistrict(_ token: String, level: Int, pid: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/select_district"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["level": level, "pid": pid] as [String : Any]
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
    
    //MARK: - 判断身份认证
    func identityJudge(_ token: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/identity_judeg"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.发送请求参数
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //MARK: - 身份认证
    func identityAuth(_ token: String, up_cate: Int, name: String, id_number: String, image: [UIImage], finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        
        //1.fetch the url string
        let urlString = "http://106.15.199.8/llb/api/user/identity_auth"
        
        //2.add access token in the http request head
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        
        //3.fetch the paraments in the http requesr body
        let parameters = ["up_cate": up_cate, "name": name, "id_number" : id_number] as [String : Any]
        
        //4.post request to the server
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](fromData) in
            let cateName = "image[]"
            for img in image {
                if let imageData = UIImageJPEGRepresentation(img, 1) {
                    let imgName = self?.getNowTime()
                    fromData.appendPart(withFileData: imageData, name: cateName, fileName: imgName!, mimeType: "image/png")
                }
            }
            }, progress: { (progress) in
        }, success: { (_, success) in
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            // return success infomation
            finished(resultDict, nil)
        }) { (_, error) in
            // return failure infomation
            finished(nil, error)
        }
    }
    
    //MARK: - 载入个人资料
    func loadProfileInfo(_ token: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/edit_data"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //MARK: - 编辑个人资料
    func updateProfile(_ token: String, cate: String?, content: String?, content_sex: Int?, image: UIImage?, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/edit_data"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        var parameters: [String: Any] = [String: AnyObject]()
        //3.发送请求参数
        
        //set image
        if image != nil {
            parameters.updateValue(1, forKey: "up_cate")
        }
        //set nickname
        if cate != nil && content != nil {
            parameters.updateValue(cate!, forKey: "cate")
            parameters.updateValue(content!, forKey: "content")
        }
        
        //set gender
        if cate != nil && content_sex != nil {
            parameters.updateValue(cate!, forKey: "cate")
            parameters.updateValue(content_sex!, forKey: "content")
        }
        //3.发送请求参数
        post(urlString, parameters: parameters, constructingBodyWith: { [weak self](formData) in
            //upload avatar
            if image != nil {
                let cateName = "image"
                if let imageData = UIImageJPEGRepresentation(image!, 0.5){
                    let imageName =  self?.getNowTime()
                    formData.appendPart(withFileData: imageData, name: cateName, fileName: imageName! , mimeType: "image/png")
                }
            }
            
            }, progress: { (Progress) in
        }, success: { (_, success) in
            guard let resultDict = success as? [String : AnyObject] else {
                return
            }
            finished(resultDict , nil)
        }) { (URLSessionDataTask, error) in
            finished(nil , error)
        }
    }
    
    //MARK: - 修改密码
    func changePwd(_ token: String, oldpwd: String, newpwd: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/changePwd"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["oldpwd": oldpwd, "newpwd": newpwd] as [String : Any]
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
    
    //MARK: - 忘记密码
    func forgetPwd(account: String, newpwd: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/login/forgetPwd"
        //2.获取请求参数
        let parameters = ["account": account, "newpwd": newpwd] as [String : Any]
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
    
    //MARK: - 保存小区
    func upDistrict(_ token: String, district: Int, dong: Int, door: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/up_district"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["district": district, "dong": dong, "door": door] as [String : Any]
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
    
    //MARK: - 引导页填写昵称性别
    func editNameAndSex(_ token: String, nickname: String, sex: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/edit_name"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["nickname": nickname, "sex": sex] as [String : Any]
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
    
    //MARK: - 消息首页
    func quickMessageMain(_ token: String, p: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/msg_list"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["p": p] as [String : Any]
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
    
    //MARK: - 私信列表
    func infoList(_ token: String, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/info_list"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //3.发送请求参数
        request(.POST, urlString: urlString, parameters: nil) { (result, error) -> () in
            //获取字典数据
            guard let resultDict = result as? [String : AnyObject] else {
                finished(nil, error)
                return
            }
            //将数组数据回调给外界控制器
            finished(resultDict, error)
        }
    }
    
    //MARK: - 消息历史记录
    func historyRecord(_ token: String, p: Int, to_uid: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/history_record"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["p": p, "to_uid": to_uid] as [String : Any]
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
    
    //MARK: - 发送私信
    func sendMessage(_ token: String, content: String, to_uid: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/chat"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["content": content, "to_uid": to_uid] as [String : Any]
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
    
    //MARK: - 协商群聊
    func voteConsult(_ token: String, content: String, id: Int, finished: @escaping (_ result : [String : AnyObject]? ,_ error:Error?) ->()) {
        //1.获取请求的URLString
        
        let urlString = "http://106.15.199.8/llb/api/user/chat"
        self.requestSerializer.setValue(token, forHTTPHeaderField: "token")
        //2.获取请求参数
        let parameters = ["content": content, "id": id] as [String : Any]
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
