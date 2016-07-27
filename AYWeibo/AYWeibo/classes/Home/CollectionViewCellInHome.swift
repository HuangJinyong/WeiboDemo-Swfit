//
//  CollectionViewCellInHome.swift
//  AYWeibo
//
//  Created by Kinyong on 16/6/30.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewCellInHome: UICollectionViewCell {
    /// 显示微博图片
    lazy var picImageView: UIImageView = UIImageView()
    
    // 显示gif图片
    private lazy var gifImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "gif")
        imageView.sizeToFit()
        return imageView
    }()
    
    var url: NSURL? {
        didSet {
            // 1.设置微博图片
            picImageView.sd_setImageWithURL(url)
            
            // 2.控制gif图标是否显示或隐藏
            if let flag = url?.absoluteString.lowercaseString.hasSuffix("gif") { // 判断后缀是否相等
                gifImageView.hidden = !flag
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 微博图片
        picImageView.contentMode = .ScaleAspectFill
        picImageView.clipsToBounds = true
        contentView.addSubview(picImageView)
        
        // git图片
        picImageView.addSubview(gifImageView)
    }
    
    private func setupConstraints() {
        picImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[picImageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["picImageView": picImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[picImageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["picImageView": picImageView]))
        
        picImageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[gifImageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["gifImageView": gifImageView]))
        picImageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[gifImageView]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: ["gifImageView": gifImageView]))
    
    }
}
