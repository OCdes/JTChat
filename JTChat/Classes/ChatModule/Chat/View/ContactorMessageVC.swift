//
//  ContactorMessageVC.swift
//  JTChat
//
//  Created by jingte on 2022/3/7.
//

import UIKit

open class ContactorMessageVC: BaseViewController {
    open var viewModel: ContactorMessageViewModel = ContactorMessageViewModel()
    lazy var scrollView: ContactorMessageTableView = {
        let tv = ContactorMessageTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息"
        self.viewModel.navigationVC = self.navigationController
        setNav()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = self.scrollView.jt_addRefreshHeader {
            self.viewModel.getAllRecentContactor(scrollView: self.scrollView)
        }
        
        self.scrollView.jt_startRefresh()
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
                default:
                    let vc = SearchVC()
                    self?.navigationController?.pushViewController(vc, animated: true)
                    break
                }
            })
            alert.show()
        })
        
        let addItem = UIBarButtonItem.init(customView: addBtn)
        navigationItem.setRightBarButton(addItem, animated: true)
    }
}
