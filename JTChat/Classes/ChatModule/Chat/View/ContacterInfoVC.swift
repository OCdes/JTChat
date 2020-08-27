//
//  ContacterInfoVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class ContacterInfoVC: BaseViewController {
    var viewModel: ContactorInfoViewModel = ContactorInfoViewModel()
    lazy var tableView: ContactorInfoTableView = {
        let tv = ContactorInfoTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人信息"
        viewModel.navigationVC = self.navigationController
        initView()
        // Do any additional setup after loading the view.
        let _ = viewModel.subject.subscribe(onNext: { [weak self](b) in
            self!.tableView.viewModel = self!.viewModel
        })
        self.viewModel.getDetail()
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
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
