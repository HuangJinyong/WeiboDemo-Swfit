//
//  MainViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // iOS7以后设置tintColor，那么图片和文字都会按照tintColor渲染
        tabBar.tintColor = UIColor.orangeColor()
        
        // 添加子控制器
        addChildViewControllers()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加按钮
        tabBar.addSubview(composeBtn)
        
        // 设置按钮frame
        let reck = composeBtn.frame
        let width = tabBar.bounds.width / CGFloat(self.childViewControllers.count)
        let y = (tabBar.bounds.height - reck.height) / 2
        
        composeBtn.frame = CGRectMake(2 * width, y, width, reck.height)
    }
    
    // MARK: - 内部方法实现
    
    // 添加所以的子控件
    func addChildViewControllers() {
        // 1.获取json文件路径
        guard let jsonPath = NSBundle.mainBundle().pathForResource("MainVCSettings", ofType: "json") else {
            QL2("json文件不存在")
            return
        }
        
        // 2.加载json数据
        guard let jsonData = NSData(contentsOfFile: jsonPath) else {
            QL2("加载二进制数据失败")
            return
        }
        
        // 3.解析json
        do {
            /*
             throws是swift的异常处理机制
             do catch的作用：一旦方法抛出异常，那么就会执行catch{}中的代码，如果没有抛出异常，那么catch{}中的代码不执行
             try: 正常处理异常，结合do catch，一旦有异常就执行catch
             try!: 强制处理异常（忽略异常），告诉系统一定不会发生异常，如果真的发生了异常，那么程序就会崩溃
             try?: 告诉系统可能有异常也可能没有异常，如果发生异常则返回nil，如果没有发生异常，将返回值包装为一个可选类型的值
             开发中推荐使用try 和 try？，不推荐使用try！
            */
            let arr = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers) as! [[String: String]]
            
            // 4.遍历数组创建子控制器
            for dic in arr {
                addChildViewController(dic["vcName"]!, title: dic["title"]!, image: dic["imageName"]!)
            }
        } catch {
            // json解析失败，创建默认子控制器
            QL2("json解析失败，创建默认子控制器")
            addChildViewController("HomeTableViewController", title: "首页", image: "tabbar_home") // 首页
            addChildViewController("MessageTableViewController", title: "消息", image: "tabbar_message_center") // 消息
            addChildViewController("NullViewController", title: "", image: "") // 加好按钮
            addChildViewController("DiscoverTableViewController", title: "发现", image: "tabbar_discover") // 发现
            addChildViewController("ProfileTableViewController", title: "我", image: "tabbar_profile") // 我
        }
    }
    
    /// 动态添加一个子控制器
    func addChildViewController(childControllerName: String, title: String, image: String) {
        
        // 1.动态获取命名空间
        // info.plist是系统默认配置，所以一定有值，我们强制解包
        // 获取到的info是一个字典，通过key取出来的是一个AnyObject对象
        // 通过key获取到命名空间，如果我们key写错或者没有对应的值，那么就取不到值，所以返回值可能有值也可能没值。
        // 所以我们用as？进行转换，通过guard进行解包。
        guard let name = NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else {
            QL2("获取命名空间失败")
            return
        }
        
        // 2.通过命名空间+类名创建一个类
        // 通过命名空间+类名创建的作用：避免类名重复
        let anyCls: AnyClass? = NSClassFromString(name + "." + childControllerName)

        // 3.确定类的真实类型，只有确定类的真实类型，才能创建类对象
        guard let cls = anyCls as? UITableViewController.Type else {
            QL2("cls不能当做UITableViewController")
            return
        }
        
        // 4.通过类创建对象
        let childController = cls.init()
        
        // 4.1.设置子控制器相关属性
        childController.title = title
        childController.tabBarItem.image = UIImage(named: image)
        childController.tabBarItem.selectedImage = UIImage(named: image + "_highlighted")

        // 5.包装一个导航控制器
        let nav = UINavigationController(rootViewController: childController)

        // 6.添加子控制器到UITabBarController
        addChildViewController(nav)
    }
    
    // 按钮监听方法
    func composeBtnClick() {
        QL2("按钮监听")
        // 1.创建导航控制器，添加根控制器
        let vc = ComposeViewController()
        let nv = UINavigationController(rootViewController: vc)
        // 2.弹出发送控制器
        self.presentViewController(nv, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    lazy var composeBtn: UIButton = {
        // 1.创建按钮
        let btn = UIButton(imageName: "tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        // 2.添加按钮监听
        btn.addTarget(self, action: #selector(self.composeBtnClick), forControlEvents: .TouchUpInside)
        
        return btn
    }()
}

