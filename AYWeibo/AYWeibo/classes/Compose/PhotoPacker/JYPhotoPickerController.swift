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
        cell.delegate = self
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

// MARK: - extension

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension JYPhotoPickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1.获取选中的照片
        let image = info["UIImagePickerControllerOriginalImage"] as! UIImage
        
        // 2.用collectionView显示照片
        // 2.1 通过绘图生成一个压缩的新图片，解决内存占用过大问题
        let NewImage = drawImage(image, width: 450.0)
        // 2.1将选中的图片放入数组中
        images.append(NewImage)
        // 2.2刷新数据
        self.collectionView?.reloadData()
        
        // 3.退出照片选择控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    // 绘制选中的系统图片，解决内存占用过大的问题
    private func drawImage(image: UIImage, width: CGFloat) -> UIImage {
        // 1.根据传入的宽度，更具宽高比设置高度
        let height = image.size.height / image.size.width * width
        let size = CGSize(width: width, height: height)
        
        // 2.绘图
        // 2.1 开启图片上下文
        UIGraphicsBeginImageContext(size)
        
        // 2.2 将图片画到上下文
        image.drawInRect(CGRectMake(0, 0, width, height))
        
        // 2.3 从上下文中获取绘制的新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 2.4 关闭图片上下文
        UIGraphicsEndImageContext()
        
        // 3.返回新的图片
        return newImage
    }
}

// MARK:
extension JYPhotoPickerController: JYPhotoPickerViewCellDelegate {
    func photoPickerViewCellRemovePhotoBtnClick(cell: JYPhotoPickerViewCell) {
         // 1.获取当前点击的索引
        let indexPath = self.collectionView?.indexPathForCell(cell)
        
        // 2.移除当前图片
        images.removeAtIndex(indexPath!.item)
        
        // 3.刷新表格
        self.collectionView?.reloadData()
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

