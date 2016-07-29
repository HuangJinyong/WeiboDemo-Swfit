//
//  JYTextView.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/24.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class JYTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.resignFirstResponder()
    }
    
    // MARK: - 内部控制方法
    private func setupUI() {
        // 1.添加子控件
        self.addSubview(placeholderLabel)
        
        // 2.布局子控件
        setupConstraints()
        
        // 3.订阅通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textChange), name: UITextViewTextDidChangeNotification, object: self)
    }
    
    private func setupConstraints() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-4-[placeholderLabel]", options: .AlignAllLeft, metrics: nil, views: ["placeholderLabel": placeholderLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[placeholderLabel]", options: .AlignAllTop, metrics: nil, views: ["placeholderLabel": placeholderLabel]))
    }
    
    // 监听文本视图内容改变方法
    @objc private func textChange() {
        placeholderLabel.hidden = self.hasText()
    }
    
    // MARK: - 懒加载
    lazy var placeholderLabel: UILabel = {
        let lb = UILabel()
        lb.text = "分享新鲜事..."
        lb.textColor = UIColor.lightGrayColor()
        lb.font = UIFont.systemFontOfSize(14)
        return lb
    }()
    
}
