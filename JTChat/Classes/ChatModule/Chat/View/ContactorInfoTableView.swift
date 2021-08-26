//
//  ContactorInfoTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import YPImagePicker
import Photos
class ContactorInfoTableView: BaseTableView {
    var titlesArr: Array<String> = ["手机","部门"]
    var contentsArr: Array<String> = ["","",""]
    var viewModel: ContactorInfoViewModel?
    lazy var footerV: UIView = {
        let fv = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 174))
        let messageBtn = UIButton.init(frame: CGRect(x: 16, y: 38, width: kScreenWidth-32, height: 44))
        messageBtn.layer.cornerRadius = 5
        messageBtn.backgroundColor = HEX_COLOR(hexStr: "#3F80CB")
        messageBtn.setTitle("发消息", for: .normal)
        messageBtn.setTitleColor(HEX_FFF, for: .normal)
        let _ = messageBtn.rx.tap.subscribe(onNext: { [weak self](e) in
            if self?.viewModel?.isFromChat ?? false {
                self?.viewModel?.navigationVC?.popViewController(animated: true)
            } else {
                let vc = ChatVC()
                let cmodel = ContactorModel()
                cmodel.phone = self!.viewModel!.employeeModel.phone
                cmodel.nickName = self!.viewModel!.employeeModel.nickName
                vc.viewModel.contactor = cmodel
                vc.title = self!.viewModel!.employeeModel.nickName
                self!.viewModel?.navigationVC?.pushViewController(vc, animated: true)
            }
            
        })
        fv.addSubview(messageBtn)
        let voiceCallBtn = UIButton.init(frame: CGRect(x: 16, y: messageBtn.frame.maxY + 10, width: kScreenWidth-32, height: 44))
        voiceCallBtn.layer.cornerRadius = 5
        voiceCallBtn.backgroundColor = kIsFlagShip ? HEX_COLOR(hexStr: "#333") : HEX_FFF
        voiceCallBtn.setTitle("语音通话", for: .normal)
        voiceCallBtn.setTitleColor(HEX_333, for: .normal)
        fv.addSubview(voiceCallBtn)
        return fv
    }()
    
    lazy var footerV2: UIView = {
        let fv = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 174))
        let messageBtn = UIButton.init(frame: CGRect(x: 16, y: 60, width: kScreenWidth-32, height: 44))
        messageBtn.layer.cornerRadius = 5
        messageBtn.backgroundColor = HEX_COLOR(hexStr: "#3F80CB")
        messageBtn.setTitle("添加好友", for: .normal)
        messageBtn.setTitleColor(HEX_FFF, for: .normal)
        let _ = messageBtn.rx.tap.subscribe(onNext: { [weak self](e) in
            if JTManager.manager.addFriendSilence {
                self!.viewModel?.addFriend(friendNickname: nil, friendPhone: nil, friendAvatar: nil, remark: "", result: { [weak self](b) in
                    if b {
                        self!.tableFooterView = self!.footerV
                    }
                })
            } else {
                let alertv = FriendAddAlertView.init(frame: CGRect.zero)
                alertv.model = self!.viewModel!.employeeModel
                _ = alertv.sureSubject.subscribe { [weak self](a) in
                    self!.viewModel?.addFriend(friendNickname: nil, friendPhone: nil, friendAvatar: nil, remark: a, result: { [weak self](b) in
                        if b {
                            self!.tableFooterView = self!.footerV
                        }
                    })
                }
                alertv.show()
            }
            
            })
        fv.addSubview(messageBtn)
        return fv
    }()
    
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ContactorInfoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
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
        backgroundColor = kIsFlagShip ? HEX_ThemeBlack : HEX_COLOR(hexStr: "#F5F6F8")
        register(ContactorInfoCell.self, forCellReuseIdentifier: "ContactorInfoCell")
        register(ContactInfoDetailCell.self, forCellReuseIdentifier: "ContactInfoDetailCell")
        register(ContactInfoAlisaCell.self, forCellReuseIdentifier: "ContactInfoAlisaCell")
        if let phone = viewModel?.employeeModel.phone, phone.count > 7 {
            contentsArr[0] = "\(phone.prefix(3))****\(phone.suffix(4))"
        }
        
        if let a = viewModel?.employeeModel.phone, let b = USERDEFAULT.object(forKey: "phone") as? String, a == b {
            
        } else {
            self.tableFooterView = (viewModel?.employeeModel.isFriend ?? false) ? footerV : footerV2
            if viewModel?.employeeModel.isFriend ?? false {
                if !self.titlesArr.contains("设置聊天背景") {
                    titlesArr.append("设置聊天背景")
                }
                
            } else {
                if let index = titlesArr.firstIndex(of: "设置聊天背景") {
                    titlesArr.remove(at: index)
                }
                
            }
        }
        let _ = viewModel!.subject.subscribe { [weak self](a) in
            if let a = self!.viewModel?.employeeModel.phone, let b = USERDEFAULT.object(forKey: "phone") as? String, a == b {
                self!.tableFooterView = self!.footerV
            } else {
                self!.tableFooterView = (self!.viewModel?.employeeModel.isFriend ?? false) ? self!.footerV : self!.footerV2
                if self?.viewModel?.employeeModel.isFriend ?? false {
                    if !self!.titlesArr.contains("设置聊天背景") {
                        self!.titlesArr.append("设置聊天背景")
                    }
                } else {
                    if let index = self?.titlesArr.firstIndex(of: "设置聊天背景") {
                        self?.titlesArr.remove(at: index)
                    }
                }
            }
            self!.contentsArr[1] = self!.viewModel?.employeeModel.department ?? ""
            self!.reloadData()
        }
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactorInfoTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return titlesArr.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: ContactInfoDetailCell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoDetailCell", for: indexPath) as! ContactInfoDetailCell
            cell.portraitV.kf.setImage(with: URL(string: viewModel?.employeeModel.avatarUrl ?? ""), placeholder: JTBundleTool.getBundleImg(with: "approvalPortrait"))
            cell.nameLa.text = viewModel?.employeeModel.nickName ?? ""
            return cell
        case 1:
            let cell: ContactInfoAlisaCell = tableView.dequeueReusableCell(withIdentifier: "ContactInfoAlisaCell", for: indexPath) as! ContactInfoAlisaCell
            cell.alisaLa.text = viewModel!.employeeModel.aliasName.count > 0 ? viewModel!.employeeModel.aliasName : (viewModel?.employeeModel.nickName ?? "")
            return cell
        case 2:
            let cell: ContactorInfoCell = tableView.dequeueReusableCell(withIdentifier: "ContactorInfoCell", for: indexPath) as! ContactorInfoCell
            if indexPath.row == 2 {
                cell.textLabel?.text = titlesArr[indexPath.row]
                cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                cell.textLabel?.textColor = HEX_333
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = UIImageView.init(image: JTBundleTool.getBundleImg(with: "rightArrow"))
            } else {
                cell.titleLa.text = titlesArr[indexPath.row]
                cell.contentLa.text = contentsArr[indexPath.row]
                cell.contentLa.textColor = titlesArr[indexPath.row] == "手机" ? HEX_COLOR(hexStr: "#3F80CB") : HEX_333
                cell.accessoryType = titlesArr[indexPath.row] == "部门" ? .none : .none
                cell.accessoryView = UIImageView.init(image: JTBundleTool.getBundleImg(with: "rightArrow"))
            }
            
            return cell
        default:
            let cell: ContactorInfoCell = tableView.dequeueReusableCell(withIdentifier: "ContactorInfoCell", for: indexPath) as! ContactorInfoCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 93
        case 1:
            return 45
        case 2:
            return 44
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 20
        case 1:
            return 7.5
        case 2:
            return 7.5
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 7.5))
        v.backgroundColor = kIsFlagShip ? HEX_ThemeBlack : HEX_COLOR(hexStr: "#F5F6F8")
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let vm = self.viewModel, vm.employeeModel.phone.count > 0, vm.employeeModel.isFriend {
                let vc = TextEditVC()
                vc.contacName = vm.employeeModel.aliasName.count > 0 ? vm.employeeModel.aliasName : vm.employeeModel.nickName
                _ = vc.subject.subscribe(onNext: { [weak self](str) in
                    self!.viewModel!.getDetail()
                })
                vc.contactModel = vm.employeeModel
                self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
            }
        } else if (indexPath.section == 2) {
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
                                self.viewModel?.setPersonalChatViewBG(image: img.image)
                                break;
                            default:
                                break;
                            }
                            
                        }
                        picker.dismiss(animated: true, completion: nil)
                    }
                    self.viewModel?.navigationVC?.present(picker, animated: true, completion: nil)
                }
            }
            
            let actionReset = UIAlertAction.init(title: "重置背景图", style: .destructive) { (action) in
                self.viewModel?.resetChatViewBG()
            }
            
            let actionCancle = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                
            }
            
            alertController.addAction(actionSelect)
            alertController.addAction(actionReset)
            alertController.addAction(actionCancle)
            self.viewModel?.navigationVC?.present(alertController, animated: true, completion: nil)
        }
    }
    
}

