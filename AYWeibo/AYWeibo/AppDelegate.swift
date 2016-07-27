//
//  AppDelegate.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/18.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        QorumLogs.enabled = true
        
        // 1.创建窗口
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 2.设置根控制器
        window?.rootViewController = defualtRootViewController()
        
        // 3.显示窗口
        window?.makeKeyAndVisible()
        
        // 4.注册监听：根控制器的切换
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notificationObserver(_:)), name: AYSwitchRootViewController, object: nil)
        
        // 设置导航条颜色
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
    
        // 设置标签栏背景色和样式颜色
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        return true
    }
    
    deinit {
        // 移除监听
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension AppDelegate {
    
    /// 通知监听方法: 接收到通知后进行根控制器切换
    @objc private func notificationObserver(notification: NSNotification) {
        if notification.object as! Bool {
            window?.rootViewController = MainViewController()
        } else {
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    /// 返回一个默认的根控制器
    private func defualtRootViewController() -> UIViewController {
        // 1.判断是否登录
        if RequestAccount.isLogin() {
            
            // 2.如果登录，判断是否有新版本
            if isNewVersion() {
                // 2.1 如果有新版本，返回新特性界面
                return NewfeatureViewController(collectionViewLayout: AYNewfeatureLayout())
            } else {
                // 2.2 如何没有新版本，返回欢迎界面
                return WelcomeViewController()
            }
        }
        
        // 3.如果没有登录，返回主界面
        return MainViewController()
    }
    
    /// 判断是否新版本
    private func isNewVersion() -> Bool {
        // 1.获取软件的当前版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 2.获取软件的之前旧版本号,第一次获取没有版本号，则设置为0.0
        let defualts = NSUserDefaults.standardUserDefaults()
        let agoVersion = defualts.objectForKey("version") as? String ?? "0.0"
        
        // 3.比较两个版本号
        if currentVersion.compare(agoVersion) == .OrderedDescending {
            // 如果当前版本大于之前版本，有新版号
            // 3.1 缓存当前版本号
            defualts.setObject(currentVersion, forKey: "version")
            QL2("有新版本")
            return true
        }
        
        QL2("没有新版本")
        return false
    }
}

