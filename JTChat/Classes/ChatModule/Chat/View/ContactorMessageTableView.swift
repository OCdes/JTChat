//
//  ContactorMessageTableView.swift
//  JTChat
//
//  Created by jingte on 2022/3/7.
//

import UIKit

class ContactorMessageTableView: BaseTableView {
    var viewModel: ContactorMessageViewModel = ContactorMessageViewModel()
    var dataArr: [FriendModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    lazy var searchTf: UITextField = {
        let st = UITextField.init(frame: CGRect(x: 15, y: 10, width: kScreenWidth-30, height: 30))
        st.backgroundColor = HEX_FFF
        st.placeholder = "搜索"
        let leftV = UIView.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        let imgv = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        imgv.image = JTBundleTool.getBundleImg(with: "search2")
        imgv.center = leftV.center
        leftV.addSubview(imgv)
        st.leftView = leftV
        st.leftViewMode = .always
        st.textColor = HEX_333
        st.layer.cornerRadius = 15
        st.layer.masksToBounds = true
        st.delegate = self
        return st
    }()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ContactorMessageViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = HEX_COLOR(hexStr: "#F5F6F8")
        delegate = self
        dataSource = self
        rowHeight = 74
        separatorStyle = .none
        let headerv = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        headerv.addSubview(self.searchTf)
        tableHeaderView = headerv
        register(MessageListCell.self, forCellReuseIdentifier: "MessageListCell")
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            if let arr = self?.viewModel.personalListArr {
                self?.dataArr = arr
            }
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ContactorMessageTableView: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? self.dataArr.count : (section == 0 ? 2 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.portraitV.kf.setImage(with: URL(string: ""), placeholder: JTBundleTool.getBundleImg(with: "jtsystem"))
                cell.nameLa.text = "精特消息"
                if let arr = USERDEFAULT.object(forKey: "latestJTMessageList") as? [[String:Any]], arr.count > 0, let dict = arr.first {
                    cell.messageLa.text = (dict["content"] as? String) ?? ""
                    if let ti = Double(dict["times"] as! String), ti > 0 {
                        cell.dateLa.text = ChatDateManager.manager.dealDate(byTimestamp: ti)
                    }
                    if let b = dict["isReaded"] as? Bool, b == true {
                        cell.redDot.isHidden = true
                    } else {
                        cell.redDot.isHidden = false
                        cell.redDot.text = "\(arr.count)"
                    }
                } else {
                    cell.messageLa.text = "暂无新的系统消息"
                    cell.dateLa.text = ""
                    cell.miniRedDot.isHidden = true
                    cell.redDot.isHidden = true
                }
                cell.backgroundColor = HEX_FFF
                cell.line.isHidden = false
                cell.textLabel?.text = ""
            } else {
                let aarr = self.viewModel.addApplyArr
                cell.portraitV.image = JTBundleTool.getBundleImg(with: "approvalPortrait")
                cell.nameLa.text = "新的好友"
                cell.dateLa.text = ""
                cell.messageLa.text = aarr.count > 0 ? (aarr.count > 1 ? "\(aarr.first!.nickname)等\(aarr.count)人申请添加您为好友" : "\(aarr.first!.nickname)申请添加您为好友") : ""
                cell.redDot.isHidden = !(self.viewModel.addApplyArr.count > 0)
                cell.redDot.text = aarr.count > 99 ? "99+" : "\(aarr.count)"
                cell.backgroundColor = HEX_FFF
            }
        } else if indexPath.section == 1 {
            cell.portraitV.image = JTBundleTool.getBundleImg(with: "groupPortrait")
            cell.nameLa.text = "群聊"
            cell.backgroundColor = HEX_FFF
            cell.dateLa.text = ""
            if viewModel.groupNum > 0 {
                cell.redDot.isHidden = false
                cell.redDot.text = "\(viewModel.groupNum)"
            } else {
                cell.redDot.isHidden = true
                cell.messageLa.text = "暂无群聊消息"
            }
            if viewModel.groupListArr.count > 0 {
                let m = viewModel.groupListArr.first!
                cell.dateLa.text = m.createTime
                cell.messageLa.text = "\(m.aliasName.count > 0 ? m.aliasName : m.topicGroupName):\(m.packageType == 2 ? (m.msgContent.contains(".wav") ? "[语音]" : (m.msgContent.contains("mp4") ? "[视频]" : "[图片]")) : m.msgContent)"
            }
        } else {
            let m = dataArr[indexPath.row]
            cell.model = m
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerV = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 10))
        footerV.backgroundColor = HEX_COLOR(hexStr: "#F5F6F8")
        return section == 1 ? nil : footerV
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                let vc = JTSysMessageListVC()
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            } else {
                let vc = AddFriendApplyVC.init()
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
        } else if indexPath.section == 1 {
            let vc = GroupChatListVC()
            vc.title = "群聊"
            self.viewModel.navigationVC?.pushViewController(vc, animated: true)
        } else {
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
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.viewModel.navigationVC?.pushViewController(ContactorResultVC(), animated: true)
        return false
    }
}


