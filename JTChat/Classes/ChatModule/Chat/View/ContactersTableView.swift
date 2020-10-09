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
        let st = UITextField.init(frame: CGRect(x: 15, y: 10, width: kScreenWidth-30, height: 30))
        st.delegate = self
        st.layer.cornerRadius = 15
        st.backgroundColor = HEX_FFF
        let sv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
        sv.image = JTBundleTool.getBundleImg(with:"contacterSearch")
        let lv = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        sv.center = lv.center
        lv.addSubview(sv)
        st.leftView = lv
        st.leftViewMode = .always
        st.placeholder = "搜索"
        return st
    }()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ContactorViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        separatorStyle = .none
        backgroundColor = HEX_COLOR(hexStr: "#F5F6F8")
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
        let _ = viewModel?.subject.subscribe(onNext: { [weak self](a) in
            self?.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactersTableView: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
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
            titleString = viewModel!.pinyinArr[indexPath.section][indexPath.row].nickName
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
            let mm = ContactorInfoViewModel()
            mm.employeeModel = m
            let vc = ContacterInfoVC()
            vc.viewModel = mm
            viewModel?.navigationVC?.pushViewController(vc, animated: true)
        } else {
            if let m = viewModel?.sectionModel {
                if indexPath.row < m.employeeArr.count {
                    let mm = ContactorInfoViewModel()
                    mm.employeeModel = m.employeeArr[indexPath.row]
                    let vc = ContacterInfoVC()
                    vc.viewModel = mm
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
    
}

class ContactersTableCell: BaseTableCell {
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with:"groupicon")
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
