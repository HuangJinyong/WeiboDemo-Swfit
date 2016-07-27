//
//  OAuthViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/20.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    private lazy var customWebView: UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.配置子控制器
        setupSubViews()
        
        // 2.设置约束
        setupConstraints()
        
        // 3.加载请求
        loadRequest()
    }
    
    
    // MARK: - 内部方法
    private func loadRequest() {
        
        // 1.创建URL
        guard let url = NSURL(string: "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)") else {
            return
        }
        
        // 2.创建请求
        let request = NSURLRequest(URL: url)
        
        // 3.加载登录界面
        customWebView.loadRequest(request)
    }
    
    private func setupSubViews() {
        customWebView.delegate = self
        view.addSubview(customWebView)
        
        // 导航栏左侧item
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(self.leftBarItemClick))
    }
    
    @objc private func leftBarItemClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func setupConstraints() {
        customWebView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: customWebView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
    }
}

// MARK - delegate

extension OAuthViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示网页加载提醒
        SVProgressHUD.showInfoWithStatus("正在加载中...")
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭网页加载提醒
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 0.获取URL完整地址
        guard let urlStr = request.URL?.absoluteString else {
            return false
        }
        
        // 1.判断当前是否授权回调页面
        guard urlStr.hasPrefix(WB_Redirect_uri) else {
            QL2("不是授权回调页面,继续加载web")
            return true
        }
        
        // 2.判断授权回调地址中是否包含code=且不包含error_
        let key = "code="
        
        guard urlStr.containsString(key) && !urlStr.containsString("error_") else {
            QL2("授权失败，停止加载web")
            return false
        }
        
        // 3.授权成功，提取code
        let code = request.URL?.query?.substringFromIndex(key.endIndex)
        QL2(code)
        
        // 4.通过授权code换取AccessToken
        loadAccessToken(code)
        
        return false
    }
    
    private func loadAccessToken(toCode: String?) {
        guard let code = toCode else {
            QL2("传入的code无效")
            return
        }
        
        // 1.准备请求参数
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri":WB_Redirect_uri]
        
        // 2.发送POST请求：通过code获取到access_token数据并保存到模型中
        NetWorkTools.shareIntance.loadAccessToken(parameters) { (response) in
            guard let data = response.data else {
                QL2("获取不到数据")
                return
            }
            QL4(NSThread.currentThread())
            // 2.1 json转对象
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves) as! [String: AnyObject]
                // 2.2 将获取到access_token数据的转模型
                let account = UserAccount(dict:dict)
                
                // 3.获取用户数据并缓存
                RequestAccount.loadAndSaveAccount(account, complete: { 
                    // 因为获取用户数据并缓存数据是在异步进行的
                    // 如果不在闭包中进行关闭界面和控制器的操作，会造成提前进入欢迎界面，导致因为获取不到缓存数据而报错
                    // 4.关闭界面
                    self.leftBarItemClick()
                    
                    // 5.发送通知进行根控制器切换：欢迎界面
                    NSNotificationCenter.defaultCenter().postNotificationName(AYSwitchRootViewController, object: false)
                })
        
            } catch {
                QL2("json转字典失败")
            }
        }
    }
}
