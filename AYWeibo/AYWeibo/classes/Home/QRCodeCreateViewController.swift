//
//  QRCoderCreateViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/18.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class QRCodeCreateViewController: UIViewController {
    
    // 显示二维码视图
    private lazy var containerQRCodeView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 1.设置子控件
        setupSubView()
        
        // 2.生成二维码
        createQRCoder()
    }
    
    // MARK: - 内部方法
    
    private func setupSubView() {
        // 1.添加到视图
        containerQRCodeView.backgroundColor = UIColor.redColor()
        view.addSubview(containerQRCodeView)
        
        // 2.添加控件约束
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerQRCodeView.translatesAutoresizingMaskIntoConstraints = false
        
        // 添加宽高约束
        containerQRCodeView.addConstraint(NSLayoutConstraint(item: containerQRCodeView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 200))
        containerQRCodeView.addConstraint(NSLayoutConstraint(item: containerQRCodeView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 200))
       
        // 添加水平垂直居中约束
        view.addConstraint(NSLayoutConstraint(item: containerQRCodeView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: containerQRCodeView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    private func createQRCoder() {
        
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据到滤镜中
        filter?.setValue("阿勇微博".dataUsingEncoding(NSUTF8StringEncoding), forKey: "InputMessage")
        
        // 4.从滤镜中取出生成好的二维码图片
        guard let ciImage = filter?.outputImage else {
            return
        }
        
        containerQRCodeView.image = createNonInterpolatedUIImageFormCIImage(ciImage, size: 300)
    }
    
    /**
     生成高清二维码
     
     - parameter image: 需要生成原始图片
     - parameter size:  生成的二维码的宽高
     */
    private func createNonInterpolatedUIImageFormCIImage(image: CIImage, size: CGFloat) -> UIImage {
        
        let extent: CGRect = CGRectIntegral(image.extent)
        let scale: CGFloat = min(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent))
        
        // 1.创建bitmap
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        
        let context = CIContext(options: nil)
        let bitmapImage: CGImageRef = context.createCGImage(image, fromRect: extent)
        
        CGContextSetInterpolationQuality(bitmapRef,  CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale);
        CGContextDrawImage(bitmapRef, extent, bitmapImage);
        
        // 2.保存bitmap到图片
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }

}
