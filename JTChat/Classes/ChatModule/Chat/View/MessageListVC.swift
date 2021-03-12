//
//  MessageListVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import ALQRCode
import AVFoundation
open class MessageListVC: BaseViewController {
    open var viewModel: MessageViewModel = MessageViewModel()
    lazy var scrollView: RecentDialogView = {
        let tv = RecentDialogView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: (kScreenHeight-49-45-(kScreenHeight>=750 ? 122 : 64))), viewModel: self.viewModel)
        return tv
    }()
    var previousBtn: UIButton?
    var perBtn: UIButton?
    var groupBtn: UIButton?
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.getAllRecentContactor(scrollView: self.scrollView)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        setNav()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
//        self.viewModel.subject.onNext("")
        self.viewModel.getAllRecentContactor(scrollView: self.scrollView)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func setNav() {
        super.setNav()
        let addBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        addBtn.setImage(JTBundleTool.getBundleImg(with:"addCircle"), for: .normal)
        let _ = addBtn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](a) in
            let alert = DialogAlertView.init(frame: CGRect.zero)
            _ = alert.subject.subscribe(onNext: { (i) in
                switch i {
                case 0:
                    let vc = GroupChatSelectVC.init()
                    vc.viewModel.navigationVC = self?.navigationController
                    self?.present(vc, animated: true, completion: nil)
                    
                case 1:
                    let status = AVCaptureDevice.authorizationStatus(for: .video)
                    if status != .denied {
                        let scan = ALScannerQRCodeVC.init()
                        scan.scannerQRCodeDone = {[weak self](result) in
                            if let rs = result, rs.count > 0 {
                                if JTManager.manager.isSafeQrCode {
                                    self?.viewModel.getInfoOf(qrContent: rs, result: { (cinfo) in
                                        if cinfo.isFriend {
                                            SVPShowError(content: "\(cinfo.nickName)已是您的好友")
                                        } else {
                                            if JTManager.manager.addFriendSilence {
                                                self!.viewModel.addFriend(friendNickname: cinfo.nickName, friendPhone: cinfo.phone, friendAvatar: cinfo.avatarUrl, remark: "", result: { (b) in
                                                })
                                            } else {
                                                let alertv = FriendAddAlertView.init(frame: CGRect.zero)
                                                alertv.model = cinfo
                                                _ = alertv.sureSubject.subscribe { [weak self](a) in
                                                    self!.viewModel.addFriend(friendNickname: cinfo.aliasName, friendPhone: cinfo.phone, friendAvatar: cinfo.avatarUrl, remark: a, result: { (b) in
                                                    })
                                                }
                                                alertv.show()
                                            }
                                        }
                                        
                                    })
                                } else {
                                    if let phone = (rs as NSString).components(separatedBy: "_").first {
                                        self?.viewModel.getInfoOf(qrContent: phone, result: { (cinfo) in
                                            if cinfo.isFriend {
                                                SVPShowError(content: "\(cinfo.nickName)已是您的好友")
                                            } else {
                                                if JTManager.manager.addFriendSilence {
                                                    self!.viewModel.addFriend(friendNickname: cinfo.nickName, friendPhone: phone, friendAvatar: cinfo.avatarUrl, remark: "", result: { (b) in
                                                    })
                                                } else {
                                                    let model = ContactInfoModel()
                                                    model.phone = phone
                                                    let alertv = FriendAddAlertView.init(frame: CGRect.zero)
                                                    alertv.model = cinfo
                                                    _ = alertv.sureSubject.subscribe { [weak self](a) in
                                                        self!.viewModel.addFriend(friendNickname: nil, friendPhone: phone, friendAvatar: nil, remark: a, result: { (b) in
                                                        })
                                                    }
                                                    alertv.show()
                                                }
                                            }
                                            
                                        })
                                    }
                                }
                            }
                        }
                        self?.navigationController?.present(scan, animated: true, completion: nil)
                    } else {
                        let alertvc = UIAlertController(title: "提示", message: "您的相机权限未开启，请开启权限以扫描二维码以添加好友", preferredStyle: .alert)
                        alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
                        let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                            let url = URL(string: UIApplication.openSettingsURLString)
                            if let u = url, UIApplication.shared.canOpenURL(u) {
                                UIApplication.shared.open(u, options: [:], completionHandler: nil)
                            }
                        }
                        alertvc.addAction(sureAction)
                        self?.navigationController?.present(alertvc, animated: true, completion: nil)
                    }
                default: break
                    
                }
            })
            alert.show()
        })
        
        let addItem = UIBarButtonItem.init(customView: addBtn)
        navigationItem.setRightBarButton(addItem, animated: true)
    }
    
    func initView() {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth/2, height: 45))
        btn.setImage(JTBundleTool.getBundleImg(with:"createMessage"), for: .normal)
        btn.setImage(JTBundleTool.getBundleImg(with:"createMessageSelected"), for: .selected)
        btn.setTitle("    聊天", for: .normal)
        btn.setTitleColor(HEX_COLOR(hexStr: "#4F525B"), for: .normal)
        btn.setTitleColor(HEX_LightBlue, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(personalBtnClicked(btn:)), for: .touchUpInside)
        self.perBtn = btn
        previousBtn = btn
        view.addSubview(btn)
        let btn2 = UIButton.init(frame: CGRect(x: kScreenWidth/2, y: 0, width: kScreenWidth/2, height: 45))
        btn2.setImage(JTBundleTool.getBundleImg(with:"createGroup"), for: .normal)
        btn2.setImage(JTBundleTool.getBundleImg(with:"createMessageSelected"), for: .selected)
        btn2.setTitle("    群聊", for: .normal)
        btn2.setTitleColor(HEX_COLOR(hexStr: "#4F525B"), for: .normal)
        btn2.setTitleColor(HEX_LightBlue, for: .selected)
        btn2.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn2.addTarget(self, action: #selector(groupBtnClicked(btn:)), for: .touchUpInside)
        self.groupBtn = btn2
        view.addSubview(btn2)
        let line = LineView.init(frame: CGRect(x: kScreenWidth/2-1, y: 15, width: 1, height: 15))
        view.addSubview(line)
        view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: btn.frame.maxY, left: 0, bottom: 0, right: 0))
        }
    }
    
    func bindModel() {
        viewModel.navigationVC = self.navigationController
        
        _ = viewModel.rx.observe(Int.self, "perNum").subscribe(onNext: { [weak self](num) in
            if let n = num {
                self!.perBtn?.setTitle(n > 0 ? "    聊天(\(n))" : "    聊天", for: .normal)
            }
        })
        _ = viewModel.rx.observe(Int.self, "groupNum").subscribe(onNext: { [weak self](num) in
            if let n = num {
                self!.groupBtn?.setTitle(n > 0 ? "    群聊(\(n))" : "    群聊", for: .normal)
            }
        })
        
    }
    
    @objc func personalBtnClicked(btn: UIButton) {
        previousBtn?.isSelected = false
        if !btn.isSelected {
            btn.isSelected = true
            previousBtn = btn
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    @objc func groupBtnClicked(btn: UIButton) {
        previousBtn?.isSelected = false
        if !btn.isSelected {
            btn.isSelected = true
            previousBtn = btn
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: kScreenWidth, y: 0)
            }
        }
        
    }
    
    deinit {
        print("MessageListVC 销毁了")
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
