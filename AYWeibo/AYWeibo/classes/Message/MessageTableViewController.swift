//
//  MessageTableViewController.swift
//  AYWeibo
//
//  Created by Ayong on 16/5/19.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class MessageTableViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isLogin {
            visitorView?.setupVisitorInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，发给你的消息，都会在这里收到通知")
            return
        }

    }
}
