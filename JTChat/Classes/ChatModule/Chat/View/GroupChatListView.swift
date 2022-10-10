//
//  GroupChatListView.swift
//  JTChat
//
//  Created by jingte on 2022/3/7.
//

import UIKit

class GroupChatListView: BaseTableView {
    var viewModel: GroupListViewModel = GroupListViewModel()
    var dataArr: [FriendModel] = []
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupListViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        rowHeight = 74
        register(MessageListCell.self, forCellReuseIdentifier: "MessageListCell")
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            if let arr = self?.viewModel.groupListArr {
                self?.dataArr = arr
                self?.reloadData()
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension GroupChatListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        let m = dataArr[indexPath.row]
        cell.model = m
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let fm = self.dataArr[indexPath.row]
            let cm = ContactorModel()
            cm.nickName = fm.nickname
            cm.avatarUrl = fm.avatar
            cm.phone = fm.friendPhone
            cm.topicGroupID = fm.topicGroupID
            cm.topicGroupName = fm.topicGroupName
            cm.aliasName = fm.aliasName
            let vc = ChatVC()
            vc.viewModel.contactor = cm
        self.viewModel.navigationVC?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue)!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let fm = self.dataArr[indexPath.row]
        let setTop = UITableViewRowAction.init(style: .default, title: "置顶") { (action, indexpath) in
            self.viewModel.setTop(model: fm)
        }
        setTop.backgroundColor = HEX_COLOR(hexStr: "#EF8732")
        let setNormal = UITableViewRowAction.init(style: .normal, title: "取消置顶") { (action, indexpath) in
            self.viewModel.setTop(model: fm)
        }
        
        let detailBtn = UITableViewRowAction.init(style: .default, title: "资料") { Action, indexpath in
            if fm.topicGroupID.count > 0 {
                let vc = GroupInfoVC()
                vc.viewModel.groupID = fm.topicGroupID
                vc.viewModel.isFromChat = true
                vc.title = fm.aliasName.count > 0 ? fm.aliasName : fm.topicGroupName
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else {
                let mm = ContactorInfoViewModel()
                mm.employeeModel.phone = fm.friendPhone
                let vc = ContacterInfoVC()
                vc.viewModel = mm
                vc.viewModel.isFromChat = true
                vc.title = fm.aliasName.count > 0 ? fm.aliasName : fm.nickname
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        }
        detailBtn.backgroundColor = HEX_LightBlue
        if fm.topTime.count > 0 {
            return [detailBtn, setNormal]
        } else {
            return [detailBtn, setTop,]
        }
        
    }
}
