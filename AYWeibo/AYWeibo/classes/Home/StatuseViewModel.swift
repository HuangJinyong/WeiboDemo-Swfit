//
//  StatuseViewModel.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/25.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

/*
 M: 模型（保存数据）
 V: 视图（展现数据）
 C: 控制器（管理模型和视图，桥梁）
 VM: 1.可以对M和V进行瘦身
     2.处理业务逻辑
 */

class StatuseViewModel: NSObject {
    /// 模型对象
    var statuse: StatuseModel
    
    /// 头像URL
    var user_icon_url: NSURL?
    
    /// 认证图片
    var user_verified_image: UIImage?
    
    /// 会员图标
    var user_vip_image: UIImage?
    
    /// 昵称
    var user_name_text: String?
    
    /// 格式化后类型的时间
    var time_string: String?
    
    /// 来源
    var source_text: String?
    
    /// 正文
    var content_text: String?
    
    /// 转发正文
    var forward_content_text: String?
    
    /// 缩略图片地址
    var thumbnail_urls: [NSURL]?
    
    /// 大图图片地址
    var bmiddle_urls: [NSURL]?
    
    
    init(statuse: StatuseModel) {
        self.statuse = statuse
        
        // 1.处理头像
        if let iconStr = statuse.user?.profile_image_url {
            user_icon_url = NSURL(string: iconStr)
        }
        
        // 2.处理认证图片
        switch statuse.user?.verified_type ?? -1 {
        case 0:
            user_verified_image = UIImage(named: "avatar_vip")
       
        case 2, 3, 5:
            user_verified_image = UIImage(named: "avatar_enterprise_vip")
        
        case 220:
            user_verified_image = UIImage(named: "avatar_grassroot")
        
        default:
            user_verified_image = nil
        }
        
        // 3.处理会员图标
        if statuse.user?.mbrank >= 1 && statuse.user?.mbrank <= 6 {
            user_vip_image = UIImage(named: "common_icon_membership_level\(statuse.user!.mbrank)")
        } else if statuse.user?.mbrank == 0 {
            user_vip_image = UIImage(named: "common_icon_membership")
        }
        
        // 4.处理昵称
        user_name_text = statuse.user?.screen_name
        
        // 5.处理时间
        if let timeStr = statuse.created_at {
            // 5.1 将服务器返回的时间格式化成NSDate
            let createDate = NSDate.createDate(timeStr, dateFormatter: "EE MM dd HH:mm:ss Z yyyy")
            
            // 5.2 生成发布微博时间种类对应的字符串
            time_string = createDate?.descriptionStringFromDate()
        }
        
        // 6.处理来源
        if let source: NSString = statuse.source where source != "" {
            // 6.1 指定从什么位置开始截取
            let startIndex = source.rangeOfString(">").location + 1
          
            // 6.2 指定截取的长度
            let length = source.rangeOfString("<", options: .BackwardsSearch).location - startIndex
            
            // 6.3 截取字符串
            let restStr = source.substringWithRange(NSMakeRange(startIndex, length))
            
            source_text = "来自\(restStr)"
        
        } else {
            source_text = ""
        }
        
        // 7.处理正文
        content_text = statuse.text
        
        // 8.处理缩略图RUL
        if let pic_url = statuse.pic_urls {
            thumbnail_urls = [NSURL]()
            bmiddle_urls = [NSURL]()
            
            // 8.1 从模型中取出配图数据
            for dict in pic_url {
                guard var urlStr = dict["thumbnail_pic"] as? String else {
                    continue
                }
                
                var url = NSURL(string: urlStr)!
                
                // 8.2 根据字符串创建URL
                thumbnail_urls?.append(url)
                
                // 8.3 创建大图URL
                urlStr = urlStr.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
                url = NSURL(string: urlStr)!
                bmiddle_urls?.append(url)
            }
        }
        
        // 9.处理转发正文
        if let text = statuse.retweeted_status?.text {
            let name = statuse.retweeted_status?.user?.screen_name ?? ""
            forward_content_text = "@" + name + ":" + text
        }
    }
}
