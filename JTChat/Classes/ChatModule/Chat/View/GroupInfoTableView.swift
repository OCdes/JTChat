//
//  GroupInfoTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/5.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class GroupInfoTableView: BaseTableView {
    var dataArr: Array<String> = ["群聊名称","群成员","","添加成员","群管理","退出群聊"]
    var viewModel: GroupInfoViewModel = GroupInfoViewModel()
    var model: GroupInfoModel = GroupInfoModel()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupInfoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        separatorStyle = .none
        delegate = self
        dataSource = self
        backgroundColor = HEX_F5F5F5
        register(GroupSigleTextCell.self, forCellReuseIdentifier: "GroupSigleTextCell")
        register(GroupEditStyleCell.self, forCellReuseIdentifier: "GroupEditStyleCell")
        register(GroupMemberCell.self, forCellReuseIdentifier: "GroupMemberCell")
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            if self!.viewModel.model.creator == ((USERDEFAULT.object(forKey: "phone") ?? "") as? String) {
                self!.dataArr = ["群聊名称","群成员","","添加成员","群管理","退出群聊"]
            } else {
                self!.dataArr = ["群聊名称","群成员","","退出群聊"]
            }
            self!.model = self!.viewModel.model
            self!.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupInfoTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 1 {
            let cell: GroupEditStyleCell = tableView.dequeueReusableCell(withIdentifier: "GroupEditStyleCell", for: indexPath) as! GroupEditStyleCell
            cell.tf.text = indexPath.section == 0 ? self.model.topicGroupName : "共\(self.model.membersList.count)人"
            cell.titleLa.text = dataArr[indexPath.section]
            return cell
        } else if (indexPath.section == 2) {
            let cell: GroupMemberCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as! GroupMemberCell
            cell.dataArr = self.model.membersList
            return cell
        } else {
            let cell: GroupSigleTextCell = tableView.dequeueReusableCell(withIdentifier: "GroupSigleTextCell", for: indexPath) as! GroupSigleTextCell
            cell.titleLa.text = dataArr[indexPath.section]
            cell.titleLa.textColor = dataArr[indexPath.section] == "退出群聊" ? UIColor.red : HEX_333
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 70
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 0.01
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.model.membersList.count == 0 {
            return 
        }
        let str = dataArr[indexPath.section]
        switch str {
        case "群聊名称":
            if self.viewModel.model.creator == ((USERDEFAULT.object(forKey: "phone") ?? "") as? String) {
                let vc = TextEditVC()
                vc.groupName = self.model.topicGroupName
                _ = vc.subject.subscribe(onNext: { [weak self](str) in
                    self!.viewModel.refreshData()
                })
                vc.model = self.model
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
            
            print(str)
        case "群成员":
            let vc = GroupMemVC()
            vc.viewModel.groupID = self.viewModel.groupID
            vc.viewModel.model = self.model
            vc.title = str
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            print(str)
        case "添加成员":
            let vc = GroupChatSelectVC.init()
            vc.viewModel.topicGroupID = self.model.topicGroupID
            var arr: Array<String> = []
            for m in self.model.membersList {
                arr.append(m.memberPhone)
            }
            vc.viewModel.selePhones = arr
            vc.viewModel.disables = arr
            vc.viewModel.navigationVC = self.viewModel.navigationVC
            vc.title = str
            self.viewModel.navigationVC?.present(vc, animated: true, completion: nil)
            print(str)
        case "群管理":
            let vc = GroupManagerVC()
            vc.viewModel.groupID = self.viewModel.groupID
            vc.title = str
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            print(str)
        case "退出群聊":
            self.viewModel.leaveGroup()
            print(str)
        default:
            break
        }
    }
    
}

class GroupInfoTableCell: BaseTableCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GroupSigleTextCell: BaseTableCell {
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        tl.textAlignment = .center
        return tl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GroupEditStyleCell: BaseTableCell {
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tl.textColor = HEX_333
        return tl
    }()
    lazy var tf: UITextField = {
        let t = UITextField()
        t.textColor = HEX_333
        t.textAlignment = .right
        t.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        t.isEnabled = false
        return t
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        backgroundColor = HEX_FFF
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(14)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(80)
        }
        
        contentView.addSubview(tf)
        tf.snp_makeConstraints { (make) in
            make.left.equalTo(titleLa.snp_right).offset(7)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GroupMemberCell: BaseTableCell {
    
    var dataArr: Array<GroupMemberModel> = [] {
        didSet {
            self.memView.dataArr = dataArr
        }
    }
    
    lazy var memView: GroupMemView = {
        let mv = GroupMemView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        return mv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(memView)
        memView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.top.equalTo(contentView).offset(10)
            make.bottom.equalTo(contentView).offset(-10)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(14)
            make.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
