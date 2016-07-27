//
//  KYProgressImgView.swift
//  demo
//
//  Created by Kinyong on 16/7/12.
//  Copyright © 2016年 Ayong. All rights reserved.
//

import UIKit

class KYProgressImgView: UIImageView {
    private lazy var progressView: KYProgressView = KYProgressView()
    
    /// 下载进度值，0.0 ~ 1.0
    var progress: CGFloat = 0 {
        didSet{
            progressView.progress = progress
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    override func layoutSubviews() {
        progressView.frame = self.bounds
    }
    
    private func setupUI() {
        self.addSubview(progressView)
        progressView.frame = self.bounds
        progressView.backgroundColor = UIColor.clearColor()
    }
    
    func setProgressHidden(bool: Bool){
        progressView.hidden = bool
    }
}
