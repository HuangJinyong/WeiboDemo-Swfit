//
//  AYViewControllerAnimatedTransitioning.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/9.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYTransitioningManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    private let duration: NSTimeInterval = 0.2 // 动画执行时间
    private var isPresenting: Bool = false // 标记当前是否呈现
    
    var presentFrame = CGRectZero

    // MARK: - UIViewControllerTransitioningDelegate

    // 该方法返回一个呈现过渡对象
    // 可以在该对象中控制弹出的尺寸等
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        let pc = AYPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pc.presentFrame = presentFrame
        
        return pc
    }
    

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        NSNotificationCenter.defaultCenter().postNotificationName(AYTransitioningManagerPresented, object: self)
       
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        NSNotificationCenter.defaultCenter().postNotificationName(AYTransitioningManagerDismissed, object: self)
        
        return self
    }

    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    // 过渡动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    // 实现过渡动画方法
    // 只要我们实现了这个代理方法，那么不用调用系统的默认动画了，使用的动画操作都需要我们自己实现，包括需要展现的视图也需要我们自己添加到容器上
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
            animatePresentWithTransitionContext(transitionContext)
        } else {
            animateDismissWithTransitionContext(transitionContext)
        }
    }
    
    // MARK: - 内部实现方法
    
    // 过渡
    private func animatePresentWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        // 1.获取被呈现的视图控制器、视图、容器视图
        guard
            let presentedViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey),
            let containerView = transitionContext.containerView()
        else {
            return
        }
        
        // 2.设定被呈现视图的动画开始位置
        let finalRect = transitionContext.finalFrameForViewController(presentedViewController)
        
        presentedView.frame = finalRect
        presentedView.frame.origin.y -= finalRect.size.height / 2
        presentedView.layer.anchorPoint = CGPointMake(0.5, 0.0)
        presentedView.transform = CGAffineTransformMakeScale(1.0, 0.0)
        containerView.addSubview(presentedView)
        
        // 3.动画呈现
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
            presentedView.transform = CGAffineTransformIdentity
        }) { (complete: Bool) in
            // 注意：自定转场动画，在执行完动画之后，一定要告诉系统动画执行完毕
            transitionContext.completeTransition(complete)
        }
    }
    
    // 消失
    private func animateDismissWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let presentedView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        else {
            return
        }
        
        UIView.animateWithDuration(duration, animations: {
            // 突然消失的原因：因为CGFloat不准确，导致无法执行动画，遇到这样的问题只要将CGFloat的值设置为一个很小的值即可
            presentedView.transform = CGAffineTransformMakeScale(1.0, 0.00001)
        }) { (complete: Bool) in
            transitionContext.completeTransition(complete)
        }
    }
}

