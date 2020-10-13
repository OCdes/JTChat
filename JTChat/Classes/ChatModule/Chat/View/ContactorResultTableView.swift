//
//  ContactorResultTableView.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/13.
//

import UIKit

class ContactorResultTableView: BaseTableView {
    var dataArr: Array<ContactorModel> = []
    var viewModel: ContactorResultViewModel?
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ContactorResultViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        register(ContactersTableCell.self, forCellReuseIdentifier: "ContactersTableCell")
        _ = viewModel!.rx.observe(Array<Any>.self, "dataArr").subscribe(onNext: { [weak self](arr) in
            self!.dataArr = (arr ?? []) as! Array<ContactorModel>
            self!.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactorResultTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactersTableCell = tableView.dequeueReusableCell(withIdentifier: "ContactersTableCell", for: indexPath) as! ContactersTableCell
        let m = dataArr[indexPath.row]
        cell.portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
        cell.titleLa.text = m.nickName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.row]
        let vc = ContacterInfoVC()
        vc.viewModel.employeeModel = m
        self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
    }
    
}

