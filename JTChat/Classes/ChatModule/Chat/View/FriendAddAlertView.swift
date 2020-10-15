//
//  FriendAddAlertView.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit
import RxSwift
class FriendAddAlertView: UIView {
    var model: ContactInfoModel = ContactInfoModel() {
        didSet {
            portraitv.kf.setImage(with: URL(string: model.avatarUrl) ,placeholder: JTBundleTool.getBundleImg(with: "approvalPortrait"))
            nameLa.text = model.nickName.count>0 ? model.nickName : model.phone
        }
    }
    var sureSubject = PublishSubject<String>()
    private var portraitv: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 25
        pv.layer.masksToBounds = true
        return pv
    }()
    private var nameLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_333
        nl.font = UIFont.systemFont(ofSize: 16)
        return nl
    }()
    private var remarkTv: UITextView = {
        let rt = UITextView()
        rt.layer.borderColor = HEX_999.cgColor
        rt.layer.borderWidth = 1
        rt.textColor = HEX_333
        rt.layer.cornerRadius = 5
        rt.layer.masksToBounds = true
        rt.font = UIFont.systemFont(ofSize: 14)
        return rt
    }()
    private var bgV: UIView = {
        let bv = UIView.init(frame: UIScreen.main.bounds)
        bv.backgroundColor = HEX_333.withAlphaComponent(0.3)
        return bv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: kScreenWidth-50, height: 235)
        self.backgroundColor = HEX_FFF
        self.layer.cornerRadius = 10
        self.center = APPWINDOW.center
        let titleLa = UILabel()
        titleLa.textColor = HEX_333
        titleLa.font = UIFont.systemFont(ofSize: 16)
        titleLa.textAlignment = .center
        titleLa.text = "您将添加以下好友"
        addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(44)
        }
        
        addSubview(portraitv)
        portraitv.snp_makeConstraints { (make) in
            make.centerY.equalTo(self).offset(-40)
            make.left.equalTo(self).offset(20)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.centerY.equalTo(portraitv)
            make.left.equalTo(portraitv.snp_right).offset(10)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(30)
        }
        
        let noteLa = UILabel()
        noteLa.text = "请输入验证信息(可选):"
        noteLa.textColor = HEX_999
        noteLa.font = UIFont.systemFont(ofSize: 14)
        addSubview(noteLa)
        noteLa.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(portraitv.snp_bottom).offset(7)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(25)
        }
        
        addSubview(remarkTv)
        remarkTv.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(noteLa.snp_bottom)
            make.height.equalTo(35)
        }
        let btnwidth = self.frame.width/2
        let cancleBtn = UIButton()
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(HEX_333, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancleBtn.addTarget(self, action: #selector(hide), for: .touchUpInside)
        addSubview(cancleBtn)
        cancleBtn.snp_makeConstraints { (make) in
            make.left.bottom.equalTo(self)
            make.size.equalTo(CGSize(width: btnwidth, height: 45))
        }
        
        let sureBtn = UIButton()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(HEX_FFF, for: .normal)
        sureBtn.backgroundColor = HEX_LightBlue
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        sureBtn.addTarget(self, action: #selector(sureBtnClicked), for: .touchUpInside)
        addSubview(sureBtn)
        sureBtn.snp_makeConstraints { (make) in
            make.right.bottom.equalTo(self)
            make.size.equalTo(cancleBtn)
        }
        self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
    }
    
    @objc func sureBtnClicked() {
        self.hide()
        self.sureSubject.onNext(self.remarkTv.text ?? "")
    }
    
    func show() {
        APPWINDOW.addSubview(bgV)
        APPWINDOW.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc private func hide() {
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        } completion: { (true) in
            self.removeFromSuperview()
            self.bgV.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
