//
//  ComposeToolbar.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/24.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class ComposeToolbar: UIToolbar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 接受外界传入的textView
    var textView: UITextView?
    
    /// 接受键盘视图
    var keyboardView: UIView?
    
    // MARK: - 内部控制方法
    
    func setupUI() {
        
    }

    // 表情按钮
    @IBAction func emotionBtnClick(sender: AnyObject) {
        /*
         通过观察发现，如果是系统默认的键盘inputView = nil
         如果不是系统自带的键盘，那么inputView != nil
         注意点：要切换键盘，必须先关闭键盘，切换之后再打开
        */
    
        assert(textView != nil, "实现表情按钮textView不能为nil，需要外界传入textview")
        
        // 1.先关闭键盘
        textView?.resignFirstResponder()
        
        // 2.判断inputView是否为nil，进行切换
        if textView?.inputView != nil {
            // 切换为系统键盘
            textView?.inputView = nil
        } else {
            // 切换为自定义键盘
            textView?.inputView = keyboardView
        }
        // 3.切换后打开键盘
        textView?.becomeFirstResponder()
    }
}
