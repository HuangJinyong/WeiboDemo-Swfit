//
//  UIBarButtonItemExtension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/5.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageName: String, target: AnyObject?, action: Selector) {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        self.init(customView: btn)
    }
}