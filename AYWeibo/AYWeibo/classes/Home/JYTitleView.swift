//
//  JYTitleView.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/23.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class JYTitleView: UIView {

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
        self.addSubview(titleLabel)
        self.addSubview(subTilteLable)
        
        // 2.布局子控件
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTilteLable.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[titleLabel]", options: .AlignAllTop, metrics: nil, views: ["titleLabel": titleLabel]))
        
        
        self.addConstraint(NSLayoutConstraint(item: subTilteLable, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[subTilteLable]-2-|", options: .AlignAllBottom, metrics: nil, views: ["subTilteLable": subTilteLable]))
    }
    
    
    // MARK: - 懒加载
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "发微博"
        lb.font = UIFont.systemFontOfSize(16)
        return lb
    }()
    
    private lazy var subTilteLable: UILabel = {
        let lb = UILabel()
        lb.text = "金勇"
        lb.textColor = UIColor.lightGrayColor()
        lb.font = UIFont.systemFontOfSize(14)
        return lb
    }()
    
}
