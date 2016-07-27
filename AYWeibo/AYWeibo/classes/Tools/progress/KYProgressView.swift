//
//  KYProgressView.swift
//  下载进图动态图
//
//  Created by Kinyong on 16/7/11.
//  Copyright © 2016年 Kinyong. All rights reserved.
//

import UIKit

class KYProgressView: UIView {

    /// 下载进度值，0.0 ~ 1.0
    var progress: CGFloat = 0 {
        didSet{
            hazyView.progress = progress
        }
    }
    
    /// 朦层背景
    var hazyView: HazyView = HazyView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    
    private func setupUI() {
        // 圆心坐标
        let cententX = self.bounds.width * 0.5
        let cententY = self.bounds.height * 0.5
        
        // 半径
        var redius: CGFloat = 20.0
        redius = min(cententX, cententY) < redius ?  min(cententX, cententY)  :  redius
        
        // 设置朦层背景frame
        hazyView.frame = CGRectMake(cententX - redius, cententY - redius, 2 * redius, 2 * redius)
        hazyView.backgroundColor = UIColor(red: 237 / 255.0, green: 237 / 255.0, blue: 237 / 255.0, alpha: 0.5)
        hazyView.hidden = true
        // 设置朦层背景图层
        hazyView.layer.borderWidth = 1.0
        hazyView.layer.borderColor = UIColor(white: 1.0, alpha: 0.5).CGColor
        hazyView.layer.cornerRadius = redius
        hazyView.layer.masksToBounds = true
        
        // 添加控件
        self.addSubview(hazyView)
    }
}

class HazyView: UIView {
    /// 下载进度值，0.0 ~ 1.0
    var progress: CGFloat = 0 {
        didSet{
            self.setNeedsDisplay()
        }
    }
    var taget = true
    
    override func drawRect(rect: CGRect) {
        
        if taget {
            self.hidden = false
            taget = false
        }
        
        if progress >= 0.9 {
            self.hidden = true
            return
        }
        // 圆心坐标
        let cententX = rect.width * 0.5
        let cententY = rect.height * 0.5
        let centent = CGPointMake(cententX, cententY)
        
        // 半径
        let redius: CGFloat =  min(cententX, cententY) - 4
        
        // 起始角度
        let startAngle = -CGFloat(M_PI_2)
        
        // 结束角度
        let endAngle = 2 * CGFloat(M_PI) * progress + startAngle
        
        // 设置路径
        let path = UIBezierPath(arcCenter: centent, radius: redius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.addLineToPoint(centent)
        path.closePath()
        UIColor(white: 1.0, alpha: 0.5).setFill()
        // 绘制图形
        path.fill()
    }

}
