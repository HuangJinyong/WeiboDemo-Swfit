//
//  AYPresentationController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/7.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYPresentationController: UIPresentationController {
    
    var presentFrame = CGRectZero
    
    private lazy var btnView: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    override func presentationTransitionWillBegin() {
        
        guard
            let containerView = containerView
        else {
            return
        }
        
        btnView.frame = containerView.bounds
        btnView.addTarget(self, action: #selector(self.btnClick), forControlEvents: .TouchUpInside)
        containerView.addSubview(btnView)
    }
    
    override func presentationTransitionDidEnd(completed: Bool) {
        // 如果过渡没完成，就移除按钮视图
        if !completed {
            btnView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        // 如果消失没完成，就移除按钮视图
        if !completed {
            btnView.removeFromSuperview()
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        
        return presentFrame
    }
    
    
    // MARK: - 内部实现方法
    // 按钮点击监听方法
    @objc private func btnClick() {
        QL2("")
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

}
