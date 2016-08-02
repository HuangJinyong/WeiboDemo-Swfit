//
//  UIself+Extension.swift
//  表情键盘
//
//  Created by Jinyong on 16/7/26.
//  Copyright © 2016年 Jinyong. All rights reserved.
//

import UIKit

extension UITextView {
    /// 插入键盘表情
    func insertEmoticon(emoticon: JYKeyboardEmoticon) {
        // 1.emoji表情
        if let emojiString = emoticon.emojiString {
            let range = self.selectedTextRange!
            self.replaceRange(range, withText: emojiString)
            return
        }
        
        // 2.新浪的表情
        if let pngPath = emoticon.pngPath {
            // 2.1.通过textView中的文字创建富文本属性字符串
            let mAttrStr = NSMutableAttributedString(attributedString: self.attributedText)
            
            // 2.2.创建图片的富文本字符串
            let attach = JYKeyboardTextAttachment()
            let fontHeight = self.font!.lineHeight
            attach.emoticonChs = emoticon.chs
            attach.image = UIImage(contentsOfFile: pngPath)
            attach.bounds = CGRectMake(0, -5, fontHeight, fontHeight)
            let imageAttrStr = NSAttributedString(attachment: attach)
            
            // 2.3.获取光标所在的位置
            let range = self.selectedRange
            
            // 2.4.将光标所在位置的字符串进行替换
            mAttrStr.replaceCharactersInRange(range, withAttributedString: imageAttrStr)
            
            // 2.5.显示富文本
            self.attributedText = mAttrStr
            
            // 2.6.定位光标位置
            self.selectedRange = NSRange(location: range.location + 1, length: 0)
            
            // 2.7.重新设置self字体大小
            self.font = UIFont.systemFontOfSize(18.0)
            return
        }
        
        // 3.删除最近一个文字或者表情
        if emoticon.isRemoveButton {
            self.deleteBackward()
        }
    }
    
    /// 富文本转义成普通文本，用于上传到服务器
    func replaceEmoticonAttributedString() -> String {
        // 1.获取文本的range
        let range = NSRange(location: 0, length: self.attributedText.length)
        
        // 2.定义一个空字符串，用于拼接文本内容
        var textString = ""
        
        // 3.通过
        self.attributedText.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) in
            
            if let attachment = dict["NSAttachment"] as? JYKeyboardTextAttachment {
                textString += attachment.emoticonChs!
            } else {
                textString += (self.attributedText.string as NSString).substringWithRange(range)
            }
        }
        return textString
    }
}