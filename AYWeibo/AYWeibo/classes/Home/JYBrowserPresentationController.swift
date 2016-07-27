//
//  JYBrowserPresentationController.swift
//  AYWeibo
//
//  Created by Kinyong on 16/7/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

protocol JYBrowserPresentationDelegate: NSObjectProtocol {
    /// 用于创建一个和点击图片一摸一样的UIImageView
    func browserPresentationWillShowImage(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> UIImageView
    
    /// 用于获取点击图片相对于windows的frame
    func browserPresentationWillFromFrame(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> CGRect
    
    /// 用于获取点击图片最终的frame
    func browserPresentationWillToFrame(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> CGRect
}

class JYBrowserPresentationController: NSObject,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    /// 标记是否转场,默认为false
    private var ispresent = false
    
    /// 当前点击图片对应的索引
    private var index: NSIndexPath?
    
    /// 代理对象
    private weak var browserDelegate: JYBrowserPresentationDelegate?

    /// 执行动画的时间
    private let duration: NSTimeInterval = 0.2
    
    
    /// 设置默认数据
    func setDefaultInfo(indext: NSIndexPath, browserDelegate: JYBrowserPresentationDelegate) {
        self.index = indext
        self.browserDelegate = browserDelegate
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = true
        
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        ispresent = false
        
        return self
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
     
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if ispresent {
            animatePresentWithTransitionContext(transitionContext)
        } else {
            animateDismissWithTransitionContext(transitionContext)
        }
    }
    
    // MARK: - 内部控制方法
    private func animatePresentWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        assert(index != nil, "必须设置被点击cell的indexPath")
        assert(browserDelegate != nil, "必须设置代理才能展现")
        // 1. 获取被呈现的view和容器视图
        guard
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let containerView = transitionContext.containerView()
        else {
            return
        }
        
        // 2. 新建一个imageView，并且上面显示的内容和被点击的图片的位置大小一模一样
        let imageView = browserDelegate!.browserPresentationWillShowImage(self, indexPath: index!)
        // 2.1 获取点击图片相对于window的frame，因为容器视图是全屏的，而图片是添加到容器视图上面，所以必须获取相对于window的frame
        imageView.frame = browserDelegate!.browserPresentationWillFromFrame(self, indexPath: index!)
        // 2.2 获取点击图片最终的显示尺寸
        let toFrame = browserDelegate!.browserPresentationWillToFrame(self, indexPath: index!)
        // 3. 执行动画
        containerView.addSubview(imageView)
        
        UIView.animateWithDuration(duration, animations: { 
            imageView.frame = toFrame
           
        }) { (_) in
                // 移除自己添加的UIimageview
                imageView.removeFromSuperview()
                // 显示图片浏览器
                containerView.addSubview(toView)
                // 告诉系统动画执行完毕
                transitionContext.completeTransition(true)
        }
    }
    
    private func animateDismissWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        transitionContext.completeTransition(true)
    }
}
