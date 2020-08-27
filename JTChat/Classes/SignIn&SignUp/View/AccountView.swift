//
//  AccountView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/9.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class AccountView: InputView {
    var viewModel: SignInViewModel? = nil
    var placeholderStr: String = "" {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
        }
    }
    init(frame: CGRect ,viewModel: SignInViewModel) {
        super.init(frame: frame, rightImgStr: "cleanText", placeHolder: "请输入账号", action: #selector(clearBtnClicked(sender:)))
        self.viewModel = viewModel
        self.attributedPlaceholder = NSAttributedString(string: "请输入账号", attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clearBtnClicked(sender:UIButton) {
        text = ""
    }
}
