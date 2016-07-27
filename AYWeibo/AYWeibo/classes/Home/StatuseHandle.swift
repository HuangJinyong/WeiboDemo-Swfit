//
//  StatuseHandle.swift
//  AYWeibo
//
//  Created by Kinyong on 16/7/8.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import SDWebImage

class StatuseHandle: NSObject {
    /// 保存所有微博数据
    var statuses: [StatuseViewModel]?
    
    
    // 加载当前登录用户的微博
    /*
     since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
     max_id	false	int64	若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
     默认情况下, 新浪返回的数据是按照微博ID从大到小得返回给我们的
     也就意味着微博ID越大, 这条微博发布时间就越晚
     经过分析, 如果要实现下拉刷新需要, 指定since_id为第一条微博的id
     如果要实现上拉加载更多, 需要指定max_id为最后一条微博id -1
     */
    
    func loadStatusesData(lastStatuse: Bool, completion: (datas: [StatuseViewModel]?, error: NSError? ) -> Void) {
        
        // 第一次加载，idstr为nil，默认为0，初始加载20条数据，当下拉刷新时候，里面已经存放数据，就会根据idstr返回新的数据过来
        var since_id = statuses?.first?.statuse.idstr ?? "0"
        var max_id = "0"
        
        // 如果是最后一条数据，进行上拉显示更早数据
        if lastStatuse {
            max_id = statuses?.last?.statuse.idstr ?? "0"
            since_id = "0"
        }
        
        NetWorkTools.shareIntance.loadStatuses(since_id, max_id: max_id) { (response) in
            // 1.获取网络数据
            guard let data = response.data else {
                QL3("获取网络数据失败")
                completion(datas: nil, error: response.result.error)
                return
            }
            
            // 2.json转字典
            do {
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [String: AnyObject]
                
                // 3.字典转模型
                var models = [StatuseViewModel]()
                
                guard let arr = dict["statuses"] as? [[String: AnyObject]] else {
                    QL3("提取数据失败")
                    completion(datas: nil, error: NSError(domain: "com.kinyong", code: 1, userInfo: nil))
                    return
                }
                
                for dict in arr {
                    let statuse = StatuseModel(dict: dict)
                    models.append(StatuseViewModel(statuse: statuse))
                }
                
                // 4. 处理微博数据(第一次刷新，下拉刷新）
                if since_id != "0" {
                    // 下拉刷新,此时statuses里面已经有值，可以用！
                    self.statuses = models + self.statuses!
                    
                    
                } else if max_id != "0" {
                    // 上拉显示更早微博
                    self.statuses = self.statuses! + models
                } else {
                    // 第一次加载
                    self.statuses = models
                }
                
                // 5. 缓存图片
                self.cacheImage(models, completion: completion)
                
            } catch {
                QL3("json解析失败")
                completion(datas: nil, error: NSError(domain: "com.kinyong", code: 1, userInfo: nil))
            }
            
        }
    }
    
    // 3.1 缓存图片方法实现
    private func cacheImage(models: [StatuseViewModel], completion: (datas: [StatuseViewModel]?, error: NSError? ) -> Void) {
        // 0.创建一个队列组
        let group = dispatch_group_create()
        
        for viewModel in models {
            
            // 1.从模型数据中取出配图数组
            guard let urls = viewModel.thumbnail_urls else {
                continue
            }
            
            // 2.遍历配图数组利用SDWebImage下载图片
            for url in urls {
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (image, error, _, _, _) in
                    dispatch_group_leave(group)
                    
                })
                
            }
        }
        // 3.2 存储模型 - 监听缓存图片下载完成
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            completion(datas: models, error: nil)
        })
    }
}
