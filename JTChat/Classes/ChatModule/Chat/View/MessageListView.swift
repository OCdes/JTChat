//
//  MessageListView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class MessageListView: BaseTableView {
    var dataArr: Array<FriendModel> = [] {
        didSet {
            reloadData()
        }
    }
    var viewModel: MessageViewModel?
    init(frame: CGRect, style: UITableView.Style, viewModel vm: MessageViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        register(MessageListCell.self, forCellReuseIdentifier: "MessageListCell")
        separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(reloadListView), name: Notification.Name("NewJTMessageIsComing"), object: nil)
    }
    
    @objc func reloadListView() {
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MessageListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        if indexPath.row == 0 {
            cell.portraitV.image = JTBundleTool.getBundleImg(with: "jtsystem")
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
        } else {
            let m = dataArr[indexPath.row-1]
            cell.model = m
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  74
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
        if indexPath.row == 0 {
            let vc = JTSysMessageListVC()
            self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
        } else {
            let fm = self.dataArr[indexPath.row-1]
            let cm = ContactorModel()
            cm.nickName = fm.nickname
            cm.avatarUrl = fm.avatar
            cm.phone = fm.friendPhone
            cm.topicGroupID = fm.topicGroupID
            cm.topicGroupName = fm.topicGroupName
            cm.aliasName = fm.aliasName
            let vc = ChatVC()
            vc.viewModel.contactor = cm
            self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
        }
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
            self.viewModel?.setTop(model: fm)
        }
        setTop.backgroundColor = HEX_LightBlue
        let setNormal = UITableViewRowAction.init(style: .normal, title: "取消置顶") { (action, indexpath) in
            self.viewModel?.setTop(model: fm)
        }
        if fm.topTime.count > 0 {
            return [setNormal]
        } else {
            return [setTop]
        }
        
    }
    
}

class MessageListCell: BaseTableCell {
    var model: FriendModel? {
        didSet {
            if model!.nickname.count > 0 || model!.topicGroupName.count > 0 {
                let imgurl = model!.topicGroupID.count > 0 ? model!.avatarUrl : model!.avatar
                if imgurl.count > 0 {
                    portraitV.kf.setImage(with: URL(string: "\(imgurl)?tmp=\(arc4random())"), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                } else {
                    portraitV.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
                }
                nameLa.text = model!.topicGroupName.count > 0 ? model!.topicGroupName : (model!.aliasName.count > 0 ? model!.aliasName: model!.nickname)
            } else {
                let m = DBManager.manager.getContactor(phone: model!.friendPhone)
                if m.avatarUrl.count > 0 {
                    portraitV.kf.setImage(with: URL(string: "\(m.avatarUrl)?tmp=\(arc4random())"), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                } else {
                    portraitV.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
                }
                nameLa.text = model!.topicGroupName.count > 0 ? m.topicGroupName : (model!.aliasName.count > 0 ? model!.aliasName: model!.nickname)
            }
            
            dateLa.text = model!.createTime
            messageLa.text = model!.packageType == 2 ? (model!.msgContent.contains(".wav") ? "[语音]" : (model!.msgContent.contains("mp4") ? "[视频]" : "[图片]")) : model!.msgContent
            redDot.isHidden = (model!.isReaded || !(model!.unreadCount > 0))
            redDot.text = model!.unreadCount >= 99 ? "99+" : "\(model!.unreadCount)"
            if let sf = model?.fileSuffix {
                self.atRemarkLa.text = sf.count > 0 ? "[有人@我]" : ""
            } else {
                self.atRemarkLa.text = ""
            }
            if let ti = model?.topTime, ti.count > 0 {
                backgroundColor = HEX_COLOR(hexStr: "#e2e2e2").withAlphaComponent(0.3)
            } else {
                backgroundColor = UIColor.clear
//                backgroundColor = HEX_COLOR(hexStr: "#e2e2e2").withAlphaComponent(0.3)
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 28
        pv.layer.masksToBounds = true
        return pv
    }()
    
    lazy var atRemarkLa: UILabel = {
        let al = UILabel()
        al.textColor = UIColor.red
        al.font = UIFont.systemFont(ofSize: 12)
        return al
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_333
        nl.font = UIFont.systemFont(ofSize: 17)
        return nl
    }()
    
    lazy var messageLa: UILabel = {
        let ml = UILabel()
        ml.textColor = HEX_333
        ml.font = UIFont.systemFont(ofSize: 12)
        ml.text = "内容"
        return ml
    }()
    
    lazy var dateLa: UILabel = {
        let dl = UILabel()
        dl.textColor = HEX_999
        dl.font = UIFont.systemFont(ofSize: 12)
        dl.textAlignment = .right
        return dl
    }()
    
    lazy var redDot: UILabel = {
        let rd = UILabel()
        rd.backgroundColor = UIColor.red
        rd.layer.cornerRadius = 8
        rd.layer.masksToBounds = true
        rd.font = UIFont.systemFont(ofSize: 12)
        rd.textColor = HEX_FFF
        rd.textAlignment = .center
        return rd
    }()
    
    lazy var miniRedDot: UILabel = {
        let md = UILabel()
        md.backgroundColor = UIColor.red
        md.layer.cornerRadius = 2.5
        md.layer.masksToBounds = true
        md.isHidden = true
        return md
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        
        contentView.addSubview(miniRedDot)
        miniRedDot.snp_makeConstraints { (make) in
            make.centerX.equalTo(portraitV.snp_right).offset(-10)
            make.centerY.equalTo(portraitV.snp_top).offset(8)
            make.size.equalTo(CGSize(width: 5, height: 5))
        }
        
        contentView.addSubview(redDot)
        redDot.snp_makeConstraints { (make) in
            make.center.equalTo(miniRedDot)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(16)
        }
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(9)
            make.bottom.equalTo(portraitV.snp_centerY)
            make.right.equalTo(contentView).offset(-142)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(dateLa)
        dateLa.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-12)
            make.centerY.height.equalTo(nameLa)
            make.left.equalTo(nameLa.snp_right).offset(10)
            
        }
        
        contentView.addSubview(self.atRemarkLa)
        self.atRemarkLa.snp_makeConstraints { (make) in
            make.top.equalTo(nameLa.snp_bottom)
            make.height.left.equalTo(nameLa)
        }
        
        contentView.addSubview(messageLa)
        messageLa.snp_makeConstraints { (make) in
            make.top.equalTo(nameLa.snp_bottom)
            make.left.equalTo(atRemarkLa.snp_right)
            make.height.right.equalTo(self.nameLa)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right)
            make.right.equalTo(dateLa)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
