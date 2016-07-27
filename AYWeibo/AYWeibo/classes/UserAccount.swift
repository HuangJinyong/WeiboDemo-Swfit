//
//  UserAccount.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    /// 定义属性保存授权模型
    static var account: UserAccount?
    /// 令牌
    var access_token: String?
    /// 过期时间，从授权那一刻开始，多少秒之后过期
    var expires_in: Int = 0 {
        didSet {
            expires_Date = NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    /// 用户ID
    var uid: Int = 0
    /// 真正过期时间
    var expires_Date: NSDate?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    // 当KVC发现没有对应的KEY时就会调用
    // 重写这个方法会保证 setValuesForKeysWithDictionary 继续遍历后续的 key，避免程序会直接崩溃
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    // 通过重写这个属性，可快print时候速查看模型的键值对
    override var description: String {
        let propertys = ["access_token", "expires_in", "uid"]
        let dict = dictionaryWithValuesForKeys(propertys)
        
        return "\(dict)"
    }
    
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeInteger(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeIntegerForKey("uid") as Int
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
    
}