class ContactorInfoCell: BaseTableCell {
    lazy var titleLa: UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        la.textColor = HEX_333
        return la
    }()
    lazy var contentLa: UILabel = {
        let la = UILabel()
        la.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        la.textColor = HEX_333
        return la
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_FFF
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12.5)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(70)
        }
        
        contentView.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.left.equalTo(titleLa.snp_right).offset(5)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { make in
            make.left.equalTo(contentView).offset(14)
            make.bottom.right.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContactInfoDetailCell: BaseTableCell {
    lazy var portraitV: UIImageView = {
        let pv = UIImageView.init()
        pv.layer.cornerRadius = 30
        pv.layer.masksToBounds = true
        return pv
    }()
    
    lazy var nameLa: UILabel = {
        let la = UILabel()
        la.textColor = HEX_333
        la.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return la
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_FFF
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12.5)
            make.centerY.equalTo(contentView)
            make.size.equalTo(CGSize(width: 60, height: 60))
        }
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(15)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ContactInfoAlisaCell: BaseTableCell {
    lazy var alisaLa: UILabel = {
        let al = UILabel()
        al.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        al.textColor = HEX_333
        return al
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = kIsFlagShip ? HEX_VIEWBACKCOLOR : HEX_FFF
        accessoryType = .disclosureIndicator
        contentView.addSubview(alisaLa)
        alisaLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(12.5)
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
