//
//  SignUpVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/17.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
class SignUpVC: BaseViewController {
    var viewModel: SignInViewModel = SignInViewModel()
    lazy var accountIDTf: AccountView = {
        var tf = AccountView(frame: CGRect(x: 36, y: 112, width: kScreenWidth-72, height: 44), viewModel: self.viewModel)
        tf.placeholderStr = "请输入场所商户号"
        return tf
    }()
    lazy var shopNameTf: AccountView = {
        var tf = AccountView(frame: CGRect(x: self.accountIDTf.frame.minX, y: self.accountIDTf.frame.maxY + 11, width: self.accountIDTf.frame.width, height: self.accountIDTf.frame.height), viewModel: self.viewModel)
        tf.placeholderStr = "商户信息"
        tf.isEnabled = false
        return tf
    }()
    lazy var phoneTf: AccountView = {
        var tf = AccountView(frame: CGRect(x: self.shopNameTf.frame.minX, y: self.shopNameTf.frame.maxY + 11, width: self.shopNameTf.frame.width, height: self.shopNameTf.frame.height), viewModel: self.viewModel)
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
    //验证码发送按钮
     lazy var sendCodeBtn: CountDownBtn = {
         var btn = CountDownBtn(frame: CGRect(x: (kScreenWidth-72)*2/3+46, y: self.verifyCodeTf.frame.minY, width: (kScreenWidth-72)/3-10, height: self.verifyCodeTf.frame.height), countSeconds: 60)
         return btn
     }()
     
    //注册按钮
     lazy var registBtn : LoginBtn = {
        let btn = LoginBtn.init(frame: CGRect(x: self.passTf.frame.origin.x, y: self.passTf.frame.maxY + 33, width: self.passTf.frame.width, height: 44), viewModel: self.viewModel)
        btn.setTitle("同意协议并注册", for: .normal)
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
        self.title = "新用户注册"
        view.backgroundColor = HEX_COLOR(hexStr: "#312F34")
        view.addSubview(self.accountIDTf)
        view.addSubview(self.shopNameTf)
        view.addSubview(self.phoneTf)
        view.addSubview(self.verifyCodeTf)
        view.addSubview(self.sendCodeBtn)
        view.addSubview(self.passTf)
        view.addSubview(self.registBtn)
        let la: UILabel = UILabel(frame: CGRect(x: self.registBtn.frame.minX, y: self.registBtn.frame.maxY + 10, width: self.registBtn.frame.width, height: 12))
        la.font = UIFont.systemFont(ofSize: 12)
        la.textColor = HEX_999
        let str: String = "已阅读并同意以下协议" + "《精特娱汇服务协议》"
        let attriStr: NSMutableAttributedString = NSMutableAttributedString(string: str)
        attriStr.addAttributes([NSAttributedString.Key.foregroundColor : HEX_COLOR(hexStr: "#2E96F7")], range: (str as NSString).range(of: "《精特娱汇服务协议》"))
        la.attributedText = attriStr
        la.isUserInteractionEnabled = true
        view.addSubview(la)
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: la.frame.width, height: la.frame.height))
        la.addSubview(btn)
        _ = btn.rx.controlEvent(.touchUpInside).subscribe { () in
            
        }
    }
    
    func bindModel() {
        _ = self.viewModel.rx.observeWeakly(String.self, "shopNameStr").subscribe(onNext: { [weak self](value) in
            self!.shopNameTf.text = value
        })
        
        let placeIDValid = accountIDTf.rx.text.orEmpty.map{$0.count>0}.share(replay: 1)
        
       _ =  accountIDTf.rx.controlEvent(.editingDidEnd).asObservable().subscribe(onNext: { [weak self](string) in
        self!.viewModel.accountStr = self!.accountIDTf.text ?? ""
        self?.viewModel.getPlaceInfoByID()
        })
        
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
        
        let registerValid = Observable.combineLatest(placeIDValid, phoneValid, verifyValid, passValid){($0 && $1) && ($2 && $3)}.share(replay: 1)
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
            self.viewModel.signUp()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
