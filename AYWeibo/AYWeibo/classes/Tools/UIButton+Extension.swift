//
//  ButtonExtension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/5.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName: String?, backgroundImageName: String?) {
        self.init()
        
        // 1.设置前景图片
        if let name = imageName {
            self.setImage(UIImage(named: name), forState: .Normal)
            self.setImage(UIImage(named: name + "_highlighted"), forState: .Highlighted)
        }
       
        // 2.设置背景图片
        if let bgName = backgroundImageName {
            self.setBackgroundImage(UIImage(named: bgName), forState: .Normal)
            self.setBackgroundImage(UIImage(named: bgName + "_highlighted"), forState: .Highlighted)
        }
        self.sizeToFit()
    }
}

