//
//  WelcomeViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    /// 头像底部约束
    private var iconBottomConstraint: NSLayoutConstraint!
    
    /// 标题
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "欢迎回来"
        label.textColor = UIColor.grayColor()
        label.alpha = 0.0
        
        return label
    }()
    
    /// 头像
    private lazy var iconImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "avatar_default_big")
        return imgView
    }()

    /// 背景图片
    private lazy var bgImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "ad_background")
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.配置子控件
        setupSubViews()

        // 2.配置约束
        setupConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 让头像执行动画
        iconAnimation()
    }
    
    // MARK: - 内部方法
    
    private func iconAnimation() {
        // 让头像执行动画
        UIView.animateWithDuration(1.0, animations: {
            self.iconBottomConstraint.constant = -(UIScreen.mainScreen().bounds.height + self.iconBottomConstraint.constant)
            self.view.layoutIfNeeded()
            
        }) { (_) in
            UIView.animateWithDuration(0.5, animations: {
                self.titleLabel.alpha = 1.0
            
            }) { (_) in
                // 发送通知进行根控制器切换：首页控制器
                NSNotificationCenter.defaultCenter().postNotificationName(AYSwitchRootViewController, object: true)
            }
        }
    }
    
    private func setupSubViews() {
        view.addSubview(bgImageView)
        
        iconImageView.layer.cornerRadius = 45.0
        iconImageView.clipsToBounds = true
        
        assert(RequestAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        
        if let url = NSURL(string: RequestAccount.loadUserAccount()!.avatar_large!) {
            // 设置头像
            iconImageView.sd_setImageWithURL(url)
        }
        
        view.addSubview(iconImageView)
        
        view.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.背景图片约束
        view.addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: bgImageView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        // 2.头像约束
        iconImageView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 90.0))
        iconImageView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 90.0))

        view.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        iconBottomConstraint = NSLayoutConstraint(item: iconImageView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: -200.0)
      
        view.addConstraint(iconBottomConstraint)
        
        // 3.标题约束
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: iconImageView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .Top, relatedBy: .Equal, toItem: iconImageView, attribute: .Bottom, multiplier: 1.0, constant: 20.0))
    }

}
