//
//  GroupChatSelectVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/4.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class GroupChatSelectVC: BaseViewController {
    var viewModel: GroupSelectViewModel = GroupSelectViewModel()
    lazy var tableView: GroupSelectListView = {
        let tv = GroupSelectListView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    lazy var seleView: GeneralSelectView = {
        let sv = GeneralSelectView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 45))
        return sv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    func initView() {
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        view.addSubview(seleView)
        self.seleView.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(self.tableView.snp_bottom)
        }
    }
    
    func bindModel() {
        self.viewModel.refreshData()
        _ = self.tableView.selectSubject.subscribe(onNext: { [weak self](a) in
            self!.tableView.snp_updateConstraints { (make) in
                make.bottom.equalTo(self!.view).offset((kiPhoneXOrXS ? -84 : -50))
            }
            self!.seleView.dataArr = self!.viewModel.seleDataArr
        })
        
        _ = self.seleView.deSelectSubject.subscribe(onNext: { [weak self](a) in
            self!.viewModel.selePhones = self!.seleView.selectIDArr ?? []
            self!.viewModel.dealData()
            self!.tableView.dataArr = self!.viewModel.dataArr
        })
        
        _ = self.seleView.sureSubject.subscribe(onNext: { (arr) in
            self.viewModel.creatGroup()
        })
        
        _ = self.viewModel.doneSubject.subscribe(onNext: { (a) in
            self.dismiss(animated: true, completion: nil)
            let cm = ContactorModel()
            cm.topicGroupID = self.viewModel.topicGroupID
            let vc = ChatVC()
            vc.viewModel.contactor = cm
            vc.title = self.viewModel.topicGroupName
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        })
    }

}
