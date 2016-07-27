//
//  String+Extension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

extension String {
    
    /// 快速生成缓存路径
    func cachesDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last! as NSString
        let name = (self as NSString).lastPathComponent
        
        return path.stringByAppendingPathComponent(name)
    }
    
    /// 快速生成文档路径
    func docDir() -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).last! as NSString
        let name = (self as NSString).lastPathComponent
        
        return path.stringByAppendingPathComponent(name)
    }
    
    /// 快速生成临时路径
    func tmpDir() -> String {
        let path = NSTemporaryDirectory() as NSString
        let name = (self as NSString).lastPathComponent
        
        return path.stringByAppendingPathComponent(name)
    }
}