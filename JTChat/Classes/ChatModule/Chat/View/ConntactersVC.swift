//
//  ConntactersVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import ALQRCode
open class ConntactersVC: BaseViewController  {
    var viewModel: ContactorViewModel = ContactorViewModel.init()
    lazy var tableView:ContactersTableView = {
        let tv = ContactersTableView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refreshData(scrollView: self.tableView)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系人"
        self.viewModel.typeEnable = false
        setNav()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    override func setNav() {
        super.setNav()
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(JTBundleTool.getBundleImg(with:"addFriend"), for: .normal)
        let _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](a) in
            let scan = ALScannerQRCodeVC.init()
            scan.scannerQRCodeDone = {[weak self](result) in
                if let rs = result,let phone = (rs as NSString).components(separatedBy: "_").first {
                    if JTManager.manager.addFriendSilence {
                        self!.viewModel.addFriend(friendNickname: nil, friendPhone: phone, friendAvatar: nil, remark: "", result: { (b) in
                        })
                    } else {
                        let model = ContactorModel()
                        model.phone = phone
                        let alertv = FriendAddAlertView.init(frame: CGRect.zero)
                        alertv.model = model
                        _ = alertv.sureSubject.subscribe { [weak self](a) in
                            self!.viewModel.addFriend(friendNickname: nil, friendPhone: phone, friendAvatar: nil, remark: a, result: { (b) in
                            })
                        }
                        alertv.show()
                    }
                }
            }
            self!.navigationController?.present(scan, animated: true, completion: nil)
        })
        let btnItem = UIBarButtonItem.init(customView: btn)
        navigationItem.setRightBarButton(btnItem, animated: true)
        
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    func bindModel() {
        viewModel.navigationVC = self.navigationController
        let _ = tableView.jt_addRefreshHeader {[weak self]() in
            self!.viewModel.refreshData(scrollView: self!.tableView)
        }
    }
    
    deinit {
        print("联系人销毁了")
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
