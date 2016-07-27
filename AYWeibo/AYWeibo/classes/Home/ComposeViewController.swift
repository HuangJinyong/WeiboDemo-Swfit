//
//  ComposeViewController.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/23.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    /// 工具条底部约束
    private var toolbarBottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.添加子控件
        setupUI()
        
        // 2.布局子控件
        setupConstraints()
        
        // 3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillChange(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 4.将文本视图传递给toolbar
        toolbar.textView = textView
        toolbar.keyboardView = keyboardEmoticomViewController.view
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }

    override func viewWillDisappear(animated: Bool) {
        textView.resignFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    // MARK: - 内部控制方法
    func setupUI() {
        // 1.添加导航栏按钮
        let leftItem = UIBarButtonItem(title: "关闭", style: .Done, target: self, action: #selector(self.leftBarButtonClick))
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(self.rightBarButtonClick))
        // 1.1.添加左侧导航按钮
        self.navigationItem.leftBarButtonItem = leftItem
        // 1.2.添加右侧导航按钮
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.enabled = false
        // 1.3.添加导航标题
        let titleView = JYTitleView(frame: CGRectMake(0, 0, 100, 40))
        titleView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        self.navigationItem.titleView = titleView
        
        // 2.添加文本视图
        self.view.addSubview(textView)
        textView.delegate = self
        
        // 3.添加工具条
        self.view.addSubview(toolbar)
        
        // 4.添加表情键盘控制器
        self.addChildViewController(keyboardEmoticomViewController)
        
    }
    
    private func setupConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        // 文本视图布局
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: .DirectionMask, metrics: nil, views: ["textView": textView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: .DirectionMask, metrics: nil, views: ["textView": textView]))
        
        // 工具条布局
        toolbar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 44.0))
        toolbarBottomConstraint = NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: .DirectionMask, metrics: nil, views: ["toolbar": toolbar]))
        self.view.addConstraint(toolbarBottomConstraint!)
    }
    
    // 左侧导航按钮监听
    @objc private func leftBarButtonClick() {
        QL2("")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 右侧导航按钮监听
    @objc private func rightBarButtonClick() {
        QL2("")
        let text = textView.text
        NetWorkTools.shareIntance.sendStatus(text) { (data, error) in
            if error != nil {
                QL3("发送失败")
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // 通知中心键盘监听方法
    @objc private func keyboardWillChange(notification: NSNotification) {
        
        // 1.获取弹出键盘的frame
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // 2.获取屏幕的高度
        let height = UIScreen.mainScreen().bounds.height
        
        // 3.计算需要移动的距离
        let offsetY = rect.origin.y - height
        
        // 4.获取弹出键盘的节奏
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        // 5.计算弹出键盘的持续时间
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! Int
        
        // 5.修改工具条底部约束
        UIView.animateWithDuration(duration) {
            self.toolbarBottomConstraint?.constant = offsetY
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            self.view.layoutIfNeeded()
        }
        
    }
    
    // MARK: - 懒加载
    private lazy var textView: UITextView = {
        let tv = JYTextView(frame: CGRectZero, textContainer: nil)
        tv.font = UIFont.systemFontOfSize(14)
        return tv
    }()
    
    private lazy var toolbar: ComposeToolbar = {
        let tb = NSBundle.mainBundle().loadNibNamed("ComposeToolbar", owner: nil, options: nil).last as! ComposeToolbar
        return tb
    }()
    
    private lazy var keyboardEmoticomViewController: JYKeyboardEmoticonViewController = JYKeyboardEmoticonViewController()
    
}

// MARK: - UITextViewDelegate

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
