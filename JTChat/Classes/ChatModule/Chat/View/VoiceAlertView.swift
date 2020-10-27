//
//  VoiceAlertView.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/26.
//

import UIKit

class VoiceAlertView: UIView {
    lazy var imgv: UIImageView = {
        let iv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        imgv.center = self.center
        self.addSubview(imgv)
    }
    func showInWindow() {
        APPWINDOW.addSubview(self)
    }
    func hide() {
        self.removeFromSuperview()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
