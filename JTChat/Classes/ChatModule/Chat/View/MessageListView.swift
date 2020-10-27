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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MessageListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageListCell = tableView.dequeueReusableCell(withIdentifier: "MessageListCell", for: indexPath) as! MessageListCell
        let m = dataArr[indexPath.row]
        cell.model = m
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60
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
        self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
    }
    
}

class MessageListCell: BaseTableCell {
    var model: FriendModel? {
        didSet {
            if model!.nickname.count > 0 || model!.topicGroupName.count > 0 {
                portraitV.kf.setImage(with: URL(string: model!.avatar), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                nameLa.text = model!.topicGroupName.count > 0 ? model!.topicGroupName : (model!.aliasName.count > 0 ? model!.aliasName: model!.nickname)
            } else {
                let m = DBManager.manager.getContactor(phone: model!.friendPhone)
                portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                nameLa.text = model!.topicGroupName.count > 0 ? m.topicGroupName : (model!.aliasName.count > 0 ? model!.aliasName: model!.nickname)
            }
            
            dateLa.text = model!.createTime
            messageLa.text = model!.packageType == 2 ? (model!.msgContent.contains(".wav") ? "[语音]" : "[图片]") : model!.msgContent
            redDot.isHidden = (model!.isReaded || !(model!.unreadCount > 0))
            redDot.text = model!.unreadCount >= 99 ? "99+" : "\(model!.unreadCount)"
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        return pv
    }()
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.textColor = HEX_333
        nl.font = UIFont.systemFont(ofSize: 16)
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
        md.layer.cornerRadius = 1.5
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
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        contentView.addSubview(miniRedDot)
        miniRedDot.snp_makeConstraints { (make) in
            make.centerX.equalTo(portraitV.snp_right)
            make.centerY.equalTo(portraitV.snp_top)
            make.size.equalTo(CGSize(width: 3, height: 3))
        }
        
        contentView.addSubview(redDot)
        redDot.snp_makeConstraints { (make) in
            make.center.equalTo(miniRedDot)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(35)
            make.width.greaterThanOrEqualTo(16)
        }
        
        contentView.addSubview(dateLa)
        dateLa.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-12)
            make.top.equalTo(contentView)
            make.size.equalTo(CGSize(width: 120, height: 22))
        }
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(22)
            make.bottom.equalTo(portraitV.snp_centerY)
            make.right.equalTo(dateLa.snp_right).offset(-10)
            make.height.equalTo(22)
        }
        
        contentView.addSubview(messageLa)
        messageLa.snp_makeConstraints { (make) in
            make.top.equalTo(nameLa.snp_bottom)
            make.height.left.right.equalTo(nameLa)
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
