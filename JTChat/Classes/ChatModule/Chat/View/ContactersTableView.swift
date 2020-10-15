//
//  ContactersTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class ContactersTableView: UITableView {
    var viewModel: ContactorViewModel?
    var searchenable: Bool = true
    lazy var searchTf: UITextField = {
        let stf = UITextField()
        stf.textColor = HEX_333
        stf.textAlignment = .center
        let attach = NSTextAttachment.init()
        attach.image = JTBundleTool.getBundleImg(with: "search")!
        attach.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
        let att = NSMutableAttributedString.init(attachment: attach)
        att.append(NSAttributedString.init(string: "  搜索"))
        stf.attributedPlaceholder = att
        stf.delegate = self
        stf.backgroundColor = HEX_COLOR(hexStr: "#e1e1e1")
        stf.layer.cornerRadius = 7.5
        stf.layer.masksToBounds = true
        return stf
    }()
    lazy var headerV: UIView = {
        let hv = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 128))
        hv.backgroundColor = HEX_FFF
        hv.addSubview(self.searchTf)
        self.searchTf.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 84, right: 10))
        }
        
        let separatorLine = LineView.init(frame: CGRect.zero)
        hv.addSubview(separatorLine)
        separatorLine.snp_makeConstraints { (make) in
            make.left.right.equalTo(hv)
            make.top.equalTo(self.searchTf.snp_bottom).offset(10)
            make.height.equalTo(10)
        }
        
        let imgv = UIImageView()
        imgv.image = JTBundleTool.getBundleImg(with: "newFriendsApply")
        hv.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.left.equalTo(hv).offset(11.5)
            make.top.equalTo(separatorLine.snp_bottom).offset(13)
            make.size.equalTo(CGSize(width: 38, height: 38))
        }
        let titleLa = UILabel()
        titleLa.textColor = HEX_333
        titleLa.text = "新的朋友"
        hv.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(imgv.snp_right).offset(20)
            make.centerY.equalTo(imgv)
            make.right.equalTo(hv).offset(-42)
        }
        hv.addSubview(self.redDot)
        self.redDot.snp_makeConstraints { (make) in
            make.right.equalTo(hv).offset(-10)
            make.centerY.equalTo(titleLa)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(50)
            make.width.greaterThanOrEqualTo(16)
        }
        
        return hv
    }()
    lazy var redDot: UILabel = {
        let rd = UILabel()
        rd.layer.cornerRadius = 8
        rd.layer.masksToBounds = true
        rd.textColor = HEX_FFF
        rd.font = UIFont.systemFont(ofSize: 10)
        rd.textAlignment = .center
        rd.backgroundColor = UIColor.red
        rd.isHidden = true
        return rd
    }()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ContactorViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = HEX_COLOR(hexStr: "#F5F6F8")
        
        let btn = UIButton()
        btn.addTarget(self, action: #selector(goToApplyList), for: .touchUpInside)
        self.headerV.addSubview(btn)
        btn.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 74, left: 0, bottom: 0, right: 0))
        }
        
        register(ContactersTableCell.self, forCellReuseIdentifier: "ContactersTableCell")
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
            if #available(iOS 13.0, *) {
                automaticallyAdjustsScrollIndicatorInsets = true
            } else {
                // Fallback on earlier versions
            }
        }
        self.tableHeaderView = self.headerV
        let _ = viewModel?.subject.subscribe(onNext: { [weak self](a) in
            let count = self!.viewModel!.addApplyData.count
            if count > 0 {
                self!.redDot.isHidden = false
                self!.redDot.text = count > 99 ? "99+" : "\(count)"
            } else {
                self!.redDot.isHidden = true
            }
            self?.reloadData()
        })
    }
    
    @objc func goToApplyList() {
        let vc = AddFriendApplyVC.init()
        self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactersTableView: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (!viewModel!.typeChange) {
            return viewModel?.pinyinArr.count ?? 0
        } else {
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!viewModel!.typeChange) {
            let arr = viewModel!.pinyinArr[section]
            return arr.count
        } else {
            if let m = viewModel?.sectionModel {
                return m.employeeArr.count + m.subdepartmentArr.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ContactersTableCell = tableView.dequeueReusableCell(withIdentifier: "ContactersTableCell", for: indexPath) as! ContactersTableCell
        var portraitUrlString = ""
        var titleString = ""
        if viewModel!.typeChange {
            if let m = viewModel?.sectionModel {
                if indexPath.row < m.employeeArr.count {
                    portraitUrlString = m.employeeArr[indexPath.row].avatarUrl
                    titleString = m.employeeArr[indexPath.row].nickName
                    if portraitUrlString.count > 0 {
                        cell.portraitV.kf.setImage(with: URL.init(string: portraitUrlString), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                    } else {
                        cell.portraitV.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
                    }
                } else {
                    //                portraitUrlString = m.subdepartmentArr[indexPath.row - m.employeeArr.count].
                    titleString = m.subdepartmentArr[indexPath.row - m.employeeArr.count].departmentName
                }
            }
        } else {
            let mm = viewModel!.pinyinArr[indexPath.section][indexPath.row]
            titleString = mm.nickName
            cell.portraitV.kf.setImage(with: URL(string: mm.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
        }
        cell.titleLa.text = titleString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !viewModel!.typeChange {
            return viewModel!.indexTitles
        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !viewModel!.typeChange {
            let v: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
            let la: UILabel = UILabel.init(frame: CGRect(x: 15, y: 0, width: frame.width, height: 30))
            la.textColor = HEX_333
            la.font = UIFont.systemFont(ofSize: 12)
            la.text = viewModel!.indexTitles[section]
            v.addSubview(la)
            return v
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !viewModel!.typeChange {
            return 30
        } else {
            return 0.01
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !viewModel!.typeChange {
            let m = viewModel!.pinyinArr[indexPath.section][indexPath.row]
            let vc = ContacterInfoVC()
            vc.viewModel.employeeModel.phone = m.phone
            vc.viewModel.employeeModel.avatarUrl = m.avatarUrl
            vc.viewModel.employeeModel.nickName = m.nickName
            vc.viewModel.employeeModel.aliasName = m.aliasName
            viewModel?.navigationVC?.pushViewController(vc, animated: true)
        } else {
            if let m = viewModel?.sectionModel {
                if indexPath.row < m.employeeArr.count {
                    let mm = m.employeeArr[indexPath.row]
                    let vc = ContacterInfoVC()
                    vc.viewModel.employeeModel.phone = mm.phone
                    vc.viewModel.employeeModel.avatarUrl = mm.avatarUrl
                    vc.viewModel.employeeModel.nickName = mm.nickName
                    vc.viewModel.employeeModel.aliasName = mm.aliasName
                    viewModel?.navigationVC?.pushViewController(vc, animated: true)
                } else {
                    let mm = ContactorViewModel()
                    mm.sectionModel = m.subdepartmentArr[indexPath.row-m.employeeArr.count]
                    let vc = SubDepartmentVC.init()
                    vc.viewModel = mm
                    vc.title = mm.sectionModel.departmentName
                    viewModel?.navigationVC?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.viewModel?.navigationVC?.pushViewController(ContactorResultVC(), animated: true)
        return false
    }
    
}

class ContactersTableCell: BaseTableCell {
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 19
        pv.layer.masksToBounds = true
        return pv
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        return tl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(11.5)
            make.top.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-13)
            make.width.equalTo(portraitV.snp_height)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(20)
            make.centerY.equalTo(portraitV)
            make.right.equalTo(contentView).offset(-12)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.equalTo(titleLa)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
