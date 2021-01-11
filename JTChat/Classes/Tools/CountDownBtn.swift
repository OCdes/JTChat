//
//  CountDownBtn.swift
//  Swift-jtyh
//
//  Created by 袁炳生 on 2019/12/14.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class CountDownBtn: UIButton {
    var countSeconds: Int?
    var timer: Observable<Int>?
    let disposeBag = DisposeBag()
    var subscription: Disposable?
    init(frame: CGRect, countSeconds: Int) {
        super.init(frame: frame)
        self.countSeconds = countSeconds
        
        setTitle("获取验证码", for: .normal)
        setTitleColor(HEX_FFF, for: .normal)
        titleLabel!.font = UIFont.systemFont(ofSize: 14)
        setBackgroundImage(UIImage.imageWith(color: HEX_COLOR(hexStr: "#2E96F7")), for: .normal)
        setBackgroundImage(UIImage.imageWith(color: HEX_COLOR(hexStr: "#716F73")), for: .disabled)
        layer.cornerRadius = 3
        layer.masksToBounds = true
        timer = Observable<Int>.interval(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
    }
    
    
    open func startCount() {
        
        self.subscription = timer?.subscribe(onNext: { [weak self](num) in
            let a = self!.countSeconds! - num
            self!.isEnabled = a==0
            self!.setTitle(a == 0 ? "获取验证码" : "已发送\(a)s", for: .normal)
            if a == 0 {
                self?.subscription?.dispose()
            }
        })
        
    }
    
    func stopCount() {
        self.subscription?.dispose()
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
