//
//  IssueMissionViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 01/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import NoticeBar
class IssueMissionViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    
    var progressView: UIView?
    
    @IBOutlet weak var sendBtn: UIButton!
    var commentLabel : String? {
        didSet{
            if commentLabel?.count == 0 || missionTitle.text?.count == 0 {
                self.sendBtn.isEnabled = false
            }else{
                self.sendBtn.isEnabled = true
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.commentLabel = textView.text
        self.missionDetialPlaceholderLbl.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.missionDetialTextView.becomeFirstResponder()
        return false
    }
    
    @IBOutlet weak var missionTitle: UITextField!
    @IBOutlet weak var missionScoreTF: UITextField!
    @IBOutlet weak var missionDetialTextView: UITextView!
    @IBOutlet weak var missionDetialPlaceholderLbl: UILabel!
    @IBAction func backBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    @IBAction func issueBtn(_ sender: UIButton) {
        self.missionTitle.resignFirstResponder()
        self.missionScoreTF.resignFirstResponder()
        self.missionDetialTextView.resignFirstResponder()
        guard UserDefaults.standard.string(forKey: "token") != nil else{
            self.presentHintMessage(hintMessgae:  "你还未登录", completion: nil)
            return
        }
        guard  missionTitle.text != nil else{
            self.presentHintMessage(hintMessgae:  "任务标题不能为空", completion: nil)
            return
        }
        guard  missionDetialTextView.text != nil else {
            self.presentHintMessage(hintMessgae:  "任务详情不能为空", completion: nil)
            return
        }
        if (CGFloat((missionTitle.text?.count)!) > 36) == true {
            self.presentHintMessage(hintMessgae: "任务标题不能超过36个字", completion: nil)
            return
        }
        guard missionScoreTF.text != nil else {
            self.presentHintMessage(hintMessgae:  "积分数不能为空", completion: nil)
            return
        }
        
        // MARK:- fetching data
        let progress = Bundle.main.loadNibNamed("UploadingDataView", owner: self, options: nil)?.first as! UploadingDataView
        progress.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        progress.loadingHintLbl.text = "发布中"
        self.progressView = progress
        self.view.addSubview(progress)
        
        NetWorkTool.shareInstance.task_publish(UserDefaults.standard.string(forKey: "token")!, title: missionTitle.text!, content: missionDetialTextView.text!, integral: Int(missionScoreTF.text!)!){ [weak self](info, error) in
            
            // MARK:- data fetched successfully
            UIView.animate(withDuration: 0.25, animations: {
                self?.progressView?.alpha = 0
            }, completion: { (_) in
                self?.progressView?.removeFromSuperview()
            })
            
            if info?["code"] as? String == "200"{
                let config = NoticeBarConfig(title: "发布成功", image: nil, textColor: UIColor.white, backgroundColor: UIColor.blue, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
            }else {
                let config = NoticeBarConfig(title: "服务器错误", image: nil, textColor: UIColor.white, backgroundColor: UIColor.red, barStyle: NoticeBarStyle.onNavigationBar, animationType: NoticeBarAnimationType.top )
                let noticeBar = NoticeBar(config: config)
                noticeBar.show(duration: 0.25, completed: {
                    (finished) in
                    if finished {
                        self?.dismiss(animated: true, completion: nil)
                    }
                })
            }
       }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        missionScoreTF.delegate = self
        missionDetialTextView.delegate = self
        
        self.missionTitle.becomeFirstResponder()
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        self.missionDetialTextView.addGestureRecognizer(upSwipe)
        self.missionDetialTextView.addGestureRecognizer(downSwipe)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
    }
    
    @objc func hideKeyboard() {
        self.missionScoreTF.resignFirstResponder()
        self.missionScoreTF.resignFirstResponder()
        self.missionDetialTextView.resignFirstResponder()
    }
    
    @objc func hidePlaceholderLbl() {
        self.missionDetialPlaceholderLbl.isHidden = true
    }

}
