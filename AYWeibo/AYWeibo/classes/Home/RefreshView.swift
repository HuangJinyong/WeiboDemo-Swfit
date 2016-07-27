//
//  KYRefreshControl.swift
//  AYWeibo
//
//  Created by Kinyong on 16/7/1.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class KYRefreshControl: UIRefreshControl {
    
    lazy var refrenshView: RefreshView = RefreshView.refreshVeiw()
    
    // 定义旋转标记:记录箭头是否要旋转
    private var ratationFlag = false
    
    override init() {
        super.init()
        // 1.添加子控件
        setupSubView()
        // 2.监听 KYRefreshControl frame改变
        self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 内部控制方法
    // 刷新完成
    override func endRefreshing() {
        super.endRefreshing()
        // 关闭刷新动画
        refrenshView.stopLoadingView()
    }
    
    // 监听frame方法： 监听刷新
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y == 0 || frame.origin.y == -64{
            // 数据筛选
            return
        }
        
        // 1. 如果开始刷新, 第2步就不用执行。
        if self.refreshing {
            // 执行刷新动画
            refrenshView.startLoadingView()
            return
        }
        
        // 2.没有开始刷新
        if frame.origin.y < -55 && !ratationFlag {
            ratationFlag = true
            refrenshView.rotationArrow(ratationFlag)
            QL3("往上旋转")
        } else if frame.origin.y > -55 && ratationFlag {
            ratationFlag = false
            refrenshView.rotationArrow(ratationFlag)
            QL3("往下旋转")
        }
    }
    
    private func setupSubView() {
    
        self.addSubview(refrenshView)
        
        refrenshView.translatesAutoresizingMaskIntoConstraints = false
    
        refrenshView.addConstraint(NSLayoutConstraint(item: refrenshView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 150.0))
        refrenshView.addConstraint(NSLayoutConstraint(item: refrenshView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 50.0))
        self.addConstraint(NSLayoutConstraint(item: refrenshView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: refrenshView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
}


class RefreshView: UIView {

    @IBOutlet var arrowImageView: UIImageView!
    @IBOutlet var tipView: UIView!
    @IBOutlet var loadingImageView: UIImageView!
    
    class func refreshVeiw() -> RefreshView {
        return NSBundle.mainBundle().loadNibNamed("RefreshView", owner: nil, options: nil).last as! RefreshView
    }
    
    
    // MARK: - 外部控制方法
    
    /// 旋转箭头
    func rotationArrow(flag: Bool) {
        var angle: CGFloat = flag ? 0.01 : -0.01
        angle += CGFloat(M_PI)
        
        UIView.animateWithDuration(1.0) { 
            self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, angle)
        }
    }
    
    /// 显示刷新图片
    func startLoadingView() {
        // 0.隐藏提示视图
        tipView.hidden = true
        
        // 通过keyPath判断是否有添加动画
        if let _ = loadingImageView.layer.animationForKey("laodingImageView") {
            // 如果已经添加过动画，直接返回。保证动画整个过程只添加一次
            return
        }
        QL3("")
        // 1. 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * M_PI
        anim.duration = 2.0
        anim.repeatCount = MAXFLOAT
        
        // 2.添加动画到图层
        loadingImageView.layer.addAnimation(anim, forKey: "laodingImageView")
    }
    
    /// 隐藏刷新图片
    func stopLoadingView() {
        // 0. 显示提示视图
        tipView.hidden = false
        
        // 1. 移除动画
        loadingImageView.layer.removeAllAnimations()
    }
}
