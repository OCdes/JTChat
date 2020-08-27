//
//  SubDepartmentVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/23.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class SubDepartmentVC: BaseViewController {
    var viewModel: ContactorViewModel = ContactorViewModel.init() {
        didSet {
            viewModel.subject.onNext("")
        }
    }
    lazy var tableView:ContactersTableView = {
        let tv = ContactersTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        tv.searchenable = false
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.navigationVC = self.navigationController
        initView()
        // Do any additional setup after loading the view.
    }
    
    func initView()  {
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
