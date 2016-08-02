//
//  JYKeyboardPackage.swift
//  表情键盘
//
//  Created by Jinyong on 16/7/27.
//  Copyright © 2016年 Jinyong. All rights reserved.
//

import UIKit

class JYKeyboardPackage: NSObject {

    /// 当前表情目录名
    var emoticon_id: String
    
    // 当前组对应的表情组名
    var id: String?
    
    /// 当前组对应的表情名
    var group_name_cn: String?
    
    /// 当前组对应的表情组
    var emoticons: [JYKeyboardEmoticon]?
    
    init(id: String) {
        self.emoticon_id = id
    }
    
    /// 加载所以表情组数据
    class func loadEmoticonPackeges() -> [JYKeyboardPackage] {
        
        var models = [JYKeyboardPackage]()
        // 0.手动添加最近组
        let packge = JYKeyboardPackage(id: "")
        packge.appendEmptyEmoticons()
        models.append(packge)

        // 1.加载emoticons.plist文件
        let path = NSBundle.mainBundle().pathForResource("emoticons", ofType: "plist", inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        
        // 2.提出表情组数组
        let packages = dict["packages"] as! [[String: AnyObject]]
        
        // 3.遍历每个组进行封装
        for packageDic in packages {
            // 3.1.创建当前表情组模型
            let packege = JYKeyboardPackage(id: packageDic["id"] as! String)
           
            // 3.2.加载当前组所有表情
            packege.loadEmoticons()
            
            // 3.3补全21个表情
            packege.appendEmptyEmoticons()
            
            // 3.4.将当前组模型添加到数组中
            models.append(packege)
        }
        
        return models
    }
    
    
    /// 将当前点击的添加到最近组中
    func addFavoriteEmoticon(emoticon: JYKeyboardEmoticon) {
        
        // 1.判断不包含当前点击表情
        if !emoticons!.contains(emoticon) {
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        
        // 2.对表情进行排序（点击量多的靠前）
        let array = emoticons?.sort({ (s1, s2) -> Bool in
            return s1.count > s2.count
        })
        emoticons = array
        
        // 3.添加最后一个删除按钮
        emoticons?.removeLast()
        emoticons?.append(JYKeyboardEmoticon(isRemoveButton: true))
    }
    
    /// 加载当前组所有表情
    private func loadEmoticons() {
        // 1.加载当前组的info.plist
        // 1.1.获取当前组对应的路径
        let path = NSBundle.mainBundle().pathForResource(self.emoticon_id, ofType: nil, inDirectory: "Emoticons.bundle")!
        let filePath = (path as NSString).stringByAppendingPathComponent("info.plist")
        
        // 1.2.通过路径加载plist
        let dict = NSDictionary(contentsOfFile: filePath)!
        
        // 2.从加载进来的字典中取出当前组数据
        
        // 2.1取出当前组表情组名
        id = dict["id"] as? String
        
        // 2.1取出当前组表情名
        group_name_cn = dict["group_name_cn"] as? String
    
        // 2.2取出当前组所有表情
        let array = dict["emoticons"] as! [[String: AnyObject]]
        
        // 3.表情转模型
        var models = [JYKeyboardEmoticon]()
        
        var index = 0
        for emoticonDict in array {
            if index == 20 {
                models.append(JYKeyboardEmoticon(isRemoveButton: true))
                // 每一页到21后重置
                index = 0
            }
            
            let emoticon = JYKeyboardEmoticon(dict: emoticonDict, emoticon_id: emoticon_id)
            emoticon.emoticon_id = emoticon_id
            models.append(emoticon)
            index += 1
        }
        emoticons = models
    }
    
    /// 每页21个表情，不足21个表情的进行补齐
    private func appendEmptyEmoticons() {
        
        // 0.首先判断当前表情组是否为空
        if emoticons == nil { // 如果为空，则表示是最近组，我们手动创建一个空表情组
            emoticons = [JYKeyboardEmoticon(isRemoveButton: false)]
        }
        
        // 1.取出不能被21整除的个数
        let number = emoticons!.count % 21
        
        // 2.补全空白的个数
        for _ in number..<20 {
            emoticons?.append(JYKeyboardEmoticon(isRemoveButton: false))
        }
        
        // 3.最后一个表情为删除按钮
        emoticons?.append(JYKeyboardEmoticon(isRemoveButton: true))
    }
}


// MARK: - JYKeyboardPackage 扩展
extension JYKeyboardPackage {
    /// 创建富文本，用于显示图文混排
    class func createAttributedString(text: String, font: UIFont) -> NSMutableAttributedString {
        let mAttributedString = NSMutableAttributedString(string: text)
        
