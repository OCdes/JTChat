//
//  GroupInfoVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/5.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class GroupInfoVC: BaseViewController {
    var viewModel: GroupInfoViewModel = GroupInfoViewModel()
    lazy var tableView: GroupInfoTableView = {
        let tv = GroupInfoTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        viewModel.navigationVC = self.navigationController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
    }

}
