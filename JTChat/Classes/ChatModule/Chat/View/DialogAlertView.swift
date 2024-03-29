//
//  DialogAlertView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/23.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class DialogAlertView: UIView {
    var btnArr: Array<String> = ["  发起群聊","  扫一扫    ", "  加好友    "]
    var imageArr: Array<String> = ["groupMessage","scanIcon","addFriend2"]
    var subject: PublishSubject<Int> = PublishSubject<Int>()
    lazy var bgv: UIView = {
        let bv = UIView.init(frame: APPWINDOW.bounds)
        bv.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(hide)))
        bv.backgroundColor = HEX_333.withAlphaComponent(0.3)
        return bv
    }()
    lazy var animateV: UIView = {
        let bgv = UIView.init(frame: CGRect(x: 75, y: 10 - btnArr.count*22, width: 135, height: btnArr.count*44))
        bgv.layer.cornerRadius = 10
        bgv.backgroundColor = kIsFlagShip ? HEX_ThemeBlack : HEX_FFF
        return bgv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: Int(kScreenWidth)-155, y: ((kiPhoneXOrXS || kDynamicIsland) ? 84 : 64) , width: 135, height: 10+btnArr.count*44)
        animateV.layer.anchorPoint = CGPoint(x: 1, y: 0)
        let trangle = UIImageView.init(frame: CGRect(x: 110, y: 4, width: 10, height: 6))
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 6), false, UIScreen.main.scale)
            let c = UIGraphicsGetCurrentContext()
            if let context = c {
                context.saveGState()
                context.setFillColor((kIsFlagShip ? HEX_ThemeBlack : HEX_FFF).cgColor)
                var points = [CGPoint](repeating: CGPoint.zero, count: 3)
                points[0] = CGPoint(x: 0, y: 6)
                points[1] = CGPoint(x: 10, y: 6)
                points[2] = CGPoint(x: 6, y: 0)
                context.addLines(between: points)
                context.closePath()
                context.drawPath(using: .fill)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                context.restoreGState()
                DispatchQueue.main.async {
                    trangle.image = image
                }
            }
            
        }
        addSubview(trangle)
        
        addSubview(animateV)
        for i in 0..<btnArr.count {
            let btn = UIButton.init(frame: CGRect(x: 0, y: 44*i, width: 135, height: 44))
            btn.setImage(JTBundleTool.getBundleImg(with:imageArr[i])?.withRenderingMode(.alwaysOriginal), for: .normal)
            btn.setTitle(btnArr[i], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitleColor(kIsFlagShip ? HEX_GOLDTEXTCOLOR : HEX_COLOR(hexStr: "#3F80CB"), for: .normal)
            btn.tag = 2000+i
            btn.addTarget(self, action: #selector(btnClicked(btn:)), for: .touchUpInside)
            animateV.addSubview(btn)
        }
        animateV.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        alpha = 0.01
    }
    
    @objc func btnClicked(btn: UIButton) {
        self.subject.onNext(btn.tag-2000)
        hide()
    }
    
    func show() {
        APPWINDOW.addSubview(bgv)
        APPWINDOW.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.animateV.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.animateV.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.alpha = 0.01
        }) { (b) in
            self.removeFromSuperview()
            self.bgv.removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
