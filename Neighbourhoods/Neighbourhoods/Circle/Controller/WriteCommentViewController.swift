//
//  WriteCommentViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class WriteCommentViewController: UIViewController ,UITextViewDelegate{
    var isTopic : NSInteger?
    var pid : NSNumber?
    var row : NSNumber?
    var to_uid :NSNumber?
    var uid  : NSNumber?
    var post_id :NSNumber?
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    var commentLabel : String? {
        didSet{
            if commentLabel?.count == 0 {
                self.sendBtn.isEnabled = false
            }else{
                self.sendBtn.isEnabled = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        commentTextView.delegate = self
        setNavBarTitle(title: "写评论")
        self.commentTextView.becomeFirstResponder()
    }
    
    @IBAction func sendOutComment(_ sender: Any) {
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        print(self.commentTextView.text)
        guard self.commentTextView.text.count > 0 else {
            self.presentHintMessage(hintMessgae: "输出内容不能为空", completion: nil)
            return
        }
        
        
        if self.isTopic == nil {
            NetWorkTool.shareInstance.postReply(token: UserDefaults.standard.string(forKey: "token")!, pid: self.pid! , to_uid: self.to_uid!, uid: self.uid!, post_id: self.post_id!, content:  self.commentTextView.text) { [weak self](info, error) in
                if info?["code"] as? String == "200"{
                    if let result  = info!["result"]
                    {
                        let config = NoticeBarConfig(title:result as? String, image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                        let noticeBar = NoticeBar(config: config)
                        noticeBar.show(duration: 0.5, completed: {
                            (finished) in
                            if finished {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                }
            }
        }else{
            NetWorkTool.shareInstance.topicReply(token: UserDefaults.standard.string(forKey: "token")!, pid: self.pid! , to_uid: self.to_uid!, uid: self.uid!, post_id: self.post_id!, content:  self.commentTextView.text) { [weak self](info, error) in
                if info?["code"] as? String == "200"{
                    if let result  = info!["result"]
                    {
                        let config = NoticeBarConfig(title:result as? String, image: nil, textColor: UIColor.white, backgroundColor:#colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1) , barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                        let noticeBar = NoticeBar(config: config)
                        noticeBar.show(duration: 0.5, completed: {
                            (finished) in
                            if finished {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    }
                }
            }
        }
        
       
  }
        
    func textViewDidChange(_ textView: UITextView) {
           self.commentLabel = textView.text
    }
   
    
}
