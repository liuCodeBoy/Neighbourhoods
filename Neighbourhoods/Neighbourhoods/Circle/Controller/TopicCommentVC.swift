//
//  TopicCommentVC.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/18.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class TopicCommentVC: UIViewController ,UITextViewDelegate {
    var pid : NSNumber?
    var row : NSNumber?
    var to_uid :NSNumber?
    var uid  : NSNumber?
    var post_id :NSNumber?
    @IBOutlet weak var sendOutBtn: UIBarButtonItem!
    var commentLabel : String?{
        didSet{
            if commentLabel?.characters.count == 0 {
                self.sendOutBtn.isEnabled = false
            }else{
                self.sendOutBtn.isEnabled = true
            }
        }
    }
   
    @IBAction func sendOut(_ sender: UIBarButtonItem) {
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(hintMessgae: "你还未登录", completion: nil)
            return
        }
        NetWorkTool.shareInstance.topicReply(token: UserDefaults.standard.string(forKey: "token")!, pid: self.pid! , to_uid: self.to_uid!, uid: self.uid!, post_id: self.post_id!, content:  self.commentTextField.text) { [weak self](info, error) in
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
    @IBOutlet weak var commentTextField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarBackBtn()
        commentTextField.delegate = self
        setNavBarTitle(title: "写评论")
        self.commentTextField.text = "写评论..."
        self.commentTextField.textColor = UIColor.lightGray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textViewDidChange(_ textView: UITextView) {
        self.commentLabel =   textView.text
    }
    

}
