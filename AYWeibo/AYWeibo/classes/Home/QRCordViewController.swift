//
//  QRCordViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/10.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import AVFoundation

class QRCordViewController: UIViewController {
    
    private lazy var tabBar: UITabBar = {
        let tBar = UITabBar()
        tBar.barTintColor = UIColor.blackColor()
        tBar.items = [UITabBarItemExtension(title: "二维码", imageName: "qrcode_tabbar_icon_qrcode", tag: qrCodeItemTag),
                      UITabBarItemExtension(title: "条形码", imageName: "qrcode_tabbar_icon_barcode", tag: barCodeItemTag)]
        tBar.selectedItem = tBar.items?.first

        return tBar
    }()
    
    // 扫描视图
    private lazy var scanView: AYScanView = AYScanView(frame: AYRectCenterWihtSize(300, 300, controller: self))

    // 输入对象
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    // 我的二维码按钮
    private lazy var myCodeButton: UIButton = {
       let btn = UIButton()
        btn.setTitle("我的二维码", forState: .Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        return btn
    }()
    
    // 输出对象
    private lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        // 设置扫描区域：输出对象解析数据时感兴趣的范围
        // 默认值是CGRectMake(0, 0, 1, 1)，通过对这个值的观察，我们发现传入的是比例
        // 注意：比例是以横屏的左上角作为参照，而不是竖屏
        // 1.获取屏幕和容器的frame
        let viewRect = self.view.frame
        let containerRect = self.scanView.frame
        
        // 2.计算比例
        let x = containerRect.origin.y / viewRect.height
        let y = containerRect.origin.x / viewRect.width
        let width = containerRect.height / viewRect.height
        let height = containerRect.width / viewRect.width
        
        // 3.设置感兴趣范围
        out.rectOfInterest = CGRectMake(x, y, width, height)
        
        return out
    }()
    
    // 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    // 预览图层
    private lazy var presentLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    
    // 显示捕获结果
    private var titleLabel: UILabel!
    
    // 容器图层
    private lazy var containerLayer: CALayer = CALayer()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.配置子视图
        setupSubViews()
        
        // 2.添加约束
        setupConstraints()

