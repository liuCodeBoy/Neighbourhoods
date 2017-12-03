//
//  ChattingViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 26/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

class ChattingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputDialogueView: UIView!
    @IBOutlet weak var inputTF: UITextField!
    
    
    var chatUserNickName: String? {
        didSet {
            if let nickName = self.chatUserNickName {
                self.setNavBarTitle(title: nickName)
            }
        }
    }
    
    var to_uid: Int?
    
    var id: Int?
    
    var isConsultingChat: Bool = false
    
    var isPushedFromTabBarHidden = false
    
    private var pages = 1
    private var page = 1
    
    private var temporaryPages = 0
    
    private var chatHistoryArray = [MsgHistoryModel]()
    
    // MARK:- sert the state of the send button
    var inputText: String? {
        didSet {
            if inputText?.count == 0 {
                sendBtn.isEnabled = false
                sendBtn.backgroundColor = UIColor.init(white: 0.84, alpha: 1)
            } else {
                sendBtn.isEnabled = true
                sendBtn.backgroundColor = defaultBlueColor
            }
        }
    }
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBAction func sendBtnClicked(_ sender: UIButton) {
        
        if inputTF.text?.replacingOccurrences(of: " ", with: "") == "" || inputTF.text == nil || inputTF.text == "" {
            presentHintMessage(hintMessgae: "输入不能为空", completion: nil)
            return
        }
//        self.chatHistoryArray.removeAll()
//        self.temporaryPages = 0
//        self.page = 1
//        lastedRequest(p: page)

        
        if isConsultingChat == false {
            postChat()
        } else {
            postConsult()
        }
        
        let fakeModel = MsgHistoryModel()
        fakeModel.content = inputTF.text
        fakeModel.is_user = 1
        
        self.chatHistoryArray.append(fakeModel)
        self.tableView.reloadData()
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBarBackBtn()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sendBtn.setTitleColor(UIColor.darkGray, for: .disabled)
        sendBtn.setTitleColor(UIColor.white, for: .normal)
        
        inputTF.delegate = self
        
        lastedRequest(p: page)
        loadRefreshComponet()

        //接受键盘输入通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notific:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //接受键盘收回通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        inputTF.addTarget(self, action: #selector(passData), for: .allEditingEvents)
        
    }
    
    @objc func passData() {
        inputText = inputTF.text
    }
    
    func loadRefreshComponet() -> () {
        //默认下拉刷新
        tableView.mj_header = LXQHeader(refreshingTarget: self, refreshingAction: #selector(refresh))
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        tableView.mj_header.isAutomaticallyChangeAlpha = true
    }
    @objc func refresh() -> () {
//        self.page = 1
        lastedRequest(p: page)
//        tableView.mj_header.endRefreshing()
        
    }

    
    //MARK: - 最新发布网络请求
    func lastedRequest(p : Int) -> () {
        
        if page == temporaryPages {
            tableView.mj_header.endRefreshing()
            return
        } else {
            temporaryPages = page
        }
        
        if isConsultingChat == false {
            loadChattingHistory()
        } else {
            loadConsultingHistory()
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        inputTF.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
//        let timeCell = tableView.dequeueReusableCell(withIdentifier: "ChattingTimeCell") as! ChattingTimeTableViewCell
        let chatWithCell = tableView.dequeueReusableCell(withIdentifier: "ChattingWithCell") as! ChattingWithTableViewCell
        let chatDialogueCell = tableView.dequeueReusableCell(withIdentifier: "ChatDialogueCell") as! ChattingDialogueTableViewCell
        
        if chatHistoryArray.count == 0 { return chatWithCell }
        
        if chatHistoryArray[indexPath.row].is_user == 1 {
            chatDialogueCell.viewModel = chatHistoryArray[indexPath.row]
            if chatHistoryArray[indexPath.row].id == nil {
                chatDialogueCell.avatar.image = userAvatar.image
            }
            cell = chatDialogueCell
        } else {
            chatWithCell.viewModel = chatHistoryArray[indexPath.row]
            cell = chatWithCell
        }
        
        return cell!
        
    }
    
    func loadConsultingHistory() {
        
guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        guard let id = id else { return }
        
        NetWorkTool.shareInstance.option_list(access_token, p: page, status: 1, cate: 0, id: id) { [weak self](info, error) in
            
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let taskDict =  result[i]
                    if  let taskListModel = MsgHistoryModel.mj_object(withKeyValues: taskDict) {
                        self?.chatHistoryArray.insert(taskListModel, at: 0)
                        
                    }
                }
                self?.tableView.reloadData()
                
                
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                
                guard (self?.chatHistoryArray.count) != nil else {
                    return
                }

                self?.tableView.mj_header.endRefreshing()
            }else{
                //服务器
                self?.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    func loadChattingHistory() {
        
        guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        guard let to_uid = to_uid else {
            return
        }
        
        NetWorkTool.shareInstance.historyRecord(access_token, p: page, to_uid: to_uid) { [weak self](info, error) in
            
            if info?["code"] as? String == "200"{
                if let pages  = info!["result"]!["pages"] {
                    self?.pages = pages as! Int
                }
                
                let result  = info!["result"]!["list"] as! [NSDictionary]
                for i in 0..<result.count {
                    let taskDict =  result[i]
                    if  let taskListModel = MsgHistoryModel.mj_object(withKeyValues: taskDict) {
                        self?.chatHistoryArray.insert(taskListModel, at: 0)
                        
                    }
                }
                self?.tableView.reloadData()
                // FIXME:- under some circumsatances it will brake for upwrapping nil
                
                if let tempPage = self?.page, let tempPages = self?.pages {
                    if tempPage < tempPages {
                        self?.page += 1
                    }
                }
                
//                guard let arrayCount = self?.chatHistoryArray.count else {
//                    return
//                }
                
//                if arrayCount == 0 {
//                    self?.coverView.showLab.text = "暂无任务"
//                    self?.coverView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
//                    self?.view.addSubview((self?.coverView)!)
//                }
                
                self?.tableView.mj_header.endRefreshing()
            }else{
                //服务器
                self?.tableView.mj_header.endRefreshing()
            }
            
        }
        
    }
    
    func postChat() {
        
guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        guard let to_uid = to_uid else { return }
        
        NetWorkTool.shareInstance.sendMessage(access_token, content: inputTF.text!, to_uid: to_uid) { [weak self](result, error) in
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self?.inputTF.text = ""
                self?.tableView.reloadData()
            } else {
                //print(result!["code"] as! String)
            }
        }
    }
    
    func postConsult() {
        
guard let access_token = UserDefaults.standard.string(forKey: "token") else {
            self.presentHintMessage(hintMessgae: "你还未登陆", completion: { (_) in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        guard let id = id else { return }

        NetWorkTool.shareInstance.voteConsult(access_token, content: inputTF.text!, id: id) { [weak self](result, error) in
            if error != nil {
                //print(error as AnyObject)
            } else if result!["code"] as! String == "200" {
                self?.inputTF.text = ""
                self?.tableView.reloadData()
            } else {
                //print(result!["code"] as! String)
            }
        }
    }

    //键盘的弹起监控
    @objc func keyboardWillChangeFrame(notific: NSNotification) {
        let info = notific.userInfo
        let  keyBoardBounds = (info?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (info?[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        var deltaY = keyBoardBounds.size.height - 2 * tabBarHeight + (self.inputDialogueView?.frame.height)!
        let animations:(() -> Void) = {
            //键盘的偏移量
            
            if self.isPushedFromTabBarHidden == true {
                deltaY = keyBoardBounds.size.height
            }
            
            self.inputDialogueView.transform = CGAffineTransform(translationX: 0 , y: -(deltaY))
           
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((info?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
        }else{
            animations()
        }
    }
    //键盘的收起监控
    @objc func keyboardWillHidden(note: NSNotification) {
        let userInfo  = note.userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations:(() -> Void) = {
            //键盘的偏移量
            self.inputDialogueView.transform = .identity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
