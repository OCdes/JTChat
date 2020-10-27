//
//  TouchButton.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/22.
//

import UIKit

class TouchButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addObserver(self, forKeyPath: "state", options: .new, context: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let cha = change {
            if let key = cha[.newKey] {
                print("监听到的值:\(key)")
            }
        }
    }
    
}
