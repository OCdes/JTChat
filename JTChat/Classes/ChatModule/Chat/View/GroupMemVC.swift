//
//  GroupMemVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/6.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class GroupMemVC: BaseViewController {
    var viewModel: GroupInfoViewModel = GroupInfoViewModel()
    lazy var tableView: GroupMemTableView = {
        let tv = GroupMemTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationVC = self.navigationController
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        // Do any additional setup after loading the view.
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
