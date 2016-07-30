//
//  JYPhotoPickerViewCell.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/30.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
typealias sendValueClosure = (item: UIButton) -> Void


class JYPhotoPickerViewCell: UICollectionViewCell {
    
    /// 接受外面传入的选择照片，用于显示在cell上
    var image: UIImage? {
        didSet {
            
            // 判断图片是否为空
            if image == nil { // 如果为空
                removeBtn.hidden = true
                imageBtn.setBackgroundImage(UIImage(named: "compose_pic_add"), forState: .Normal)
                imageBtn.setBackgroundImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Highlighted)
                
            } else {
                removeBtn.hidden = false
                imageBtn.setBackgroundImage(image, forState: .Normal)
            }
        }
    }
    
    /// 删除按钮
    lazy var removeBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(self.removeBtnClick), forControlEvents: .TouchUpInside)
        btn.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        btn.sizeToFit()
        return btn
    }()
    
    /// 图片按钮
    lazy var imageBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(self.btnClick), forControlEvents: .TouchUpInside)
        btn.sizeToFit()
        btn.contentMode = .ScaleAspectFill
        return btn
    }()
    
    /// 点击按钮回调闭包通知
    var btnClickcallBack: sendValueClosure?

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 配置控件
        setupUI()
        // 布局约束
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // 配置控件
        setupUI()
        // 布局约束
        setupConstraints()
    }
    
    // MARK: 内部控制方法
    private func setupUI() {
        // 添加图片按钮
        self.addSubview(imageBtn)
        
        // 添加删除按钮
        imageBtn.addSubview(removeBtn)
    }
    
    private func setupConstraints() {
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        imageBtn.translatesAutoresizingMaskIntoConstraints = false
        
        var constraintsImageBtn = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[imageBtn]-0-|", options: .DirectionMask, metrics: nil, views: ["imageBtn": imageBtn])
        constraintsImageBtn += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[imageBtn]-0-|", options: .DirectionMask, metrics: nil, views: ["imageBtn": imageBtn])
        self.addConstraints(constraintsImageBtn)
        
        var constraintsRemoveBtn = NSLayoutConstraint.constraintsWithVisualFormat("H:[removeBtn]-0-|", options: .DirectionMask, metrics: nil, views: ["removeBtn": removeBtn])
        constraintsRemoveBtn += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[removeBtn]", options: .DirectionMask, metrics: nil, views: ["removeBtn": removeBtn])
        imageBtn.addConstraints(constraintsRemoveBtn)
        
    }
    
    // MARK: 监听方法
    @objc private func btnClick(sender: UIButton) {
        btnClickcallBack?(item: sender)
    }
    
    @objc private func removeBtnClick() {
        
    }
}
