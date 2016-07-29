//
//  JYKeyboardEmoticonViewController.swift
//  表情键盘
//
//  Created by Jinyong on 16/7/27.
//  Copyright © 2016年 Jinyong. All rights reserved.
//

import UIKit

class JYKeyboardEmoticonViewController: UIViewController {
    // MARK: - 属性
    private var packages = JYKeyboardPackage.loadEmoticonPackeges()
    
    
    private var emoticonCallBack: (emoticon: JYKeyboardEmoticon) -> ()
    
    init(callBack: (emoticon: JYKeyboardEmoticon) -> ()) {
        self.emoticonCallBack = callBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 系统调用方法
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.配置子控件
        setupUI()
        
        // 2.添加约束
        setupConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        emoticonCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 1), atScrollPosition: .Left, animated: false)
    
    }
    
    // MARK: - 监听方法
    
    @objc func barButtonItemClick(sender: UIBarButtonItem) {
        let indexPath = NSIndexPath(forItem: 0, inSection: sender.tag)
        self.emoticonCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }
    
    // MARK: - 内部控制方法
    
    private func setupUI() {
        self.view.addSubview(emoticonCollectionView)
        self.view.addSubview(emoticonReplaceToolbar)
    }
    
    private func setupConstraints() {
        emoticonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emoticonReplaceToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["emoticonCollectionView": emoticonCollectionView, "emoticonReplaceToolbar": emoticonReplaceToolbar]
        var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[emoticonReplaceToolbar]-0-|", options: .DirectionMask, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[emoticonCollectionView]-0-|", options: .DirectionMask, metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[emoticonCollectionView]-0-[emoticonReplaceToolbar(44)]-0-|", options: .DirectionMask, metrics: nil, views: views)
        
        self.view.addConstraints(constraints)
    }
    
    // MARK: - 懒加载
    /// 表情切换工具栏
    private lazy var emoticonReplaceToolbar: UIToolbar = {
        let tb = UIToolbar()
        let titles = ["最近", "默认", "Emoji", "浪小花"]
        var index = 0
        var items = [UIBarButtonItem]()
        
        items.append(UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil))
        
        for i in 0..<titles.count {
            let item = UIBarButtonItem(title: titles[i], style: .Plain, target: self, action: #selector(self.barButtonItemClick(_:)))
            let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
            item.tag = index
            index += 1
            items.append(item)
            items.append(flexibleItem)
        }
        
        items.removeLast()
        items.append(UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil))
        tb.tintColor = UIColor.lightGrayColor()
        tb.items = items
        
        return tb
    }()
    
    /// 表情键盘
    private lazy var emoticonCollectionView: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: JYUIEmoticonCollectionViewLayout())
        
        clv.registerClass(JYKeyboardEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: "emoticonCollectionViewCellID")
        clv.backgroundColor = UIColor.clearColor()
        clv.dataSource = self
        clv.delegate = self
        
        return clv
    }()
    
}


// MARK: - UICollectionViewDataSource

extension JYKeyboardEmoticonViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emoticonCollectionViewCellID", forIndexPath: indexPath) as! JYKeyboardEmoticonCollectionViewCell
        let packge = packages[indexPath.section]
        
        cell.emoticon = packge.emoticons![indexPath.item]
        
        return cell
    }
}

extension JYKeyboardEmoticonViewController: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1.取出点击的表情
        let package = packages[indexPath.section]
        let emoticon = package.emoticons![indexPath.item]
        emoticon.count += 1
        
        // 2.如果不是删除按钮
        if !emoticon.isRemoveButton && packages.first != packages[indexPath.section] {
            // 将当前点击的表情放入最近组中
            packages[0].addFavoriteEmoticon(emoticon)
        }
        
        // 3.将当前点击的表情传递给外面的控制器
        emoticonCallBack(emoticon: emoticon)
    }
    
}


// MARK: - UICollectionViewFlowLayout

class JYUIEmoticonCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        let width = UIScreen.mainScreen().bounds.width / 7
        let height = collectionView!.bounds.height / 3
        
        self.itemSize = CGSize(width: width, height: height)
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .Horizontal
        self.collectionView?.bounces = false
        self.collectionView?.pagingEnabled = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
}