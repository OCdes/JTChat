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
    var moreBtn: UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(JTBundleTool.getBundleImg(with: "whiteMore"), for: .normal)
        btn.isHidden = true
        return btn
    }()
    lazy var tableView: ContactorInfoTableView = {
        let tv = ContactorInfoTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人信息"
        viewModel.navigationVC = self.navigationController
        initView()
        bindModel()
        // Do any additional setup after loading the view.
        self.viewModel.getDetail()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.moreBtn)
    }
    
    
    
    @objc func moreBtnClicked() {
        let vc = UIAlertController.init()
        let deleAction = UIAlertAction.init(title: "删除好友", style: .destructive) { [weak self](act) in
            self!.viewModel.deletFriend(friendPhone: self!.viewModel.employeeModel.phone)
        }
        vc.addAction(deleAction)
        let cancleAction = UIAlertAction.init(title: "取消", style: .cancel) { (act) in
            
        }
        vc.addAction(cancleAction)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func initView() {
        self.moreBtn.addTarget(self, action: #selector(moreBtnClicked), for: .touchUpInside)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func bindModel() {
        self.viewModel.navigationVC = self.navigationController
        _ = self.viewModel.subject.subscribe { [weak self](a) in
            self!.tableView.viewModel = self!.viewModel
            if JTManager.manager.phone == self?.viewModel.employeeModel.phone {
                self!.moreBtn.isHidden = false
            } else {
                self!.moreBtn.isHidden = !self!.viewModel.employeeModel.isFriend
            }
            
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
