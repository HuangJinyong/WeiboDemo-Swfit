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
    
    /// 相册视图的高度约束
    private var heightConstraintPhotoPackerView: NSLayoutConstraint?
    
    /// 微博最大字数
    private let maxCount = 10
    
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
    

    // MARK: 内部控制方法
    func setupUI() {
        // 添加导航栏按钮
        let leftItem = UIBarButtonItem(title: "关闭", style: .Done, target: self, action: #selector(self.leftBarButtonClick))
        let rightItem = UIBarButtonItem(title: "发送", style: .Done, target: self, action: #selector(self.rightBarButtonClick))
        
        // 添加左侧导航按钮
        self.navigationItem.leftBarButtonItem = leftItem
        
        // 添加右侧导航按钮
        self.navigationItem.rightBarButtonItem = rightItem
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        // 添加导航标题
        let titleView = JYTitleView(frame: CGRectMake(0, 0, 100, 40))
        titleView.backgroundColor = self.navigationController?.navigationBar.backgroundColor
        self.navigationItem.titleView = titleView
        
        // 添加文本视图
        self.view.addSubview(textView)
        textView.delegate = self
        
        // 添加提示label
        self.view.addSubview(tipLabel)
        
        // 添加相册选择视图
        self.addChildViewController(photoPickerController)
        self.view.addSubview(photoPickerController.view)
        
        // 添加工具条
        
        self.view.addSubview(toolbar)
    }
    
    private func setupConstraints() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
        photoPickerController.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        // 文本视图布局
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[textView]-0-|", options: .DirectionMask, metrics: nil, views: ["textView": textView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[textView]-0-|", options: .DirectionMask, metrics: nil, views: ["textView": textView]))
        
        // 工具条布局
        toolbar.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 44.0))
        toolbarBottomConstraint = NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolbar]-0-|", options: .DirectionMask, metrics: nil, views: ["toolbar": toolbar]))
        self.view.addConstraint(toolbarBottomConstraint!)
        
        // 提示label布局
        var constraintsLabel = NSLayoutConstraint.constraintsWithVisualFormat("H:[tipLabel(40)]-0-|", options: .DirectionMask, metrics: nil, views: ["tipLabel": tipLabel, "toolbar": toolbar])
        constraintsLabel += NSLayoutConstraint.constraintsWithVisualFormat("V:[tipLabel(20)]-5-[toolbar]", options: .DirectionMask, metrics: nil, views: ["tipLabel": tipLabel, "toolbar": toolbar])
        self.view.addConstraints(constraintsLabel)
        
        // 布局相册选择视图
        heightConstraintPhotoPackerView = NSLayoutConstraint(item: photoPickerController.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 0)
        photoPickerController.view.addConstraint(heightConstraintPhotoPackerView!)
        self.view.addConstraint(NSLayoutConstraint(item: photoPickerController.view, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: photoPickerController.view, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: photoPickerController.view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -44.0))
    }
    
    // MARK: 监听方法
    
    // 左侧导航按钮监听
    @objc private func leftBarButtonClick() {
        QL2("")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 右侧导航按钮监听 - 发送微博
    @objc private func rightBarButtonClick() {
        
        let text = textView.replaceEmoticonAttributedString()
        let image = photoPickerController.images.last
        
        NetWorkTools.shareIntance.sendStatus(text, image: image) { (data, error) in
            if error != nil {
                QL3("发送微博失败")
                return
            }
            
            if data != nil {
                self.dismissViewControllerAnimated(true, completion: nil)

            }
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
    
    // MARK: 懒加载
    private lazy var textView: JYTextView = {
        let tv = JYTextView(frame: CGRectZero, textContainer: nil)
        tv.font = UIFont.systemFontOfSize(14)
        return tv
    }()
    
    private lazy var toolbar: ComposeToolbar = {
        let tb = NSBundle.mainBundle().loadNibNamed("ComposeToolbar", owner: nil, options: nil).last as! ComposeToolbar
        tb.composeToolbarDelegate = self
        return tb
        
    }()
    
    private lazy var keyboardEmoticomViewController: JYKeyboardEmoticonViewController = JYKeyboardEmoticonViewController {
        [unowned self] (emoticon) in
        self.textView.insertEmoticon(emoticon)
        // 当插入表情后，手动调用textView的文字发生改变的函数
        self.textViewDidChange(self.textView)
        
    }
    
    private lazy var photoPickerController: JYPhotoPickerController = JYPhotoPickerController(collectionViewLayout: JYPhotoPickerViewLayout())
    
    /// 数字提醒
    private lazy var tipLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .Center        
        return lb
    }()
    
}

// MARK: - UITextViewDelegate

extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        // 1.判断是发送按钮是否可以点击和文本提示是否关闭
        self.navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        self.textView.placeholderLabel.hidden = textView.hasText()
        
        // 2.将剩余字数显示到提示label
        // 2.1 获取当前输入了多少字数
        let currentCount = self.textView.replaceEmoticonAttributedString().characters.count
        // 2.2 计算用户还可以输入多少字数
        let leftCount = maxCount - currentCount
        // 2.2 在tiplabel中显示剩余个数
        tipLabel.text = "\(leftCount)"
        
        // 3.如果超过字数不允许发送
        self.navigationItem.rightBarButtonItem?.enabled = leftCount >= 0
        
        // 4.设置提示文本颜色
        tipLabel.textColor = leftCount >= 0 ? UIColor.lightGrayColor() : UIColor.redColor()
    }
}

// MARK: - ComposeToolbarDelegate

extension ComposeViewController: ComposeToolbarDelegate {
    func toolbarDidClick(item: UIBarButtonItem) {
        heightConstraintPhotoPackerView?.constant = 500
        UIView.animateWithDuration(0.4) { 
            self.photoPickerController.view.layoutIfNeeded()
        }
    }
}