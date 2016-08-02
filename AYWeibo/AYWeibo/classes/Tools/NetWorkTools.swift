//
//  NetWorkTools.swift
//  AYWeibo
//
//  Created by Ayong on 16/6/21.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit
import Alamofire

class NetWorkTools: NSObject {
    /// 共享网络工具
    static let shareIntance = NetWorkTools()
    
    /// 获取AccessToken请求
    func loadAccessToken(parameters: [String: AnyObject], completion: (response: Response<AnyObject, NSError>) -> Void) {
        // 1.准备请求路径
        guard let url = NSURL(string: "https://api.weibo.com/oauth2/access_token") else {
            return
        }
        
        // 2.发送POST请求
        Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            completion(response: response)
        }
    }
    
    /// 获取用户信息请求
    func loadUserInfo(parameters: [String: AnyObject], completion: (response: Response<AnyObject, NSError>) -> Void)  {
        // 1.准备请求路径
        guard let url = NSURL(string: "https://api.weibo.com/2/users/show.json") else {
            QL1("用户信息请求路径失效")
            return
        }
        
        // 2.发送GET请求
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
           completion(response: response)
        }
    }
    
    /// 获取当前登录用户的微博，每次返回20条
    func loadStatuses(since_id: String, max_id: String, completion: (response: Response<AnyObject, NSError>) -> Void){
        assert(RequestAccount.loadUserAccount() != nil, "必须先授权之后才能获取用户微博数据")
        
        // 1.请求路径
        guard let url = NSURL(string: "https://api.weibo.com/2/statuses/home_timeline.json") else {
            QL3("请求路径失败")
            return
        }
        
        let maxID = max_id == "0" ? max_id : "\(Int(max_id)! - 1)"
        
        // 2.请求参数
        let parameters = ["access_token": RequestAccount.loadUserAccount()!.access_token!, "since_id": since_id, "max_id": maxID]
        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL, headers: nil).responseJSON { (response) in
            completion(response: response)
        }
    }
    
    /// 发送微博
    func sendStatus(status: String, image: UIImage?, completion: (data: NSData?, error: NSError?) -> Void) {
        if image == nil {
            // 1.请求路径
            guard let url = NSURL(string: "https://api.weibo.com/2/statuses/update.json") else {
                QL3("请求路径失败")
                return
            }
            
            // 2.请求参数
            let parameters = ["access_token": RequestAccount.loadUserAccount()!.access_token!,"status": status]
            
            // 3.发送请求
            Alamofire.request(.POST, url, parameters: parameters, encoding: .URL, headers: nil).response { (request, reponse, data, error) in
                if error != nil {
                    completion(data: nil, error: error)
                    QL3("发送请求失败")
                    return
                }
                
                completion(data: data, error: error)
            }
        } else { // 上传带图片微博
            
            let imageData = UIImagePNGRepresentation(image!)!

            // 1.请求路径
            guard let url = NSURL(string: "https://upload.api.weibo.com/2/statuses/upload.json?&access_token=\(RequestAccount.loadUserAccount()!.access_token!)&status=\(status)&pic=\(imageData)") else {
                QL3("请求路径失败")
                return
            }
            
            
            // 2.请求参数
//            let parameters = ["access_token": RequestAccount.loadUserAccount()!.access_token!,"status": status, "pic": imageData]
            
            Alamofire.request(.POST, url, parameters: nil, encoding: .URL, headers: nil).response(completionHandler: { (reuqest, response, data, error) in
                if error != nil {
                completion(data: nil, error: error)
                return
                }

                completion(data: data, error: nil)

            })
            
        
//            // 3.发送请求
//            Alamofire.upload(.POST, url, data: imageData).response(queue: dispatch_get_main_queue(), completionHandler: { (request, response, data, error) in
//                if error != nil {
//                    completion(data: nil, error: error)
//                    return
//                }
//                
//                completion(data: data, error: nil)
//            })
        }
    }
}
