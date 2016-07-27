//
//  TitleButton.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/6.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 对换标题和图片的位置
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = titleLabel!.bounds.width
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        // ?? 表示如果title有值，就调用title，没有值就取？？后面的" "
        super.setTitle((title ?? "") + "  ", forState: state)
    }
    
    // MARK - 内部控制方法
    private func setupUI() {
        
        setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        sizeToFit()
    }
}
