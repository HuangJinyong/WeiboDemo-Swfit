//
//  JYKeyboardEmoticonCollectionViewCell.swift
//  表情键盘
//
//  Created by Jinyong on 16/7/28.
//  Copyright © 2016年 Jinyong. All rights reserved.
//

import UIKit

class JYKeyboardEmoticonCollectionViewCell: UICollectionViewCell {
    
    var emoticon: JYKeyboardEmoticon? {
        didSet {
            emoticonBtn.setImage(nil, forState: .Normal)
            
            // 1.显示emoji表情
            emoticonBtn.setTitle(emoticon?.emojiString ?? "", forState: .Normal)

            // 2.显示图片表情
            if emoticon?.chs != nil {
                emoticonBtn.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: .Normal)
            }
            
            // 3.设置删除按钮
            if emoticon!.isRemoveButton {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: .Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - 内部控制方法
    private func setupUI() {
        // 1.添加子控件
        self.addSubview(emoticonBtn)
        
        // 2.布局子控件
        emoticonBtn.frame = CGRectInset(self.bounds, 4, 4)
    }
    
    
    // MARK: - 懒加载
    private lazy var emoticonBtn: UIButton = {
        let btn = UIButton()
        btn.userInteractionEnabled = false
        btn.titleLabel?.font = UIFont.systemFontOfSize(30)
        return btn
    }()
}
