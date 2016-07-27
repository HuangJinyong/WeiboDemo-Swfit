//
//  UserModel.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/23.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    /// 字符串型的用户UID
    var idstr: String?
    
    /// 用户昵称
    var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    
    /// 用户认证类型
    /// -1：没有认真， 0：认证用户， 2，3，5：企业认证， 220：达人
    var verified_type: Int = -1
    
    /// 会员等级
    /// 1~6：分别表示对应等级的会员
    var mbrank: Int = -1

    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    override var description: String {
        let keys = ["idstr", "screen_name", "profile_image_url", "verified_type"]
        let dict = self.dictionaryWithValuesForKeys(keys)
        
        return "\(dict)"
    }
}