        // 1.定义正则表达式，通过正则表达式规则进行匹配
        let pattern = "\\[.*?\\]"
        let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
        let results = regex.matchesInString(text, options: NSMatchingOptions(rawValue:0), range: NSRange(location: 0, length: text.characters.count))
        
        // 2.遍历匹配结果，进行图文混排
        var count = results.count - 1
  
        while count >= 0 {
            let result = results[count]
            // 2.1 获取匹配的表情的字符串名称
            let chs = (text as NSString).substringWithRange(result.range)
            
            // 2.2 通过表情的字符串名称再模型数据中查找对应的表情图片路径
            let pngPath = findEmoticonPngPath(chs)
            
            guard let emoticonPngPath = pngPath else {
                count -= 1
                continue
            }
            
            // 2.3 如果获取到表情图片路径，进行图文混排
            let attachment = NSTextAttachment()
            attachment.image = UIImage(contentsOfFile: emoticonPngPath)
            attachment.bounds = CGRect(x: 0, y: -5, width: font.lineHeight, height: font.lineHeight)
            let emoticonString = NSAttributedString(attachment: attachment)
            
            // 2.4 将mutableStringArr中的chs替换成表情
            mAttributedString.replaceCharactersInRange(result.range, withAttributedString: emoticonString)
            
            count -= 1
        }
        return mAttributedString
    }
    
    /// 查找对应的表情图片路径
    class func findEmoticonPngPath(emoticonChs: String) -> String? {
        // 1.加载表情模型数组
        let packeges = JYKeyboardPackage.loadEmoticonPackeges()
       
        // 2.遍历表情模型数组，查找匹配的chs
        for packege in packeges {
            guard let emoticons = packege.emoticons else {
                continue
            }
            
            // 2.1 如果表情数组存在，遍历表情数据
            var pngPath: String?

            for emoticon in emoticons {
                guard let chs = emoticon.chs else {
                    continue
                }
                
                // 2.2 如果表情字符串存在，进行匹配。
                if emoticonChs == chs {
                    pngPath = emoticon.pngPath
                    break // 终止当前循环
                }
            }
            
            // 2.3 匹配到了，就不需要再继续遍历下一个表情包，直接退出循环
            if pngPath != nil {
                return pngPath
            }
        }
        
        // 如果遍历了所以的表情包依然没有匹配值，则直接返回nil
        return nil
    }
}


// MARK: - 表情模型
class JYKeyboardEmoticon: NSObject {
    /// 表情目录名
    var emoticon_id: String?
    
    /// 表情编码
    var code: String?{
        didSet {
            // 1.创建扫描器
            let scanner = NSScanner(string: code!)
            
            // 2.扫描成16进制
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            // 3.根据扫描出的16进制数创建一个字符串
            emojiString = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    /// 表情对应的字符串
    var chs: String?
    
    /// 表情对应的图片
    var png: String? {
        didSet {
            let path = NSBundle.mainBundle().pathForResource(emoticon_id, ofType: nil, inDirectory: "Emoticons.bundle")!
            pngPath = (path as NSString).stringByAppendingPathComponent(png!)
        }
    }
    
    /// 转码后的Emoji表情字符串
    var emojiString: String?
    
    /// 表情路径
    var pngPath: String?
    
    /// 记录当前表情是否删除按钮,默认为不是删除按钮：false
    var isRemoveButton = false
    
    /// 记录记录当前表情的点击次数,默认0次
    var count: Int = 0

    init(dict: [String: AnyObject], emoticon_id: String?) {
        super.init()
        self.emoticon_id = emoticon_id
        self.setValuesForKeysWithDictionary(dict)
    }
    
    init(isRemoveButton: Bool) {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
