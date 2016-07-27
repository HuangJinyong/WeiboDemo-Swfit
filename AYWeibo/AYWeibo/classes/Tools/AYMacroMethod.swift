//
//  AYMacroMethod.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/11.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

// 通过宽高返回一个在控制器中居中的矩阵
public func AYRectCenterWihtSize(width: CGFloat, _ height: CGFloat, controller: UIViewController) -> CGRect {

    let x: CGFloat = (controller.view.frame.width - width) / 2
    let y: CGFloat = (controller.view.frame.height - height) / 2 - 60
    
    return CGRectMake(x, y, width, height)
}
