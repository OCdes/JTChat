//
//  ChatVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import SnapKit
class ChatVC: BaseViewController, InputToolViewDelegate {
    var viewModel: ChatViewModel = ChatViewModel()
    lazy var tableView: ChatTableView = {
        let tv = ChatTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()

    lazy var toolView: InputToolView = {
        let tv = InputToolView.init(frame: CGRect.zero, viewModel: self.viewModel)
        tv.delegate = self
        return tv
    }()
    var previousOffsetY: CGFloat = 0
    var bottomConstrait: Constraint?
    var toolBottomConstrait: Constraint?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let m = self.viewModel.contactor {
            if m.topicGroupID.count > 0 {
                let cm = DBManager.manager.getRecent(byPhone: nil, byTopicID: m.topicGroupID)
                self.title = cm.topicGroupName
            } else {
                let cm = DBManager.manager.getRecent(byPhone: m.phone, byTopicID: nil)
                self.title = cm.nickname
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
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
                vc.title = self!.title
                self!.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else {
                let mm = ContactorInfoViewModel()
                mm.employeeModel.phone = self!.viewModel.contactor!.phone
                let vc = ContacterInfoVC()
                vc.viewModel = mm
                vc.title = self!.title
                self!.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        })
        let btnItem = UIBarButtonItem.init(customView: btn)
        navigationItem.setRightBarButton(btnItem, animated: true)
    }

    func initView() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            self.bottomConstrait = make.bottom.equalTo(view).offset(kiPhoneXOrXS ? -96 : -62).constraint
        }
        view.addSubview(toolView)
        toolView.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.tableView.snp_bottom)
            self.toolBottomConstrait = make.bottom.equalTo(view).constraint
        }
    }

    func bindModel() {
        viewModel.navigationVC = self.navigationController
        self.toolView.viewModel = viewModel
        let _ = self.tableView.jt_addRefreshHeaderWithNoText {
            self.viewModel.page += 1
            self.viewModel.refreshData(scrollView: self.tableView)
        }
        self.viewModel.refreshData(scrollView: self.tableView)

        let _ = self.tableView.tapSubject.subscribe(onNext: { [weak self](a) in
            self!.toolView.resignActive()
        })
    }

    func keyboardChangeFrame(inY: CGFloat) {
        self.bottomConstrait?.updateOffset(amount:  -62-inY)
        self.tableView.scrollTo(offsetY: -(inY-previousOffsetY), animated: true)
        previousOffsetY = inY
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
