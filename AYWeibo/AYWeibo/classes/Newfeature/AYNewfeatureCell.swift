//
//  AYNewfeatureCell.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/22.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYNewfeatureCell: UICollectionViewCell {
    /// 背景图片
    private lazy var bgImageView: UIImageView = UIImageView()
    
    /// itemCell索引： 对外暴露，根据索引设置不同cell的背景图片
    var index: Int = 0 {
        didSet {
            // 1. 生成图片名称
            let name = "new_feature_\(index + 1)"
            // 2. 设置图片
            bgImageView.image = UIImage(named: name)
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
        // 1. 添加子视图
        contentView.addSubview(bgImageView)
        
        // 2. 添加约束
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[bgImageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView": bgImageView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[bgImageView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["bgImageView": bgImageView]))
    }
    
}
