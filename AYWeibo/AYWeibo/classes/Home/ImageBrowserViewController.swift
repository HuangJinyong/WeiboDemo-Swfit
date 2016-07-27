//
//  ImageBrowserViewController.swift
//  AYWeibo
//
//  Created by Kinyong on 16/7/9.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class ImageBrowserViewController: UIViewController {
    /// 大图图片地址
    var bmiddle_urls: [NSURL]
    /// 缩略图片地址
    var thumbnail_urls: [NSURL]
    /// 索引
    var indexPath: NSIndexPath
    
    // MARK: - 懒加载
    
    private lazy var collectionview: UICollectionView = {
        let clv = UICollectionView(frame: CGRectZero, collectionViewLayout: ImageBrowserLayout())
        clv.backgroundColor = UIColor.clearColor()
        clv.dataSource = self
        clv.registerClass(ImageBrowserCell.self, forCellWithReuseIdentifier: "ImageBrowserViewController")
        
        return clv
    }()
    
    /// 关闭按钮
    private lazy var closeBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("关闭", forState: .Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(self.closeBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    /// 保存按钮
    private lazy var saveBtn: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("保存", forState: .Normal)
        btn.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        btn.addTarget(self, action: #selector(self.saveBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    // MARK: - 系统内部方法
    
    init(bmiddle_urls: [NSURL], thumbnail_urls: [NSURL], indexPath: NSIndexPath ) {
        self.bmiddle_urls = bmiddle_urls
        self.indexPath = indexPath
        self.thumbnail_urls = thumbnail_urls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // 初始化UI
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionview.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 内部控制方法
    
    @objc private func closeBtnClick() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @objc private func saveBtnClick() {
        // 1.获取当前显示图片的索引
        let indexPath = collectionview.indexPathsForVisibleItems().last!
        // 2.获取当前显示的cell
        let cell = collectionview.cellForItemAtIndexPath(indexPath) as! ImageBrowserCell
        // 3.获取当前显示的图片
        let image = cell.imageView.image!
        // 4.保存图片,图片保存成功后，会调用第3参数的方法
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 保存图片后调用的方法
    func image(image: UIImage, didFinishSavingWithError: NSError, contextInfo: AnyObject) {
        QL2("保存成功")
    }
    
    private func setupUI() {
        // 1.添加子控件
        self.view.addSubview(collectionview)
        self.view.addSubview(closeBtn)
        self.view.addSubview(saveBtn)
        
        // 2.布局子控件
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[collectionview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionview": collectionview]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[collectionview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["collectionview": collectionview]))
        
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[closeBtn(100)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeBtn": closeBtn]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeBtn(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeBtn": closeBtn]))
        
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[saveBtn(100)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["saveBtn": saveBtn]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveBtn(50)]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["saveBtn": saveBtn]))
    }
}

// MARK: - collectionViewDataSource
extension ImageBrowserViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bmiddle_urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageBrowserViewController", forIndexPath: indexPath) as! ImageBrowserCell
        cell.thumbnail_url = thumbnail_urls[indexPath.item]
        cell.thumbnailImageView.sd_setImageWithURL(thumbnail_urls[indexPath.item])
        cell.bmiddle_url = bmiddle_urls[indexPath.item]
        
        return cell
    }
}

// MARK: - collectionLayout
class ImageBrowserLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        self.itemSize = UIScreen.mainScreen().bounds.size
        self.minimumLineSpacing = 0
        self.minimumInteritemSpacing = 0
        self.scrollDirection = .Horizontal
        self.collectionView?.bounces = false
        self.collectionView?.pagingEnabled = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
}
