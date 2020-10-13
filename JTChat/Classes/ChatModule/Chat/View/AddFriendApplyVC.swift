//
//  AddFriendApplyVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit

class AddFriendApplyVC: BaseViewController {
    var viewModel: AddFriendApplyViewModel = AddFriendApplyViewModel()
    lazy var tableView: AddFriendTableView = {
        let tv = AddFriendTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "申请列表"
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        _ = self.tableView.jt_addRefreshHeader { [weak self]() in
            self!.viewModel.refreshData(scrollView: self!.tableView)
        }
        self.tableView.jt_startRefresh()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("申请列表销毁了")
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
