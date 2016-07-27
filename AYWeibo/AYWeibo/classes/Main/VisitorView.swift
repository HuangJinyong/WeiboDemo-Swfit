//
//  VisitorView.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/4.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class VisitorView: UIView {
    /// 登入按钮
    @IBOutlet var loginButton: UIButton!
    
    /// 注册按钮
    @IBOutlet var registerButton: UIButton!
    
    /// 转盘图片
    @IBOutlet private var rotationImgView: UIImageView!
    
    /// 文本标签
    @IBOutlet private var titleLabel: UILabel!
    
    /// 图标图片
    @IBOutlet private var iconImgView: UIImageView!
    
    // MARK: - 外部方法
    class func visitorView() -> VisitorView {
        let vistView = NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).first as! VisitorView
        return vistView
    }
    
    
    // MARK: - 内部方法
    
    /// 提供设置访客视图上的数据
    func setupVisitorInfo(imageName: String?, title: String) {
        
        // 1.设置标题
        titleLabel.text = title
        
        // 2.判断是否为首页
        guard let name = imageName else { // 不设置图标，默认为首页
            rotationImgView.hidden = false

            // 执行转盘动画
            startAnimation()
            
            return
        }
        
        // 3.设置其他数据
        iconImgView.image = UIImage(named: name)
        rotationImgView.hidden = true
    }
    
    /// 转盘旋转动画
    private func startAnimation() {
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.toValue = 2 * M_PI
        animation.duration = 5.0
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false // 切换视图控制器时候动画继续
        
        rotationImgView.layer.addAnimation(animation, forKey: nil)
    }
}
