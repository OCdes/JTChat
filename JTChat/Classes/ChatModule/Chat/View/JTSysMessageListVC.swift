//
//  JTSysMessageListVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/3/11.
//

import UIKit

class JTSysMessageListVC: BaseViewController {
    var viewModel: JTSysMessageListViewModel = JTSysMessageListViewModel()
    lazy var tableView: JTSysMessageListView = {
        let tv = JTSysMessageListView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息列表"
        // Do any additional setup after loading the view.
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
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
