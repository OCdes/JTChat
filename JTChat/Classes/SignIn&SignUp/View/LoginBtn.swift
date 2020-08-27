//
//  LoginBtn.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/5.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class LoginBtn: UIButton {
    var viewModel: SignInViewModel? = nil
    init(frame: CGRect, viewModel: SignInViewModel) {
        super.init(frame: frame)
        self.viewModel = viewModel
        setTitle("登录", for: UIControl.State.normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        setBackgroundImage(UIImage.imageWith(color: HEX_COLOR(hexStr: "#2E96F7"))?.resizableImage(withCapInsets: UIEdgeInsets.zero), for: UIControl.State.normal)
        setBackgroundImage(UIImage.imageWith(color: HEX_COLOR(hexStr: "#716F73"))?.resizableImage(withCapInsets: UIEdgeInsets.zero), for: UIControl.State.disabled)
        addTarget(self, action: #selector(self.loginClicked(sender:)), for: UIControl.Event.touchUpInside)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   @objc func loginClicked(sender: UIButton) {
        
    }
    
}
