//
//  CollectionViewInHomeCell.swift
//  AYWeibo
//
//  Created by Kinyong on 16/6/30.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class CollectionViewInHome: UICollectionView {

       
    /// 配图地址
    var thumbnail_urls: [NSURL]? {
        didSet {
            self.reloadData()
        }
    }
    
    /// 大图图片地址
    var bmiddle_urls: [NSURL]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerClass(CollectionViewCellInHome.self, forCellWithReuseIdentifier:"CollectionViewCellInHome")
        self.delegate = self
        self.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewInHome: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 如果有返回count，如果没有返回0即没有显示item
        return thumbnail_urls?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCellInHome", forIndexPath: indexPath) as! CollectionViewCellInHome
        
        cell.url = thumbnail_urls![indexPath.item]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CollectionViewInHome: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 当点击首页cell的缩略图时候，通知首页控制器进行modle显示图片浏览
        NSNotificationCenter.defaultCenter().postNotificationName(KYHomeCellShowImageView, object: self, userInfo: ["bmiddle_urls": bmiddle_urls!, "thumbnail_urls":thumbnail_urls!, "indexPath": indexPath])
    }
}

// MARK: - JYBrowserPresentationDelegate

extension CollectionViewInHome: JYBrowserPresentationDelegate {
    
    // 用于创建一个和点击图片一模一样的UIImageView
    func browserPresentationWillShowImage(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> UIImageView {
        
        // 1.创建一个新的UIImageView
        let iv = UIImageView()
        // 2.设置UIimageview的图片为点击图片
        let cell = self.cellForItemAtIndexPath(indexPath) as! CollectionViewCellInHome
        iv.image = cell.picImageView.image
        iv.contentMode = .ScaleAspectFill
        iv.clipsToBounds = true
        iv.sizeToFit()
        // 3.返回图片
        return iv
    }
    
    // 用于获取点击图片相对于windows的frame
    func browserPresentationWillFromFrame(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> CGRect {
        // 1.拿到被点击的cell
        let cell = self.cellForItemAtIndexPath(indexPath) as! CollectionViewCellInHome
        // 2.将被点击的cell的坐标系从collectionVeiwcell转换到keywindow
        let frame = self.convertRect(cell.frame, toView: UIApplication.sharedApplication().keyWindow)
        
        return frame
    }
    
    // 用于获取点击图片最终的frame
    func browserPresentationWillToFrame(browserPresenationController: JYBrowserPresentationController, indexPath: NSIndexPath) -> CGRect {
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        var offsetY: CGFloat = 0
        
        // 1.拿到当前被点击的cell
        let cell = self.cellForItemAtIndexPath(indexPath) as! CollectionViewCellInHome
        // 2.拿到被点击的图片
        let image = cell.picImageView.image!
        // 3.计算当前图片的宽高比
        let scale = image.size.height / image.size.width
        // 4.利用宽高比成语屏幕宽度，等比缩放图片
        let imageHeight = scale * width
        // 5.判断当前是长图还是短图
        if imageHeight < height {
            // 短图
            offsetY = (height - imageHeight) * 0.5
        }
        // 6.返回最终的frame
        return CGRect(x: 0, y: offsetY, width: width, height: imageHeight)
    }
}