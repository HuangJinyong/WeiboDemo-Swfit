//
//  NSDate+Extension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/24.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

extension NSDate {
    
    /// 根据一个字符串创建一个NSDate
    class func createDate(time: String, dateFormatter: String) -> NSDate? {
        if time == "" {
            return NSDate()
        }
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = dateFormatter
        // 如果不指定以下区域，真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        return formatter.dateFromString(time)
    }
    
    /// 根据当前时间生成一个不同时间种类相对应的字符串
    /**
     刚刚：一分钟内
     x分钟前：一小时内
     x小时前：当天
     
     昨天： HH：mm
     一年内：MM-dd HH：mm
     更早期：yyyy-MM-dd HH：mm
    */
    
    func descriptionStringFromDate() -> String {
        // 1.创建日历
        let calendar = NSCalendar.currentCalendar()
        
        // 2.创建日期格式器
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        // 3.记录时间格式
        var formatterStr = "HH:mm"
        
        // 2.对日期进行判断
        if calendar.isDateInToday(self) {
            // 3.1 是今天发布
            // 比较发布的时间跟当前时间的差值
            let interval = Int(NSDate().timeIntervalSinceDate(self))
            
            if interval < 60 {
                // 时间小于1分钟
                return "刚刚"
                
            } else if interval < 60 * 60 {
                // 时间小于一个小时
                return "\(interval / 60)分前"
                
            } else if interval < 60 * 60 * 24 {
                // 时间小于一天
                return "\(interval / (60 * 60))小时前"
            }
            
        } else if calendar.isDateInYesterday(self) {
            // 3.2 昨天发布
            formatterStr = "昨天" + formatterStr
            
        } else {
            // 3.3 不是今天发布也不是今年发布
            // 获取两个时间时间间隔
            let components = calendar.components(.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            
            if components.year >= 1 {
                // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
                
            } else {
                // 一年以内
                formatterStr = "MM-dd " + formatterStr
                
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.stringFromDate(self)
    }
}
