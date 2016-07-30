//
//  JYPhotoCollectionController.swift
//  AYWeibo
//
//  Created by Jinyong on 16/7/29.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class JYPhotoPickerController: UICollectionViewController {
    
    /// 图片数组，用于存储相册选中的图片
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(JYPhotoPickerViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }


    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1 // 后面 + 1 是添加按钮的item
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! JYPhotoPickerViewCell
        cell.btnClickcallBack = { (item: UIButton) in
            self.packerPhotoImage()
        }
        cell.image = indexPath.item >= images.count ? nil : images[indexPath.item]
        
        return cell
    }
    
    // MARK: 内部控制方法
    private func packerPhotoImage() {
        // 1.判断照片源是否可用
        guard UIImagePickerController.isSourceTypeAvailable(.SavedPhotosAlbum) else {
            QL3("照片源不可用")
            return
        }

        // 2.创建照片选择控制器
        let imageController = UIImagePickerController()
        
        // 3.设置照片源
        imageController.sourceType = .SavedPhotosAlbum
        
        // 4.设置代理
        imageController.delegate = self
        
        // 5.弹出照片选择控制器
        self.presentViewController(imageController, animated: true, completion: nil)
    }
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension JYPhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1.获取选中的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        // 2.用collectionView显示照片
        // 2.1将选中的图片放入数组中
        images.append(image)
        // 2.2刷新数据
        self.collectionView?.reloadData()
        
        // 3.退出照片选择控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - UICollectionViewFlowLayout
class JYPhotoPickerViewLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        let margin: CGFloat = 20
        let clom = 3 // 列数（每行多少个）
        let itemWH = (UIScreen.mainScreen().bounds.width - margin * CGFloat(clom + 1)) / CGFloat(clom)
        
        // 1.设置item的宽高
        self.itemSize = CGSize(width: itemWH, height: itemWH)
        
        // 2.设置item的行距和间距
        self.minimumLineSpacing = margin
        self.minimumInteritemSpacing = margin
        
        // 3.设置内边距
        self.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: 0, right: margin)
        
        // 4.设置其他属性
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
    }
}

