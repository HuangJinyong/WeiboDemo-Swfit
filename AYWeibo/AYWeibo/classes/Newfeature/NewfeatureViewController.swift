//
//  NewfeatureViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/22.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewfeatureViewController: UICollectionViewController {
    /// 新特性页面的个数
    private var maxCount = 4
    
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let btn = UIButton(imageName: "new_feature_button", backgroundImageName: nil)
        btn.hidden = true
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.设置背景色
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        // 2.注册cell标示符
        self.collectionView!.registerClass(AYNewfeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // 3.配置子控件
        setupSubView()
    }
    
    // MARK: - 内部控制方法
    
    @objc private func startButtonClick() {
        QL2("")
        // 发送通知进行根控制器切换：首页控制器
        NSNotificationCenter.defaultCenter().postNotificationName(AYSwitchRootViewController, object: true)
    }
    
    private func startButtonAnimation() {
        // 1.动画开始前禁止交互
        startButton.userInteractionEnabled = false
        // 2.动画开始前的缩放大小
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        // 3.显示开始按钮
        startButton.hidden = false
        
        // 4.执行动画
        UIView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: .TransitionNone, animations: {
            self.startButton.transform = CGAffineTransformIdentity
        }) { (_) in
            // 动画结束后允许交互
            self.startButton.userInteractionEnabled = true
        }
    }
    
    private func setupSubView() {
        // 1.添加子控件
        startButton.addTarget(self, action: #selector(self.startButtonClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton)
        
        // 2.设置约束
        setupConstraints()
    }
    
    private func setupConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[startButton]-|", options: .AlignAllCenterX, metrics: nil, views: ["startButton": startButton]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[translates]-120-|", options: .AlignAllBottom, metrics: nil, views: ["translates": startButton]))
    }
    
    // MARK: - delegate

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AYNewfeatureCell
        cell.contentView.backgroundColor = indexPath.item % 2 != 0 ? UIColor.blueColor() : UIColor.redColor()
        cell.index = indexPath.item
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 注意：传入的cell和indexPath都是上一页显示的cell和item，而不是当前显示的cell和item
        // 1.手动获取当前显示的cell对应的indexPath
        guard let index = collectionView.indexPathsForVisibleItems().last else{
            QL2("获取不到indexPath")
            return
        }
        
        // 2.判断当前是否最后一个item，并且开始按钮是隐藏的状态下，开始执行动画
        if index.item == (maxCount - 1) && startButton.hidden {
            startButtonAnimation()
        }
    }
}
