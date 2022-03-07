//
//  ChatVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import SnapKit
class ChatVC: BaseViewController,InputToolViewDelegate {
    
    var viewModel: ChatViewModel = ChatViewModel()
    lazy var bgImgv: UIImageView = {
        let bgv = UIImageView.init(frame: self.view.bounds)
        bgv.contentMode = .scaleAspectFill
        bgv.clipsToBounds = true
        return bgv
    }()
    fileprivate lazy var tableView: ChatTableView = {
        let tv = ChatTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()

    lazy var toolView: BottomInputView = {
        let tv = BottomInputView.init(frame: CGRect.zero, viewModel: self.viewModel)
        tv.delegate = self
        return tv
    }()
    var previousOffsetY: CGFloat = 0
    var bottomConstrait: Constraint?
    var toolBottomConstrait: Constraint?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.clearRedPot()
        if let gid = viewModel.contactor?.topicGroupID, gid.count > 0 {
            self.bgImgv.image = viewModel.getChatViewBG(forID: gid)
        } else {
            self.bgImgv.image = viewModel.getChatViewBG(forID: viewModel.contactor?.phone ?? "")
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.clearRedPot()
        self.tableView.recordManager.stopPlayAudio(by: "")
        self.tableView.previousImgv?.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        USERDEFAULT.removeObject(forKey: "currentID")
        super.viewDidAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindModel()
        setNavItem()
        // Do any additional setup after loading the view.
    }
    
    func setNavItem() {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(JTBundleTool.getBundleImg(with:"whiteMore"), for: .normal)
        let _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](a) in
            if self!.viewModel.contactor!.topicGroupID.count > 0 {
                let vc = GroupInfoVC()
                vc.viewModel.groupID = self!.viewModel.contactor!.topicGroupID
                vc.viewModel.isFromChat = true
                vc.title = self!.title
                self!.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else {
                let mm = ContactorInfoViewModel()
                mm.employeeModel.phone = self!.viewModel.contactor!.phone
                let vc = ContacterInfoVC()
                vc.viewModel = mm
                vc.viewModel.isFromChat = true
                vc.title = self!.title
                self!.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        })
        let btnItem = UIBarButtonItem.init(customView: btn)
        navigationItem.setRightBarButton(btnItem, animated: true)
    }

    func initView() {
        view.backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_COLOR(hexStr: "#EBEBEB");
        view.addSubview(bgImgv)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(view).offset(-62-(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? 34 : 0) : 0))
        }
        view.addSubview(toolView)
        toolView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.tableView.snp_bottom)
            make.bottom.equalTo(view).offset(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? -34 : 0) : 0)
        }
    }

    func bindModel() {
        viewModel.navigationVC = self.navigationController
        if let m = self.viewModel.contactor {
            if m.topicGroupID.count > 0 {
                if m.topicGroupName.count > 0 {
                    self.title = m.topicGroupName
                }
                USERDEFAULT.set(m.topicGroupID, forKey: "currentID")
            } else {
                self.title = m.aliasName.count > 0 ? m.aliasName : m.nickName
                USERDEFAULT.set(m.phone, forKey: "currentID")
            }
        }
        self.toolView.viewModel = viewModel
        let _ = self.tableView.jt_addRefreshHeaderWithNoText { [weak self]() in
            self!.viewModel.page += 1
            self!.viewModel.refreshData(scrollView: self!.tableView)
        }
        self.viewModel.refreshData(scrollView: self.tableView)

        let _ = self.tableView.tapSubject.subscribe(onNext: { [weak self](a) in
            self!.toolView.resignActive()
        })
    }

    func keyboardChangeFrame(inY: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.tableView.snp_updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(-62-inY);
            }
            self.view.layoutIfNeeded()
        }
        self.toolView.snp_updateConstraints { (make) in
            make.bottom.equalTo(self.view)
        }
        self.tableView.reloadData()
    }

    func keyboardHideFrame(inY: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.snp_updateConstraints { (make) in
                make.bottom.equalTo(self.view).offset(-62-inY)
            }
            self.view.layoutIfNeeded()
        }
        self.toolView.snp_updateConstraints { (make) in
            make.bottom.equalTo(self.view).offset(JTManager.manager.isHideBottom ? (kiPhoneXOrXS ? -34 : 0) : 0)
        }
        self.tableView.reloadData()
    }
    
    func needAtSomeOne(atRange: NSRange) {
        self.toolView.textV.resignFirstResponder()
        let vc = SelectGroupMemVC()
        vc.viewModel.groupID = self.viewModel.contactor!.topicGroupID
        _ = vc.subject.subscribe(onNext: { [weak self](arr) in
            var selera = atRange
            if arr.count == 1 {
                let m = arr[0]
                let ra = NSRange(location: atRange.location, length: m.nickname.count+1)
                selera = NSRange(location: ra.location+ra.length, length: 0)
                var text = String(self!.toolView.textV.text ?? "")
                text.insert(contentsOf: "\(m.nickname) ", at: text.index(text.startIndex, offsetBy: atRange.location))
                self?.toolView.textV.text = text
                self!.viewModel.addRange(range:ra, addPhone: "@\(m.memberPhone)", addName: m.nickname)
            } else {
                let ra = NSRange(location: atRange.location, length: "所有人".count+1)
                selera = NSRange(location: ra.location+ra.length, length: 0)
                var text = String(self!.toolView.textV.text ?? "")
                text.insert(contentsOf: "\("所有人") ", at: text.index(text.startIndex, offsetBy: atRange.location))
                self?.toolView.textV.text = text
                self!.viewModel.addRange(range:ra, addPhone: "@\(self!.viewModel.contactor!.topicGroupID)", addName: "所有人")
            }
            self?.toolView.textV.selectedRange = selera
            self?.toolView.textV.becomeFirstResponder()
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        
        print("聊天销毁了")
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
