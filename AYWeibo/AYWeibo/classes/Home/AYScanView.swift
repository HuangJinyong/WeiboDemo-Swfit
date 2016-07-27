//
//  AYScanView.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYScanView: UIView {

    private var borderImgView: UIImageView!
    private var scaningImgView: UIImageView!
    private var topConstraintScan: NSLayoutConstraint! // 扫描视图的顶部约束
    private var heightConstraintBorder: NSLayoutConstraint! // 边框图片的高度约束
    private var heightConstraintScan: NSLayoutConstraint! // 扫描视图的高度约束
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 1.添加子视图
        setupSubViews()
        
        // 2.布局约束
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        heightConstraintBorder.constant = self.frame.height
        heightConstraintScan.constant = self.frame.height
    }
    
    // MARK: - 内部实现方法
    
    private func setupSubViews() {
        // 1.添加边框图片
        borderImgView = UIImageView()
        borderImgView.image = UIImage(named: "qrcode_border")
        addSubview(borderImgView)
        
        // 2.添加扫描视图
        scaningImgView = UIImageView()
        scaningImgView.image = UIImage(named: "qrcode_scanline_qrcode")
        addSubview(scaningImgView)
    }
    
    private func setupConstraints() {
        borderImgView.translatesAutoresizingMaskIntoConstraints = false
        scaningImgView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加边框图片约束
        let widthConstraintBorder = NSLayoutConstraint(item: borderImgView,
                                                       attribute: .Width,
                                                       relatedBy: .Equal,
                                                       toItem: nil,
                                                       attribute: .NotAnAttribute,
                                                       multiplier: 0.0,
                                                       constant: self.frame.width)
        
        heightConstraintBorder = NSLayoutConstraint(item: borderImgView,
                                                        attribute: .Height,
                                                        relatedBy: .Equal,
                                                        toItem: nil,
                                                        attribute: .NotAnAttribute,
                                                        multiplier: 0.0,
                                                        constant: self.frame.width)
    
        let topConstraintBorder = NSLayoutConstraint(item: borderImgView,
                                                     attribute: .Top,
                                                     relatedBy: .Equal,
                                                     toItem: self,
                                                     attribute: .Top,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
        
        let leadingConstraintBorder = NSLayoutConstraint(item: borderImgView,
                                                         attribute: .Leading,
                                                         relatedBy: .Equal,
                                                         toItem: self,
                                                         attribute: .Leading,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
        
        borderImgView.addConstraints([widthConstraintBorder, heightConstraintBorder])
        addConstraints([topConstraintBorder, leadingConstraintBorder])
        
        // 添加扫描视图约束
        let widthConstraintScan = NSLayoutConstraint(item: scaningImgView,
                                                       attribute: .Width,
                                                       relatedBy: .Equal,
                                                       toItem: nil,
                                                       attribute: .NotAnAttribute,
                                                       multiplier: 0.0,
                                                       constant: self.frame.width)
        
        heightConstraintScan = NSLayoutConstraint(item: scaningImgView,
                                                        attribute: .Height,
                                                        relatedBy: .Equal,
                                                        toItem: nil,
                                                        attribute: .NotAnAttribute,
                                                        multiplier: 0.0,
                                                        constant: self.frame.width)
        
        topConstraintScan = NSLayoutConstraint(item: scaningImgView,
                                                     attribute: .Top,
                                                     relatedBy: .Equal,
                                                     toItem: self,
                                                     attribute: .Top,
                                                     multiplier: 1.0,
                                                     constant: 0.0)
        
        let leadingConstraintScan = NSLayoutConstraint(item: scaningImgView,
                                                         attribute: .Leading,
                                                         relatedBy: .Equal,
                                                         toItem: self,
                                                         attribute: .Leading,
                                                         multiplier: 1.0,
                                                         constant: 0.0)
        
        scaningImgView.addConstraints([widthConstraintScan, heightConstraintScan])
        self.addConstraints([topConstraintScan, leadingConstraintScan])

    }
    
    // MARK: - 外部实现方法
    
    /// 扫描动画
    func animateWithScan() {
        // 0. 每次动画开始初始化位置
        topConstraintScan.constant = 0.0
        
        // 1.动画开始前的顶部约束位置
        topConstraintScan.constant = -self.frame.height
        
        self.layoutIfNeeded()
        
        // 2. 执行动画
        UIView.animateWithDuration(2.0) { 
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.topConstraintScan.constant = self.frame.height
            self.layoutIfNeeded()
        }
    }
}
