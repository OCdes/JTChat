//
//  SignInVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/2.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignInVC: BaseViewController {
    let viewModel: SignInViewModel = SignInViewModel()
    
    //用户头像及场所名称
   lazy var headerView: SignInHeaderView = {
       let headerV = SignInHeaderView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenWidth*2/3), viewModel: self.viewModel)
       return headerV
   }()
    //账号输入框
   lazy var accountTf: AccountView = {
    let accountV = AccountView.init(frame: CGRect(x: 35, y: kScreenHeight/2-100, width: kScreenWidth-70, height: 50), viewModel: self.viewModel)
    accountV.text = UserInfo.shared.accontStr
    accountV.backgroundColor = HEX_999.withAlphaComponent(0.1)
    return accountV
    }()
    //密码/验证码输入框
    lazy var passTf: PasswordView = {
        let passV = PasswordView.init(frame: CGRect(x: self.accountTf.frame.origin.x, y: self.accountTf.frame.maxY+15, width: self.accountTf.frame.width, height: self.accountTf.frame.height), viewModel: self.viewModel)
        passV.backgroundColor = HEX_999.withAlphaComponent(0.1)
        return passV
    }()
   //验证码发送按钮
    lazy var sendCodeBtn: CountDownBtn = {
        var btn = CountDownBtn(frame: CGRect(x: (kScreenWidth-70)*2/3+45, y: self.passTf.frame.minY, width: (kScreenWidth-70)/3-10, height: self.passTf.frame.height), countSeconds: 60)
        btn.isHidden = true
        return btn
    }()
    
   //登录按钮2
    lazy var loginBtn : LoginBtn = {
        let btn = LoginBtn.init(frame: CGRect(x: self.passTf.frame.origin.x, y: self.passTf.frame.maxY + 15, width: self.passTf.frame.width, height: 44), viewModel: self.viewModel)
        
        return btn
    }()
    
    lazy var signupView: SignUp_ForgetView = {
        let view = SignUp_ForgetView.init(frame: CGRect(x: self.loginBtn.frame.minX, y: self.loginBtn.frame.maxY+5, width: self.loginBtn.frame.width, height: kScreenHeight-self.loginBtn.frame.maxY-5), viewModel: self.viewModel,loginTypeExchange: {(type) in
            self.passTf.text = ""
            if type == "验证码" {
                self.passTf.attributedPlaceholder = NSAttributedString(string: "请输入验证码", attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
                self.passTf.frame.size = CGSize(width: (kScreenWidth-70)*2/3, height: 50)
                self.sendCodeBtn.isHidden = false
            } else {
                self.sendCodeBtn.stopCount()
                self.passTf.attributedPlaceholder = NSAttributedString(string: "请输入密码", attributes: [NSAttributedString.Key.foregroundColor : HEX_999])
                self.sendCodeBtn.isHidden = true
                self.passTf.frame.size = CGSize(width: kScreenWidth-70, height: 50)
            }
            })
        return view
    }()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.vc = self
        self.viewModel.navigationVC = self.navigationController
        initUI()
        bindModel()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        UINavigationBar.appearance().alpha = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        UINavigationBar.appearance().alpha = 0
    }
    
    //UI构造
    func initUI() {
        //登录页背景
        let bg = UIImageView(frame: UIScreen.main.bounds)
        bg.backgroundColor = HEX_FFF
        view.addSubview(bg)
        view.addSubview(headerView)
        view.addSubview(accountTf)
        view.addSubview(passTf)
        view.addSubview(sendCodeBtn)
        view.addSubview(loginBtn)
        view.addSubview(signupView)
        
        _ = sendCodeBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self]() in
            self!.sendCodeBtn.startCount()
        })
        
        
    }
    //数据绑定
    func bindModel() {
        let accountValid = accountTf.rx.text.orEmpty.map{$0.count == 11}.share(replay: 1)
        _ = accountTf.rx.text.subscribe(onNext: { [weak self](text) in
            self!.viewModel.accountStr = text ?? ""
            if (text?.count == 11) {
                self!.viewModel.getPlaceInfo()
            }
        })
        _ = accountTf.rx.text.orEmpty.flatMap { [weak self](string) -> Observable<Any> in
            if string.count > 11 {
                self!.accountTf.text = String(string.prefix(11))
                return Observable.just(string.prefix(11))
            }
            return Observable.just(string)
        }
        accountValid.bind(to: sendCodeBtn.rx.isEnabled).disposed(by: disposeBag)
        let passwordValid = passTf.rx.text.orEmpty.map{$0.count > 0}.share(replay: 1)
        _ = passTf.rx.text.subscribe(onNext: { [weak self](text) in
            self!.viewModel.passwordStr = text ?? ""
        })
        let everythingValid = Observable.combineLatest(accountValid,passwordValid){$0 && $1}.share(replay: 1)
        accountValid.bind(to: passTf.rx.isEnabled).disposed(by: disposeBag)
        everythingValid.bind(to: loginBtn.rx.isEnabled).disposed(by: disposeBag)
        loginBtn.rx.tap.subscribe(onNext: { [weak self] in
            self!.viewModel.login()
            }).disposed(by: disposeBag)
    }
    
    
}