        // 2.开始扫描二维码
        scanQRCode()
    }
    
    override func viewDidAppear(animated: Bool) {
        scanView.animateWithScan()
    }
    
    // MARK: - 内部方法
    
    private func scanQRCode() {
        // 1.判断输入和输出是否能添加到会话中
        guard
            session.canAddInput(input) &&
            session.canAddOutput(output)
        else {
                return
        }
        
        // 2.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 3.设置输出能够解析的数据类型
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 4.设置监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 5.添加预览图层
        presentLayer.frame = view.bounds
        view.layer.insertSublayer(presentLayer, atIndex: 0)
        
        // 6.开始扫描
        session.startRunning()
    }
    
    private func setupSubViews() {
        // 1.配置导航条
        setupNavigationBar()
        
        // 2.添加标签栏
        tabBar.delegate = self
        view.addSubview(tabBar)
        
        // 3.添加扫描视图
        scanView.clipsToBounds = true
        scanView.backgroundColor = UIColor.clearColor()
        view.addSubview(scanView)
        
        // 4.创建扫描内容显示标题
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "将二维码/条形码放入框内，即可自动扫描"
        titleLabel.font = UIFont.systemFontOfSize(14)
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.backgroundColor = UIColor.blackColor()
        titleLabel.alpha = 0.3
        view.addSubview(titleLabel)
        
        // 5.创建容器图层
        containerLayer.frame = view.bounds
        view.layer.addSublayer(containerLayer)
        
        // 6.我的二维码
        myCodeButton.addTarget(self, action: #selector(self.myCodeButtonClick), forControlEvents: .TouchUpInside)
        view.addSubview(myCodeButton)
    }
    
    private func setupConstraints() {
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        myCodeButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 1.标签栏约束
        tabBar.addConstraint(NSLayoutConstraint(item: tabBar,
                                                attribute: .Height,
                                                relatedBy: .Equal,
                                                toItem: nil,
                                                attribute: .NotAnAttribute,
                                                multiplier: 0.0,
                                                constant: 49))
        
        view.addConstraint(NSLayoutConstraint(item: tabBar,
                                              attribute: .Leading,
                                              relatedBy: .Equal,
                                              toItem: view,
                                              attribute: .Leading,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        view.addConstraint(NSLayoutConstraint(item: tabBar,
                                              attribute: .Trailing,
                                              relatedBy: .Equal,
                                              toItem: view,
                                              attribute: .Trailing,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        view.addConstraint(NSLayoutConstraint(item: tabBar,
                                              attribute: .Bottom,
                                              relatedBy: .Equal,
                                              toItem: view,
                                              attribute: .Bottom,
                                              multiplier: 1.0,
                                              constant: 0))
        
        // 2.显示扫描结果标题约束
        view.addConstraint(NSLayoutConstraint(item: titleLabel,
                                              attribute: .Leading,
                                              relatedBy: .Equal,
                                              toItem: scanView,
                                              attribute: .Leading,
                                              multiplier: 1.0,
                                              constant: 0.0))
        
        view.addConstraint(NSLayoutConstraint(item: titleLabel,
                                              attribute: .Trailing,
                                              relatedBy: .Equal,
                                              toItem: scanView,
                                              attribute: .Trailing,
                                              multiplier: 1.0,
                                              constant: 0.0))
 
        view.addConstraint(NSLayoutConstraint(item: titleLabel,
                                              attribute: .Top,
                                              relatedBy: .Equal,
                                              toItem: scanView,
                                              attribute: .Bottom,
                                              multiplier: 1.0,
                                              constant: 20))
        
        // 3.我的二维码按钮约束
//        myCodeButton.addConstraint(NSLayoutConstraint(item: myCodeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: 100.0))
        view.addConstraint(NSLayoutConstraint(item: myCodeButton, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Bottom, multiplier: 1.0, constant: 30.0))
        view.addConstraint(NSLayoutConstraint(item: myCodeButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "扫一扫"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭",
                                                           style: .Plain,
                                                           target: self,
                                                           action: #selector(self.leftBarBtnClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册",
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(self.rightBarBtnClick))
    }
    
    // 我的二维码按钮监听
    @objc private func myCodeButtonClick() {
        QL2("")
//        navigationController?.pushViewController(QRCodeCreateViewController(), animated: true)
        showViewController(QRCodeCreateViewController(), sender: nil)
    }
    
    // 导航条按钮监听方法
    @objc private func leftBarBtnClick() {
        QL2("")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func rightBarBtnClick() {
        QL2("")
        // 打开系统相册
        // 1.判断是否能够打开相册
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        // 2.创建相册控制器
        let imageController = UIImagePickerController()
        imageController.delegate = self
        
        // 3.弹出相册控制器
        presentViewController(imageController, animated: true, completion: nil)
    }
}

// MARK: - Delegate

// MARK: 相册控制器代理
extension QRCordViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        QL2("")
        
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            QL2("取出选中图片失败")
            return
        }
        
        // 2.从选中的图片中读取二维码数据
        // 2.1 创建一个检测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        // 2.2 利用检测器检测数据
        guard let ciImage = CIImage(image: image) else {
            QL2("创建ciImage失败")
            return
        }
        
        let results = detector.featuresInImage(ciImage)
        
        // 2.3 取出检测的数据
        for result in results {
            QL2((result as! CIQRCodeFeature).messageString)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK:  扫描输出设备代理
extension QRCordViewController: AVCaptureMetadataOutputObjectsDelegate {
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // 0.清空上次的描边图层
        clearSubLayers()
        
        // 1.显示扫描结果
        titleLabel.text = metadataObjects.last?.stringValue
        
        // 2.拿到扫描到的数据
        guard
            let metaData = metadataObjects.last as? AVMetadataObject
        else {
            QL2("获取扫描数据失败")
            return
        }
        
        // 3.通过预览图层将数据转换成系统识别的数据类型
        if let objc = presentLayer.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject {
            // 4.对扫描到的二维码进行描边
            drawLines(objc)
        }
    }
    
    private func drawLines(objc: AVMetadataMachineReadableCodeObject) {
        // 1.创建图层，用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2. 创建贝塞尔路径，绘制图形
        let path = UIBezierPath()
        
        // 3.获取捕获数据中的矩形四个边角point
        let corners = objc.corners.map { (point) -> CGPoint in
            let dict = point as! NSDictionary
            let x = dict["X"] as! CGFloat
            let y = dict["Y"] as! CGFloat
            
            return CGPoint(x: x, y: y)
        }
        
        // 4.绘制图形
        for i in 0..<corners.count {
            if i == 0 {
                path.moveToPoint(corners[i])
            }
            path.addLineToPoint(corners[i])
        }
        
        // 5.关闭路径
        path.closePath()
        
        layer.path = path.CGPath
        
        containerLayer.addSublayer(layer)
    }
    
    func clearSubLayers() {
        guard
            let subLayers = containerLayer.sublayers
        else {
            QL2("没有图层")
            return
        }
        
        for layer in subLayers {
            layer.removeFromSuperlayer()
        }
    }
}


// MARK:  标签栏代理
extension QRCordViewController: UITabBarDelegate {
    // 标签栏item按钮监听
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        QL2("")
        
        // 根据当前选中的按钮重新设置二维码容器的高度
        scanView.frame = (item.tag == qrCodeItemTag) ? AYRectCenterWihtSize(300, 300, controller: self) : AYRectCenterWihtSize(300, 150, controller: self)
        
        view.layoutIfNeeded()

        // 移除动画
        scanView.layer.removeAllAnimations()
        
        // 重新开始动画
        scanView.animateWithScan()
    }
}
