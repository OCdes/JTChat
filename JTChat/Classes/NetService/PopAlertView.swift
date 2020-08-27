//
//  PopAlertView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/10.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class PopAlertView: UIView {
    
    var tapSubject: PublishSubject<Any> = PublishSubject<Any>()
    
    lazy var titleLa: UILabel = {
        let la = UILabel()
        la.textColor = HEX_333
        la.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return la
    }()
    lazy var contentLa: UILabel = {
        let la = UILabel()
        la.textColor = HEX_333
        la.numberOfLines = 2
        la.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return la
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.image = UIImage(named: "")
        return pv
    }()
    
    override init(frame: CGRect) {
        let height = frame.size.height > 70 ? frame.size.height : 70
        let f = CGRect(x: 15.5, y: 0-height, width: kScreenWidth-31, height: height)
        super.init(frame: f)
        layer.shadowColor = HEX_COLOR(hexStr: "#584C87").withAlphaComponent(0.6).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 21
        backgroundColor = HEX_FFF
        layer.cornerRadius = 5
        addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(22)
            make.top.equalTo(self).offset(14)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.snp_centerY)
            make.left.equalTo(portraitV.snp_right).offset(20)
            make.width.equalTo((kScreenWidth-105-20))
        }
        
        addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_centerY)
            make.left.right.equalTo(titleLa)
            make.bottom.lessThanOrEqualTo(self)
        }
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tap)))
        let swipe = UISwipeGestureRecognizer.init(target: self, action: #selector(swiped))
        swipe.direction = .up
        addGestureRecognizer(swipe)
    }
    
    @objc func tap() {
        tapSubject.onNext("")
    }
    
    @objc func swiped() {
        hide()
    }
    
    func show() {
        APPWINDOW.addSubview(self)
        let frame =  CGRect(x: self.frame.origin.x, y: kiPhoneXOrXS ? 54 : 32, width: self.frame.width, height: self.frame.height)
        UIView.animate(withDuration: 0.3) {
            self.frame = frame
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.hide()
        }
    }
    
    func hide() {
        let frame =  CGRect(x: self.frame.origin.x, y: 0-self.frame.height, width: self.frame.width, height: self.frame.height)
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = frame
        }) { (b) in
            self.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
