//
//  GroupInfoTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/5.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import YPImagePicker
class GroupInfoTableView: UITableView {
    var dataArr: Array<String> = []
    var viewModel: GroupInfoViewModel = GroupInfoViewModel()
    var model: GroupInfoModel = GroupInfoModel()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupInfoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        separatorStyle = .none
        delegate = self
        dataSource = self
        isUserInteractionEnabled = false
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
        backgroundColor = HEX_F5F5F5
        register(GroupSigleTextCell.self, forCellReuseIdentifier: "GroupSigleTextCell")
        register(GroupEditStyleCell.self, forCellReuseIdentifier: "GroupEditStyleCell")
        register(GroupMemberCell.self, forCellReuseIdentifier: "GroupMemberCell")
        register(GroupPortraitCell.self, forCellReuseIdentifier: "GroupPortraitCell")
        register(GroupAnnouncementCell.self, forCellReuseIdentifier: "GroupAnnouncementCell")
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            self!.isUserInteractionEnabled = true
            if self!.viewModel.model.creator == ((USERDEFAULT.object(forKey: "phone") ?? "") as? String) {
                self!.dataArr = ["群聊名称","群头像","群公告","","群成员","","群聊天背景","添加成员","群管理","退出群聊"]
            } else {
                self!.dataArr = ["群聊名称","群头像","群公告","","群成员","","群聊天背景","退出群聊"]
            }
            self!.model = self!.viewModel.model
            self!.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupInfoTableView: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 || indexPath.section == 2 || indexPath.section == 4 {
            let cell: GroupEditStyleCell = tableView.dequeueReusableCell(withIdentifier: "GroupEditStyleCell", for: indexPath) as! GroupEditStyleCell
            cell.tf.text = indexPath.section == 0 ? self.model.topicGroupName : (indexPath.section == 4 ? "共\(self.model.membersList.count)人" : "")
            cell.titleLa.text = dataArr[indexPath.section]
            if indexPath.section == 0 {
                if self.model.creator != JTManager.manager.phone {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .disclosureIndicator
                }
            }
            return cell
        } else if (indexPath.section == 5) {
            let cell: GroupMemberCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as! GroupMemberCell
            cell.dataArr = self.model.membersList
            return cell
        } else if (indexPath.section == 1) {
            let cell: GroupPortraitCell = tableView.dequeueReusableCell(withIdentifier: "GroupPortraitCell", for: indexPath) as! GroupPortraitCell
            cell.titleLa.text = dataArr[indexPath.section]
            if self.model.avatarUrl.count > 0 {
                cell.portraitV.kf.setImage(with: URL(string: "\(self.model.avatarUrl)?tmp=\(arc4random())"), placeholder: PLACEHOLDERIMG)
            }
            return cell
        } else if (indexPath.section == 3) {
            let cell: GroupAnnouncementCell = tableView.dequeueReusableCell(withIdentifier: "GroupAnnouncementCell", for: indexPath) as! GroupAnnouncementCell
            cell.textV.text = self.model.topicGroupDesc.count > 0 ? self.model.topicGroupDesc : "暂无公告"
            cell.textV.delegate = self
            return cell
        } else {
            let cell: GroupSigleTextCell = tableView.dequeueReusableCell(withIdentifier: "GroupSigleTextCell", for: indexPath) as! GroupSigleTextCell
            cell.titleLa.text = dataArr[indexPath.section]
            cell.titleLa.textColor = dataArr[indexPath.section] == "退出群聊" ? UIColor.red : HEX_333
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 3:
            return 101.5
        case 1:
            return 55.5
        case 5:
            return 70
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 7.5
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 || section == 4 {
            return 0.01
        }
        return 7.5
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
            if self.viewModel.model.creator == JTManager.manager.phone {
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
        case "群公告":
            if self.viewModel.model.creator == JTManager.manager.phone {
                let vc = ReleaseAnnouncementVC()
                vc.noteContent = self.model.topicGroupDesc
                _ = vc.subject.subscribe(onNext: { [weak self](str) in
                    self!.viewModel.refreshData()
                })
                vc.model = self.model
                self.viewModel.navigationVC?.pushViewController(vc, animated: true)
            }
            
            print(str)
        case "群头像":
            if checkPhotoLibaray() {
                var config: YPImagePickerConfiguration = YPImagePickerConfiguration.init()
                config.isScrollToChangeModesEnabled = false
                config.onlySquareImagesFromCamera = false
                config.showsPhotoFilters = false
                config.usesFrontCamera = true
                config.hidesBottomBar = true
                config.screens = [.library]
                config.library.maxNumberOfItems = 1
                config.library.mediaType = .photoAndVideo
                config.video.trimmerMinDuration = 1
                config.video.trimmerMaxDuration = 10
                config.video.fileType = .mp4
                config.startOnScreen = YPPickerScreen.library
                config.albumName = "精特"
                config.wordings.next = "下一步"
                config.wordings.cancel = "取消"
                config.wordings.libraryTitle = "相册"
                config.wordings.cameraTitle = "相机"
                config.wordings.albumsTitle = "全部相册"
                config.library.defaultMultipleSelection = true
                let picker: YPImagePicker = YPImagePicker.init(configuration: config)
                picker.imagePickerDelegate = self as? YPImagePickerDelegate
                picker.didFinishPicking { [unowned picker] items, _  in
                    if items.count > 0 {
                        let itemOne = items[0]
                        switch itemOne {
                        case .photo(p: let img):
                            self.viewModel.updateGroupPortrait(image: img.image)
                            break;
                        default:
                            break;
                        }
                        
                    }
                    picker.dismiss(animated: true, completion: nil)
                }
                self.viewModel.navigationVC?.present(picker, animated: true, completion: nil)
            }
        case "群聊天背景":
            let alertController = UIAlertController.init(title: "", message: "", preferredStyle: .actionSheet)
            let actionSelect = UIAlertAction.init(title: "选择背景图", style: .default) { (action) in
                if checkPhotoLibaray() {
                    var config: YPImagePickerConfiguration = YPImagePickerConfiguration.init()
                    config.isScrollToChangeModesEnabled = false
                    config.onlySquareImagesFromCamera = false
                    config.showsPhotoFilters = false
                    config.hidesBottomBar = true
                    config.screens = [.library]
                    config.library.maxNumberOfItems = 1
                    config.library.mediaType = .photo
                    config.startOnScreen = YPPickerScreen.library
                    config.albumName = "精特"
                    config.wordings.next = "下一步"
                    config.wordings.cancel = "取消"
                    config.wordings.libraryTitle = "相册"
                    config.wordings.cameraTitle = "相机"
                    config.wordings.albumsTitle = "全部相册"
                    config.library.defaultMultipleSelection = true
                    let picker: YPImagePicker = YPImagePicker.init(configuration: config)
                    picker.imagePickerDelegate = self as? YPImagePickerDelegate
                    picker.didFinishPicking { [unowned picker] items, _  in
                        if items.count > 0 {
                            let itemOne = items[0]
                            switch itemOne {
                            case .photo(p: let img):
                                self.viewModel.setGroupChatViewBG(image: img.image)
                                break;
                            default:
                                break;
                            }
                            
                        }
                        picker.dismiss(animated: true, completion: nil)
                    }
                    self.viewModel.navigationVC?.present(picker, animated: true, completion: nil)
                }
            }
            
            let actionReset = UIAlertAction.init(title: "重置背景图", style: .destructive) { (action) in
                self.viewModel.resetChatViewBG()
            }
            
            let actionCancle = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(actionSelect)
            alertController.addAction(actionReset)
            alertController.addAction(actionCancle)
            self.viewModel.navigationVC?.present(alertController, animated: true, completion: nil)
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

class GroupPortraitCell: BaseTableCell {
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tl.textColor = HEX_333
        return tl
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 19
        pv.layer.masksToBounds = true
        return pv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        backgroundColor = HEX_FFF
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(14)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(titleLa.snp_height)
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.centerY.right.equalTo(contentView)
            make.size.equalTo(CGSize(width: 38, height: 38))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GroupAnnouncementCell: BaseTableCell {
    lazy var textV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = HEX_333
        tv.isUserInteractionEnabled = false
        return tv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(textV)
        textV.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 12.5))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
