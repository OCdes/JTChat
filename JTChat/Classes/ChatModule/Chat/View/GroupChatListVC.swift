//
//  GroupChatListVC.swift
//  JTChat
//
//  Created by jingte on 2022/3/7.
//

import UIKit

class GroupChatListVC: BaseViewController {
    var viewModel: GroupListViewModel = GroupListViewModel()
    lazy var tableView: GroupChatListView = {
        let tv = GroupChatListView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.navigationVC = self.navigationController
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        _ = self.tableView.jt_addRefreshHeader(handler: {
            self.viewModel.getAllRecentContactor(scrollView: self.tableView)
        })
        self.tableView.jt_startRefresh()
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
