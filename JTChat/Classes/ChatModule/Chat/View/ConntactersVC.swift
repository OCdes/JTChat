//
//  ConntactersVC.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import ALQRCode
open class ConntactersVC: BaseViewController  {
    var viewModel: ContactorViewModel = ContactorViewModel.init()
    lazy var tableView:ContactersTableView = {
        let tv = ContactersTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "联系人"
        setNav()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    override func setNav() {
        super.setNav()
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btn.setImage(UIImage(named: "addFriend"), for: .normal)
        let _ = btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self](a) in
            let scan = ALScannerQRCodeVC.init()
            scan.scannerQRCodeDone = {[weak self](result) in
                self!.viewModel.addFriend()
            }
            self!.navigationController?.present(scan, animated: true, completion: nil)
        })
        let btnItem = UIBarButtonItem.init(customView: btn)
        navigationItem.setRightBarButton(btnItem, animated: true)
        
    }
    
    func initView() {
        view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func bindModel() {
        viewModel.navigationVC = self.navigationController
        let _ = tableView.jt_addRefreshHeader {
            self.viewModel.refreshData(scrollView: self.tableView)
        }
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
