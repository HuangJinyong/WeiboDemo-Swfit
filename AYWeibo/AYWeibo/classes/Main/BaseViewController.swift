//
//  BaseViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/4.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {
    
    /// 标记用户登录状态 true为登录，false为没有登录
    var isLogin = RequestAccount.isLogin()
    
    /// 访客视图
    var visitorView: VisitorView?

    override func loadView() {
        isLogin ? super.loadView() : setupVistorView()
    }
    
    // MARK: - 内部控制方法
    private func setupVistorView() {
        
        // 1.创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        
        // 2.添加导航条注册和登录按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(self.registerBtnClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(self.loginBtnClick(_:)))
        
        // 3.添加按钮监听
        visitorView?.registerButton.addTarget(self, action: #selector(self.registerBtnClick(_:)), forControlEvents: .TouchUpInside)
        visitorView?.loginButton.addTarget(self, action: #selector(self.loginBtnClick(_:)), forControlEvents: .TouchUpInside)
    }
    
    // 注册
    @objc private func registerBtnClick(sender: UIButton) {
        QL2("")
    }
    
    // 登录
    @objc private func loginBtnClick(sender: UIButton) {
        QL2("")
        let navigation = UINavigationController(rootViewController: OAuthViewController())
        presentViewController(navigation, animated: true, completion: nil)
    }

}
