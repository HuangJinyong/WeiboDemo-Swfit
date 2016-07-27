//
//  UITabBarItemExtension.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class UITabBarItemExtension: UITabBarItem {
    
    init(title: String, imageName: String, tag: Int) {
        super.init()
        self.title = title
        self.image = UIImage(named: imageName)
        self.selectedImage = UIImage(named: imageName + "_highlighted")
        self.tag = tag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
