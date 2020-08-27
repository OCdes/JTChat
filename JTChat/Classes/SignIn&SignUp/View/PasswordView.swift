//
//  PasswordView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/9.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class PasswordView: InputView {
    var viewModel: SignInViewModel? = nil
    var placeholderStr: String = "" {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
        }
    }
    init(frame: CGRect, viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        self.attributedPlaceholder = NSAttributedString(string: "请输入密码", attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
        font = UIFont.systemFont(ofSize: 16)
        textColor = UIColor.white
        self.isSecureTextEntry = true
        let leftV = UIView(frame:CGRect(x:0, y:0, width:10, height:frame.height))
        leftView = leftV
        leftViewMode = UITextField.ViewMode.always
        let rightV = UIView(frame:CGRect(x:0, y:0, width:25.5, height:frame.height))
        let rightBtn = UIButton.init(frame:CGRect(x:0, y:0, width:25.5, height:frame.height))
        rightBtn.setImage(UIImage(named: "eyeClose"), for: UIControl.State.selected)
        rightBtn.setImage(UIImage(named: "eyeOpen"), for: UIControl.State.normal)
        rightBtn.addTarget(self, action: #selector(clearBtnClicked(sender:)), for: UIControl.Event.touchUpInside)
        rightBtn.isSelected = true
        rightV.addSubview(rightBtn)
        rightView = rightV
        rightViewMode = UITextField.ViewMode.whileEditing
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clearBtnClicked(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = sender.isSelected
    }

}
