//
//  SocialAnnouncementDetialViewController.swift
//  Neighbourhoods
//
//  Created by Weslie on 04/11/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit
import WebKit
import SDWebImage
class SocialAnnouncementDetialViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, WKUIDelegate, WKNavigationDelegate {
    lazy var tableView = UITableView()
    lazy var scrollView = UIScrollView()
    lazy var webView = WKWebView()
    var webViewHeight : CGFloat = 0
    var  detailView   : UIView?
    var  titleView    : UIView?
    var webFont = 100
    //新闻url
    var  url : NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
    }
    func createTableView() -> () {
        self.webViewHeight = 0.0;
        self.createWebView();
        self.tableView = UITableView.init(frame:CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight - 44), style: .grouped)
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = false;
        self.tableView.showsHorizontalScrollIndicator = false;
        self.tableView.separatorStyle = .none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "WebViewCell")
        self.view.addSubview(self.tableView)
    }
    
    func createWebView()
    {
        let wkWebConfig = WKWebViewConfiguration()
        let wkUController = WKUserContentController()
        wkWebConfig.userContentController = wkUController
        
        
        // 自适应屏幕宽度js
        let jSString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        let wkUserScript = WKUserScript.init(source: jSString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        // 添加js调用
        wkUController.addUserScript(wkUserScript)
        self.webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 1), configuration: wkWebConfig)
        self.webView.backgroundColor = UIColor.clear
        self.webView.isOpaque = false;
        self.webView.isUserInteractionEnabled = false;
        self.webView.scrollView.bounces = false;
        self.webView.uiDelegate = self;
        self.webView.navigationDelegate = self;
        //    self.webView.sizeToFit()
        self.webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        let  urlRequest = NSURLRequest(url: self.url! as URL)
        self.webView.load(urlRequest as URLRequest)
        self.scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth , height: 1))
        self.scrollView.addSubview(self.webView)
    }
    
    deinit {
        self.webView.scrollView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context:
        UnsafeMutableRawPointer?) {
        
        self.webView.evaluateJavaScript("document.body.clientHeight") { (anyreult, error) in
            if (error == nil) {
                let height = anyreult as! CGFloat + 50
                self.webViewHeight = height
                self.webView.frame = CGRect.init(x: 15, y: 0, width: screenWidth - 30, height: height)
                self.scrollView.frame = CGRect.init(x: 0, y: 0, width: screenWidth, height: height)
                self.scrollView.contentSize = CGSize.init(width: screenWidth, height: height)
                let indexArr = NSArray(array: [NSIndexPath.init(row: 0, section: 0)]) as? [IndexPath]
                self.tableView.reloadRows(at: indexArr!, with: .none)
            }else {
                self.webView.reload()
            }
        }
    }
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
}


//MARK: -  tableView代理方法
extension  SocialAnnouncementDetialViewController {
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return webViewHeight;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var  cell : UITableViewCell?
        let  webViewCell = tableView.dequeueReusableCell(withIdentifier: "WebViewCell", for: indexPath)
        webViewCell.contentView.addSubview(self.scrollView)
        cell = webViewCell
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //初始化热点评论
        let recommendView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
        recommendView.backgroundColor = #colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1)
        let titleLab = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 50))
        titleLab.textAlignment = .center
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textColor = UIColor.black
        titleLab.text = "查看查看查看查看查看"
        recommendView.addSubview(titleLab)
        return  recommendView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let recommendView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 70))
        recommendView.backgroundColor = #colorLiteral(red: 0.36, green: 0.79, blue: 0.96, alpha: 1)
        let titleLab = UILabel.init()
        titleLab.center.y = recommendView.center.y
        titleLab.center.x = recommendView.center.x
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textColor = UIColor.black
        titleLab.text = "查看查看查看查看查看"
        recommendView.addSubview(titleLab)
        return  recommendView
    }
   
}

