//
//  RequestAccount.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/25.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class RequestAccount {
    /// 读取缓存中的授权模型
    private static var loadAccount: UserAccount?
    
    // MARK: - 类方法
    
    /// 获取授权用户信息并缓存信息
    /// 调用此方法之前，确保已经授权完成并对access_token令牌数据进行转模型
    class func loadAndSaveAccount(account: UserAccount, complete:() -> Void) {
        // 断言
        // 断定access_token一定不等于nil的，如果运行的时候access_token等于nil，程序就会崩溃并且报错
        assert(account.access_token != nil, "使用该方法必须先授权")
        
        // 1.准备请求参数
        let parameters = ["access_token": account.access_token!, "uid": account.uid]
        
        // 2.发送请求
        NetWorkTools.shareIntance.loadUserInfo(parameters as! [String : AnyObject]) { (response) in
            guard let data = response.data else {
                QL3("获取不到数据")
                return
            }
            
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String: AnyObject]
                
                // 2.1 取出用户信息
                account.screen_name = dict["screen_name"] as? String
                account.avatar_large = dict["avatar_large"] as? String
                
                // 2.2 缓存用户信息
                NSKeyedArchiver.archiveRootObject(account, toFile: "userAccount.plist".cachesDir())
                
                // 回调
                complete()
                
            } catch {
                QL3("json转字典失败")
            }
        }
    }
    
    /// 解档读取
    class func loadUserAccount() -> UserAccount? {
        // 1.判断是否已经加载过了
        if UserAccount.account != nil {
            QL2("已经加载过")
            return RequestAccount.loadAccount
        }
        
        QL2("userAccount.plist".cachesDir())
        
        // 2.尝试从文件中加载
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile("userAccount.plist".cachesDir()) as? UserAccount else {
            QL2("没有缓存授权文件")
            return nil
        }
        
        // 3.校验是否过期
        guard let date = account.expires_Date where date.compare(NSDate()) != .OrderedAscending else {
            QL2("令牌过期了")
            return nil
        }
        
        RequestAccount.loadAccount = account
        
        return RequestAccount.loadAccount
    }
    
    /// 判断用户是否登录
    class func isLogin() -> Bool {
        return RequestAccount.loadUserAccount() != nil
    }

}
