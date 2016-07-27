//
//  AYCollectionViewLayout.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/22.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class AYNewfeatureLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        // 1.设置每个cell的尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        
        // 2.设置每个cell的间隙
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 3.设置水平滚动方向
        scrollDirection = .Horizontal
        
        // 4.设置分页
        collectionView?.pagingEnabled = true
        
        // 5.禁止回弹效果
        collectionView?.bounces = false
        
        // 6.取消滚动条
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}
