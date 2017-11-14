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
    var pid : NSNumber?{
        didSet{
            
        }
    }
    var to_uid :NSNumber?
    var uid  : NSNumber?
    var post_id :NSNumber?
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendBtn: UIBarButtonItem!
    var commentLabel : String?{
        didSet{
            if commentLabel?.characters.count == 0 {
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
        self.commentTextView.text = "写评论..."
        self.commentTextView.textColor = UIColor.lightGray
    }
    
    @IBAction func sendOutComment(_ sender: Any) {
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(target: self, hintMessgae:  "你还未登录")
            return
        }
        NetWorkTool.shareInstance.postReply(token: UserDefaults.standard.string(forKey: "token")!, pid: self.pid! , to_uid: self.to_uid!, uid: self.uid!, post_id: self.post_id!, content:  self.commentTextView.text) { (info, error) in
            if info?["code"] as? String == "200"{
                if let result  = info!["result"]
                {
                    let config = NoticeBarConfig(title:result as? String, image: nil, textColor: UIColor.white, backgroundColor: UIColor.yellow, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                    let noticeBar = NoticeBar(config: config)
                    noticeBar.show(duration: 0.5, completed: {
                        (finished) in
                        if finished {
                            self.navigationController?.popViewController(animated: true)

                        }
                    })
                }
            }
        }
  }
        
    func textViewDidChange(_ textView: UITextView) {
           self.commentLabel =   textView.text
    }
   
    
}
