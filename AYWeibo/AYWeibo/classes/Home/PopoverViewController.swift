//
//  PopoverViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    private lazy var transitioningManager: AYTransitioningManager = {
       let tm = AYTransitioningManager()
        let frame = UIScreen.mainScreen().bounds
        tm.presentFrame = CGRectInset(frame, 100, 100)
        tm.presentFrame.origin.y = 50
        
        return tm
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - 内部实现方法
    private func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = transitioningManager
    }
}
