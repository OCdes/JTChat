//
//  ForgotVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/19.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SVProgressHUD
class ForgotVC: BaseViewController {
    var viewModel: SignInViewModel = SignInViewModel()
    lazy var phoneTf: AccountView = {
        var tf = AccountView(frame: CGRect(x: 36, y: 112 , width: kScreenWidth-72, height: 44), viewModel: self.viewModel)
        tf.placeholderStr = "请输入手机号码"
        return tf
    }()
    lazy var verifyCodeTf: AccountView = {
        var tf = AccountView(frame: CGRect(x: self.phoneTf.frame.minX, y: self.phoneTf.frame.maxY + 11, width: (kScreenWidth-72)*2/3, height: self.phoneTf.frame.height), viewModel: self.viewModel)
        tf.placeholderStr = "请输入验证码"
        return tf
    }()
    lazy var passTf: PasswordView = {
        var tf = PasswordView(frame: CGRect(x: self.verifyCodeTf.frame.minX, y: self.verifyCodeTf.frame.maxY + 11, width: self.phoneTf.frame.width, height: self.verifyCodeTf.frame.height), viewModel: self.viewModel)
        tf.placeholderStr = "请输入您的密码"
        return tf
    }()
    
    lazy var reconfirmPassTf: PasswordView = {
        var tf = PasswordView(frame: CGRect(x: self.passTf.frame.minX, y: self.passTf.frame.maxY + 11, width: self.passTf.frame.width, height: self.passTf.frame.height), viewModel: self.viewModel)
        tf.placeholderStr = "请确认您的密码"
        return tf
    }()
    //验证码发送按钮
    lazy var sendCodeBtn: CountDownBtn = {
        var btn = CountDownBtn(frame: CGRect(x: (kScreenWidth-72)*2/3+46, y: self.verifyCodeTf.frame.minY, width: (kScreenWidth-72)/3-10, height: self.verifyCodeTf.frame.height), countSeconds: 60)
        return btn
    }()
    
    //注册按钮
    lazy var registBtn : LoginBtn = {
        let btn = LoginBtn.init(frame: CGRect(x: self.reconfirmPassTf.frame.origin.x, y: self.reconfirmPassTf.frame.maxY + 33, width: self.reconfirmPassTf.frame.width, height: 44), viewModel: self.viewModel)
        btn.setTitle("下一步", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        return btn
    }()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initUI()
        self.bindModel()
    }
    
    
    func initUI() {
        self.title = "忘记密码"
        view.backgroundColor = HEX_COLOR(hexStr: "#312F34")
        view.addSubview(self.phoneTf)
        view.addSubview(self.verifyCodeTf)
        view.addSubview(self.sendCodeBtn)
        view.addSubview(self.passTf)
        view.addSubview(self.reconfirmPassTf)
        view.addSubview(self.registBtn)
        
    }
    
    func bindModel() {
        let phoneValid = phoneTf.rx.text.orEmpty.map{$0.count == 11}.share(replay: 1)
        _ = phoneTf.rx.text.subscribe(onNext: { [weak self](value) in
            self!.viewModel.phoneStr = value ?? ""
        })
        _ = phoneTf.rx.text.orEmpty.flatMap({ [weak self](string) -> Observable<Any> in
            if string.count > 11 {
                self!.phoneTf.text = String(string.prefix(11))
                return Observable.just(string.prefix(11))
            }
            return Observable.just(string.prefix(11))
        })
        let verifyValid = verifyCodeTf.rx.text.orEmpty.map{$0.count > 0}
        _ = verifyCodeTf.rx.text.subscribe(onNext: { [weak self](value) in
            self!.viewModel.verifyCode = value ?? ""
        })
        
        _ = sendCodeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]() in
            if self?.viewModel.phoneStr.count == 0 {
                SVProgressHUD.showError(withStatus: "请填写手机号")
            } else if self?.viewModel.phoneStr.count != 11 {
                SVProgressHUD.showError(withStatus: "手机号格式不正确")
            } else {
                self!.viewModel.sendCodeWithType(type: .CodeTypeRegister)
            }
            
        })
        
        let passValid = passTf.rx.text.orEmpty.map{$0.count > 0}
        _ = passTf.rx.text.subscribe(onNext: { [weak self](value) in
            self!.viewModel.passwordStr = value ?? ""
        })
        
        let reconfirmValid = passTf.rx.text.orEmpty.map{$0.count > 0}
        
        let registerValid = Observable.combineLatest(reconfirmValid, phoneValid, verifyValid, passValid){($0 && $1) && ($2 && $3)}.share(replay: 1)
        _ = registerValid.bind(to: registBtn.rx.isEnabled)
        
        self.viewModel.sendCodeBlock = {
            (b: Bool) -> Void in
            if b {
                self.sendCodeBtn.startCount()
            } else {
                self.sendCodeBtn.stopCount()
            }
        }
        
        _ = registBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { () in
            if self.passTf.text == self.reconfirmPassTf.text {
                self.viewModel.setNewPassword()
            } else {
                SVProgressHUD.showError(withStatus: "两次输入的密码不一致")
            }
            
        })
    }
    
}
