//
//  ContactorResultVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/12.
//

import UIKit

class ContactorResultVC: BaseViewController {
    var viewModel: ContactorResultViewModel = ContactorResultViewModel()
    lazy var tableView: ContactorResultTableView = {
        let tv = ContactorResultTableView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    lazy var searchTf: UITextField = {
        let st = UITextField.init(frame: CGRect(x: 10, y: 4.5, width: kScreenWidth-80, height: 35))
        st.backgroundColor = HEX_FFF
        st.layer.cornerRadius = 7.5
        st.layer.masksToBounds = true
        st.layer.borderColor = HEX_COLOR(hexStr: "#e1e1e1").cgColor
        st.layer.borderWidth = 0.3
        st.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        st.leftViewMode = .always
        st.placeholder = "搜索"
        return st
    }()
    lazy var cancleBtn: UIButton = {
        let cb = UIButton.init(frame: CGRect(x: kScreenWidth-60, y: 4.5, width: 50, height: 40))
        cb.setTitle("取消", for: .normal)
        cb.setTitleColor(HEX_FFF, for: .normal)
        cb.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cb.addTarget(self, action: #selector(cancleBtnClicked), for: .touchUpInside)
        return cb
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(self.searchTf)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchTf.removeFromSuperview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchTf.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNav()
        initView()
        bindModel()
        // Do any additional setup after loading the view.
    }
    
    override func setNav() {
//        super.setNav()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.cancleBtn)
    }

    @objc func cancleBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView() {
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func bindModel() {
        self.viewModel.navigationVC = self.navigationController
        let _ = self.searchTf.rx.text.subscribe { [weak self](str) in
            let keystr = str ?? ""
            print("搜索关键字\(keystr)")
            self!.viewModel.key = keystr
            if self!.viewModel.key.count > 0 {
                self?.tableView.jt_startRefresh()
            }
        } onError: { (err) in
            
        } onCompleted: {
            
        } onDisposed: {
            
        }

        let _ = tableView.jt_addRefreshHeader {[weak self]() in
            self!.viewModel.search(scrollView: self!.tableView)
        }
    }

    deinit {
        print("搜索页销毁了")
    }
    
}
