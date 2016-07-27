//
//  DiscoverTableViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class DiscoverTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo("visitordiscover_image_message", title: "登录后，最新、最热微博尽在掌握，不再会与实事潮流擦肩而过")
            return
        }
    }
}
