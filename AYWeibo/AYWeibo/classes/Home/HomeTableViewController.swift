//
//  HomeTableViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "HomeCell"
private let reuseIdentifierForward = "ForwardCell"

class HomeTableViewController: BaseViewController {
    
    /// 用户数据操作
    private var statuseHandle = StatuseHandle()
    
    /// 缓存cell的行高
    private var rowHeightCache = [String: CGFloat]()
    
    /// 是否最后一条微博标记，默认为false
    /// 当是最后一条微博时候，为true；自动刷新表格，添加更早的数据。
    private var lastStatuse = false
    
    // MARK: - 懒加载
    
    /// 导航条标题按钮
    private lazy var titleButton: UIButton = {
        let btn = TitleButton()
        let title = RequestAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: #selector(self.titleBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return btn
    }()
    
    /// 刷新提醒
    private lazy var tipLabel: UILabel = {
        let lb = UILabel()
        
        lb.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 44)
        lb.text = "没有更多的数据"
        lb.hidden = true
        lb.backgroundColor = UIColor.orangeColor()
        lb.textColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        
        return lb
    }()
    
    /// 图片浏览器过渡动画管理
    private lazy var browserPresentationManager: JYBrowserPresentationController = JYBrowserPresentationController()
    
    // MARK: - 生命周期方法

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.判断用户是否登录
        if !isLogin {
            // 设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        
        // 2.初始化导航条按钮
        setupNavigationBar()
        
        // 3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.titleChange), name: AYTransitioningManagerPresented, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.titleChange), name: AYTransitioningManagerDismissed, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showImageBrowser(_:)), name: KYHomeCellShowImageView, object: nil)
        
        // 4.加载当前登录用户及其所关注（授权）用户的最新微博
        loadData()
        
        // 5.创建cell并注册标示符
        self.tableView.registerNib(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.registerNib(UINib(nibName: "ForwardTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierForward)
        self.tableView.separatorStyle = .None
        
        // 6.设置菊花
        self.refreshControl = KYRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.loadData), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl?.beginRefreshing()
        
        // 7. 添加刷新提醒
        self.navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
    }
    
    deinit {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 释放缓存数据
        rowHeightCache.removeAll()
    }
    
    // MARK: tableViewDataSurce
 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuseHandle.statuses?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = (statuseHandle.statuses![indexPath.row].forward_content_text != nil) ? reuseIdentifierForward : reuseIdentifier
        // 1.获取cell
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! HomeTableViewCell
        // 2.设置数据
        cell.viewModel = statuseHandle.statuses?[indexPath.row]
        // 3.判断是否最后一条微博
        if indexPath.row == (statuseHandle.statuses!.count - 1) {
            // 如果最后一条数据，重新加载数据
            lastStatuse = true
            loadData()
            
            QL2("最后一条微博----\(statuseHandle.statuses?[indexPath.row].statuse.user?.screen_name)")
        }
        // 3.返回cell
        return cell
    }
    
    // MARK: - tableviewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = statuseHandle.statuses![indexPath.row]
        let identifier = (statuseHandle.statuses![indexPath.row].forward_content_text != nil) ? reuseIdentifierForward : reuseIdentifier
        
        // 1.如果缓存中有值
        guard let height = rowHeightCache[viewModel.statuse.idstr ?? "-1"] else {
            // 2.如果缓存中没有值
            // 2.1 获取当前显示的cell
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as! HomeTableViewCell
            // 2.2 计算行高
            let rowHeigth = cell.calculateRowHeight(statuseHandle.statuses![indexPath.row])
            // 2.3 缓存行高
            rowHeightCache[viewModel.statuse.idstr ?? "-1"] = rowHeigth
            // 2.4 返回行高
            return rowHeigth
        }
        
        // 1.1 返回缓存中的行高
        return height
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 1000
    }
    
    // MARK: - 内部控制方法s
    
    // 加载当前登录用户的微博
    @objc private func loadData() {
        statuseHandle.loadStatusesData(lastStatuse) { (datas, error) in
            if error != nil {
                // 获取微博数据失败
                self.refreshControl?.endRefreshing()
                return
            }
            
            // 1.刷新表格
            self.tableView.reloadData()
            
            // 2.关闭下拉刷新提示
            self.refreshControl?.endRefreshing()
            
            //  3.显示刷新提醒数据
            self.showRefreshStatus(datas!.count)
        }
    }
    
    // 显示刷新数据提示方法
    private func showRefreshStatus(count: Int) {
        tipLabel.text = count == 0 ? "没有更多数据" : "\(count)条数据"
        tipLabel.hidden = false
        
        UIView.animateWithDuration(0.5, animations: {
            self.tipLabel.transform = CGAffineTransformMakeTranslation(0, 44)
            }) { (bool) in
                UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    self.tipLabel.transform = CGAffineTransformIdentity
                    }, completion: { (bool) in
                        self.tipLabel.hidden = true
                })
        }
    }
    
    // 接收到图片按钮点击通知后实现的方法
    @objc private func showImageBrowser(notification: NSNotification) {
        // 注意：但凡通过网络或者通知获取到的数据，都要进行安全校验
        guard let bmiddle_urls = notification.userInfo!["bmiddle_urls"] as? [NSURL] else {
            QL3("通知中心没有图片地址")
            return
        }
        
        guard let thumbnail_urls = notification.userInfo!["thumbnail_urls"] as? [NSURL] else {
            QL3("通知中心没有图片地址")
            return
        }
        
        guard let indexPath = notification.userInfo!["indexPath"] as? NSIndexPath else {
            QL3("通知中心没有索引")
            return
        }
        
        guard let pictureView = notification.object as? CollectionViewInHome else {
            QL3("无法获取发送通知的对象")
            return
        }
        
        // 1.弹出图片浏览器，将所有图片和当前点击的索引传递给浏览器
        let vc = ImageBrowserViewController(bmiddle_urls: bmiddle_urls, thumbnail_urls: thumbnail_urls, indexPath: indexPath)
        // 2.设置转场动画代理
        vc.transitioningDelegate = browserPresentationManager
        // 3.设置转场动画样式
        vc.modalPresentationStyle = .Custom
        // 4.设置转场动画需要的数据代理
        browserPresentationManager.setDefaultInfo(indexPath, browserDelegate: pictureView)
        
        self.presentViewController(vc, animated: true, completion: nil)
    }

    
    // 接收到通知后的实现方法
    @objc private func titleChange() {
        titleButton.selected = !titleButton.selected
    }
    
    private func setupNavigationBar() {
        // 1. 添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention",
                                                           target: self,
                                                           action: #selector(self.leftBarButtonItemClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop",
                                                            target: self,
                                                            action: #selector(self.rightBarButtonItemClick))
        
        // 2. 添加标题按钮
        navigationItem.titleView = titleButton
        
    }
    
    // 标题按钮监听方法
    @objc private func titleBtnClick(sender: TitleButton){
        QL2("")
        // 1.modal控制器
        // 1.1 获取storyboard
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        
        // 1.2 获取控制器
        guard let presentControl = sb.instantiateInitialViewController() else {
            QL2("获取控制器失败")
            return
        }
        
        // 1.3 modal控制器
        self.presentViewController(presentControl, animated: true, completion: nil)
    }
    
    /// 左侧导航条按钮监听方法
    @objc private func leftBarButtonItemClick() {
        QL2("")
    }
    
    /// 右侧导航条按钮监听方法
    @objc private func rightBarButtonItemClick() {
        QL2("")
        let nav = UINavigationController(rootViewController: QRCordViewController())
        nav.navigationBar.barTintColor = UIColor.blackColor()
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        presentViewController(nav, animated: true, completion: nil)
    }
    
}


