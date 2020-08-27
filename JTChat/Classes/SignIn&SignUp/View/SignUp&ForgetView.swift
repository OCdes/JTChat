//
//  SignUp&ForgetView.swift
//  Swift-jtyh
//
//  Created by 袁炳生 on 2019/12/14.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class SignUp_ForgetView: UIView {
    var viewModel: SignInViewModel?
    init(frame: CGRect, viewModel: SignInViewModel, loginTypeExchange:@escaping(_ type: String)->Void) {
        super.init(frame: frame)
        self.viewModel = viewModel
        let exchangeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 44))
        exchangeBtn.setTitle("验证码登录", for: UIControl.State.normal)
        exchangeBtn.setTitle("密码登录", for: UIControl.State.selected)
        exchangeBtn.setTitleColor(HEX_FFF, for: UIControl.State.normal)
        exchangeBtn.setTitleColor(HEX_FFF, for: UIControl.State.selected)
        exchangeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _ = exchangeBtn.rx.controlEvent(.touchUpInside).subscribe({ (sender) in
            exchangeBtn.isSelected = !exchangeBtn.isSelected
            if (exchangeBtn.isSelected) {
                exchangeBtn.frame.size = CGSize(width: 55, height: 44)
                loginTypeExchange("验证码")
            } else {
                exchangeBtn.frame.size = CGSize(width: 70, height: 44)
                loginTypeExchange("密码")
            }
            })
        addSubview(exchangeBtn)

        let forgotBtn = UIButton(frame: CGRect(x: frame.width/2-30, y: 0, width: 60, height: 44))
        forgotBtn.setTitle("忘记密码?", for: UIControl.State.normal)
        forgotBtn.setTitleColor(HEX_FFF, for: UIControl.State.normal)
        forgotBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _ = forgotBtn.rx.tap.subscribe(onNext: { [weak self](sender) in
            let vc: ForgotVC = ForgotVC()
            self!.viewModel?.navigationVC?.pushViewController(vc, animated: true)
        })
        addSubview(forgotBtn)
        
        let signUpBtn = UIButton(frame: CGRect(x: frame.width-66, y: 0, width: 70, height: 44))
        signUpBtn.setTitle("新注册用户", for: UIControl.State.normal)
        signUpBtn.setTitleColor(HEX_FFF, for: UIControl.State.normal)
        signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        _ = signUpBtn.rx.tap.subscribe(onNext: { [weak self](sender) in
            let vc: SignUpVC = SignUpVC()
            self!.viewModel?.navigationVC?.pushViewController(vc, animated: true)
        })
        addSubview(signUpBtn)
        
        let line = UIView(frame: CGRect(x: 20, y: frame.height/2-0.25, width: frame.width-40, height: 0.5))
        line.backgroundColor = HEX_COLOR(hexStr: "#C2C2C2").withAlphaComponent(0.1)
        addSubview(line)
        let slogan: UILabel = UILabel(frame: CGRect(x: (frame.width-135)/2, y: frame.height/2-7, width: 135, height: 14))
        
        slogan.text = "缔造高端娱乐新标准"
        slogan.textAlignment = NSTextAlignment.center
        slogan.font = UIFont.systemFont(ofSize: 14)
        slogan.textColor = HEX_COLOR(hexStr: "#CECDCD")
        addSubview(slogan)
        let titleArr:[String] = ["精特娱汇技术支持","0571-85025117","www.hzjingte.com"]
        let width = frame.width/3
        for i in 0...2 {
            let la = UILabel(frame: CGRect(x: CGFloat(i)*width, y: frame.height-55, width: width, height: 55))
            la.font = UIFont.systemFont(ofSize: 9)
            la.textColor = HEX_999
            la.textAlignment = NSTextAlignment.left
            if i == 1 {
                la.textAlignment = NSTextAlignment.center
            }
            if i == 2 {
                la.textAlignment = NSTextAlignment.right
            }
            la.text = titleArr[i]
            addSubview(la)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
