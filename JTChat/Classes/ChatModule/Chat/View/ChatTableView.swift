//
//  ChatTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import AVFoundation
import AVKit
import RxCocoa
class ChatTableView: BaseTableView {
    var dataArr: Array<MessageSectionModel> = []
    var viewModel: ChatViewModel?
    var recordManager: RecorderManager = RecorderManager()
    var previousImgv: UIImageView?
    var playerVC: AVPlayerViewController = AVPlayerViewController()
    var tapSubject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ChatViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = UIColor.clear
        separatorStyle = .none
        delegate = self
        dataSource = self
        recordManager.delegate = self
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
        register(ChatTableLeftCell.self, forCellReuseIdentifier: "ChatTableLeftCell")
        register(ChatTableRightCell.self, forCellReuseIdentifier: "ChatTableRightCell")
        register(LeftImgVCell.self, forCellReuseIdentifier: "LeftImgVCell")
        register(LeftVoiceCell.self, forCellReuseIdentifier: "LeftVoiceCell")
        register(RightVoiceCell.self, forCellReuseIdentifier: "RightVoiceCell")
        register(RightImgVCell.self, forCellReuseIdentifier: "RightImgVCell")
        register(LeftVideoCell.self, forCellReuseIdentifier: "LeftVideoCell")
        register(RightVideoCell.self, forCellReuseIdentifier: "RightVideoCell")
        let _ = viewModel?.subject.subscribe(onNext: { [weak self](count) in
            self?.dataArr = (self!.viewModel?.dataArr ?? [])
            self?.reloadData()
        })
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap)))
    }
    
    func scrollTo(offsetY:CGFloat, animated: Bool?) {
        if self.dataArr.count > 0 {
            DispatchQueue.main.async {
                if self.contentSize.height-self.contentOffset.y > self.frame.size.height {
                    self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height-self.frame.size.height), animated: false)
                }
                usleep(5000)
                let section = self.numberOfSections(in: self)
                if section > 0 {
                    let rows = self.dataArr[section-1].rowsArr.count
                    if rows > 0 {
                        self.scrollToRow(at: IndexPath(row: rows-1, section:section-1), at: .bottom, animated: animated ?? false)
                    }
                }
            }
        }
    }
    
    @objc func tableViewTap() {
        self.tapSubject.onNext("")
    }
    
    deinit {
        print(" chattableview 销毁了")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableView: UITableViewDelegate, UITableViewDataSource, JTChatMenuViewDelegate, RecorderManagerPlayerDelegate {
    
    func recordManagerPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.previousImgv?.stopAnimating()
        self.recordManager.stopPlayAudio(by: "")
    }
    
    func retweetMessage(fromMessageView: JTChatMenuView) {
        _ = fromMessageView.indexPath
    }
    
    func deleteMessage(fromMessageView: JTChatMenuView) {
        let index = fromMessageView.indexPath
        _ = DBManager.manager.deleteChatLog(model: self.dataArr[index.section].rowsArr[index.row])
        self.beginUpdates()
        self.deleteRows(at: [index], with: UITableView.RowAnimation.fade)
        if self.dataArr[index.section].rowsArr.count-1 > 0 {
            self.reloadSections(IndexSet.init([index.section]), with: .fade)
            let m = self.dataArr[index.section].rowsArr[index.row]
            let i = (self.viewModel!.originArr as NSArray).index(of: m)
            self.viewModel!.originArr.remove(at: i)
            self.dataArr[index.section].rowsArr.remove(at: index.row)
            self.viewModel?.clearRedPot()
        } else {
            self.deleteSections(IndexSet.init([index.section]), with: .fade)
            let m = self.dataArr[index.section].rowsArr[index.row]
            let i = (self.viewModel!.originArr as NSArray).index(of: m)
            self.viewModel!.originArr.remove(at: i)
            self.dataArr.remove(at: index.section)
            self.viewModel?.clearRedPot()
        }
        
        self.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel!.page == 1 {
            if section == self.dataArr.count-1  {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 1)) {
                    self.scrollTo(offsetY: self.contentSize.height, animated: false)
                }
            }
        }
        return dataArr[section].rowsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section].rowsArr[indexPath.row]
        if !model.isRemote {
            if model.packageType == 2 && model.msgContent.contains(".wav") {
                let cell: RightVoiceCell = tableView.dequeueReusableCell(withIdentifier: "RightVoiceCell", for: indexPath) as! RightVoiceCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tag(tap:)))
                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            } else if model.packageType == 2 && model.msgContent.contains(".mp4") {
                let cell: RightVideoCell = tableView.dequeueReusableCell(withIdentifier: "RightVideoCell", for: indexPath) as! RightVideoCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            } else if model.packageType == 2 {
                let cell: RightImgVCell = tableView.dequeueReusableCell(withIdentifier: "RightImgVCell", for: indexPath) as! RightImgVCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                //                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                //                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            }  else {
                let cell: ChatTableRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableRightCell", for: indexPath) as! ChatTableRightCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                //                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                //                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            }
        } else {
            if model.packageType == 2 && model.msgContent.contains(".wav") {
                let cell: LeftVoiceCell = tableView.dequeueReusableCell(withIdentifier: "LeftVoiceCell", for: indexPath) as! LeftVoiceCell
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tag(tap:)))
                cell.model = model
                cell.contentV.indexPath = indexPath
                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            } else if model.packageType == 2 && model.msgContent.contains(".mp4") {
                let cell: LeftVideoCell = tableView.dequeueReusableCell(withIdentifier: "LeftVideoCell", for: indexPath) as! LeftVideoCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            } else if model.packageType == 2 {
                let cell: LeftImgVCell = tableView.dequeueReusableCell(withIdentifier: "LeftImgVCell", for: indexPath) as! LeftImgVCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                //                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                //                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            } else {
                let cell: ChatTableLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableLeftCell", for: indexPath) as! ChatTableLeftCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                //                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                //                cell.contentV.addGestureRecognizer(tap)
                cell.contentV.delegate = self
                return cell
            }
        }
    }
    
    @objc func tapNormalCell(tap: UITapGestureRecognizer) {
        if let la = tap.view {
            let indexPath = la.indexPath
            let model = dataArr[indexPath.section].rowsArr[indexPath.row]
            let creatPath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first?.appending("/\(model.msgContent)") ?? ""
            let avUrl = AVURLAsset.init(url: URL(fileURLWithPath: creatPath))
            self.playerVC.player = AVPlayer.init(playerItem: AVPlayerItem.init(asset: avUrl))
            self.viewModel?.navigationVC?.present(self.playerVC, animated: true, completion: nil)
            self.playerVC.player?.play()
        }
    }
    
    @objc func tag(tap: UITapGestureRecognizer) {
        if let la = tap.view {
            let indexPath = la.indexPath
            let model = dataArr[indexPath.section].rowsArr[indexPath.row]
            print(model.msgContent)
            
            if let i = self.previousImgv {
                i.stopAnimating()
            }
            if let cell = self.cellForRow(at: indexPath), cell.isKind(of: LeftVoiceCell.self) || cell.isKind(of: RightVoiceCell.self) {
                var imgv: UIImageView
                if cell.isKind(of: LeftVoiceCell.self) {
                    let c = cell as! LeftVoiceCell
                    imgv = c.imgv
                    
                    c.redDot.isHidden = true
                } else {
                    let c = cell as! RightVoiceCell
                    imgv = c.imgv
                }
                if let curl = self.recordManager.avPlayer?.url?.absoluteString, (curl as NSString).contains(model.msgContent) {
                    imgv.stopAnimating()
                    self.recordManager.stopPlayAudio(by: model.msgContent)
                } else {
                    imgv.startAnimating()
                    self.previousImgv = imgv
                    self.recordManager.stopPlayAudio(by: "")
                    self.recordManager.playAudio(by: model.msgContent)
                    if !model.voiceIsReaded {
                        model.voiceIsReaded = true
                        DBManager.manager.updateChatLog(model: model)
                    }
                }
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.section].rowsArr[indexPath.row]
        if !model.isRemote {
            return CGFloat(model.estimate_height > 62 ? model.estimate_height : 62)
        } else {
            return CGFloat(model.estimate_height > 62 ? model.estimate_height : 62) + 16.5
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 20))
        v.backgroundColor = UIColor.clear
        let b = UILabel.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 20))
        b.textColor = HEX_999
        b.font = UIFont.systemFont(ofSize: 12)
        b.text = dataArr[section].time
        b.textAlignment = .center
        v.addSubview(b)
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class ChatTableLeftCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            if model.topic_group.count > 0 {
                nameLa.text = m.aliasName.count > 0 ? m.aliasName : m.nickName
            }
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(25.5+kScreenWidth-122-CGFloat(model.estimate_width)))
            
            }
        }
    }
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = HEX_999
        return nl
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.init(name: "iconfont", size: 16)
        cl.textColor = HEX_COLOR(hexStr: "#333333")
        cl.numberOfLines = 0
        cl.isUserInteractionEnabled = true
        return cl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(5)
            make.size.equalTo(CGSize(width: 150, height: 15))
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(nameLa.snp_bottom).offset(3)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        trangle.image = JTBundleTool.getBundleImg(with: "leftTrangle")
        contentView.addSubview(trangle)
        trangle.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(6.5)
            make.centerY.equalTo(portraitV)
            make.size.equalTo(CGSize(width: 6, height: 15))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.left.equalTo(trangle.snp_right)
            make.top.equalTo(portraitV).offset(-1)
            make.right.equalTo(contentView).offset(-64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftImgVCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            if model.topic_group.count > 0 {
                nameLa.text = m.aliasName.count > 0 ? m.aliasName : m.nickName
            }
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            imgv.image = ChatimagManager.manager.GetImageBy(MD5Str: model.msgContent)
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(58 + kScreenWidth-116-CGFloat(model.estimate_width)))
            }
        }
    }
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = HEX_999
        return nl
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(5)
            make.size.equalTo(CGSize(width: 150, height: 15))
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(nameLa.snp_bottom).offset(3)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(12.5)
            make.top.equalTo(portraitV).offset(1)
            make.right.equalTo(contentView).offset(-64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftVideoCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            if model.topic_group.count > 0 {
                nameLa.text = m.aliasName.count > 0 ? m.aliasName : m.nickName
            }
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: CGSize(width: CGFloat(model.estimate_width)*2, height: CGFloat(model.estimate_height)*2), toImgView: imgv)
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(58 + kScreenWidth-116-CGFloat(model.estimate_width)))
            }
        }
    }
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = HEX_999
        return nl
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var playImgv: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with: "JTVideoPlay")
        return pv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(5)
            make.size.equalTo(CGSize(width: 150, height: 15))
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(nameLa.snp_bottom).offset(3)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(12.5)
            make.top.equalTo(portraitV).offset(1)
            make.right.equalTo(contentView).offset(-64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentV.addSubview(playImgv)
        playImgv.snp_makeConstraints { (make) in
            make.center.equalTo(contentV)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftVoiceCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            if model.topic_group.count > 0 {
                nameLa.text = m.aliasName.count > 0 ? m.aliasName : m.nickName
            }
            contentLa.text = "\(AVFManager().durationOf(filePath: model.msgContent))\""
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            redDot.isHidden = model.voiceIsReaded
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(kScreenWidth-122-CGFloat(model.estimate_width)+35.5))
            }
            
        }
    }
    
    lazy var nameLa: UILabel = {
        let nl = UILabel()
        nl.font = UIFont.systemFont(ofSize: 14)
        nl.textColor = HEX_999
        return nl
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_COLOR(hexStr: "#333333")
        cl.numberOfLines = 0
        cl.adjustsFontSizeToFitWidth = true
        return cl
    }()
    lazy var redDot: UILabel = {
        let la = UILabel()
        la.layer.cornerRadius = 3
        la.backgroundColor = UIColor.red
        la.layer.masksToBounds = true
        return la
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.image = JTBundleTool.getBundleImg(with:"left_voice_cell")
        iv.animationImages = [JTBundleTool.getBundleImg(with: "left_voice_cell_1")!,JTBundleTool.getBundleImg(with: "left_voice_cell_2")!,JTBundleTool.getBundleImg(with: "left_voice_cell")!]
        iv.animationDuration = 1
        iv.animationRepeatCount = 0
        iv.isUserInteractionEnabled = false
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        
        contentView.addSubview(nameLa)
        nameLa.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(5)
            make.size.equalTo(CGSize(width: 150, height: 15))
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(nameLa.snp_bottom).offset(3)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        trangle.image = JTBundleTool.getBundleImg(with: "leftTrangle")
        contentView.addSubview(trangle)
        trangle.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(6.5)
            make.centerY.equalTo(portraitV)
            make.size.equalTo(CGSize(width: 6, height: 15))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.left.equalTo(trangle.snp_right)
            make.top.equalTo(portraitV).offset(-1)
            make.right.equalTo(contentView).offset(-64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentV)
            make.left.equalTo(contentV).offset(10)
            make.size.equalTo(CGSize(width: 12, height: 17))
        }
        
        contentV.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.left.equalTo(imgv.snp_right).offset(6)
            make.centerY.equalTo(imgv)
            make.right.equalTo(contentV).offset(5)
        }
        
        contentV.addSubview(redDot)
        redDot.snp_makeConstraints { (make) in
            make.right.equalTo(contentV).offset(-8)
            make.centerY.equalTo(contentV)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatTableRightCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-122-CGFloat(model.estimate_width)+45.5)
            
            }
        }
    }
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_COLOR(hexStr: "#333333")
        cl.numberOfLines = 0
        cl.adjustsFontSizeToFitWidth = true
        return cl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        trangle.image = JTBundleTool.getBundleImg(with: "rightTrangle")
        contentView.addSubview(trangle)
        trangle.snp_makeConstraints { (make) in
            make.right.equalTo(portraitV.snp_left).offset(-6.5)
            make.centerY.equalTo(portraitV)
            make.size.equalTo(CGSize(width: 6, height: 15))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.right.equalTo(trangle.snp_left)
            make.top.equalTo(portraitV).offset(-1)
            make.left.equalTo(contentView).offset(64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightImgVCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            imgv.image = ChatimagManager.manager.GetImageBy(MD5Str: model.msgContent)
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-116-CGFloat(model.estimate_width)+58)
            }
        }
    }
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.right.equalTo(portraitV.snp_left).offset(-12.5)
            make.top.equalTo(portraitV).offset(1)
            make.left.equalTo(contentView).offset(64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightVideoCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            let size = CGSize(width: CGFloat(model.estimate_width)*2, height: CGFloat(model.estimate_height)*2)
            _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: size, toImgView:imgv)
            
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-116-CGFloat(model.estimate_width)+58)
            }
        }
    }
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var playImgv: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with: "JTVideoPlay")
        return pv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.right.equalTo(portraitV.snp_left).offset(-12.5)
            make.top.equalTo(portraitV).offset(1)
            make.left.equalTo(contentView).offset(64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        contentV.addSubview(playImgv)
        playImgv.snp_makeConstraints { (make) in
            make.center.equalTo(contentV)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightVoiceCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            //            let m = DBManager.manager.getContactor(phone: model.receiverPhone)
            contentLa.text = "\(AVFManager().durationOf(filePath: model.msgContent))\""
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-122-CGFloat(model.estimate_width)+35.5)
            }
        }
    }
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: JTChatMenuView = {
        let cv = JTChatMenuView.init(frame: CGRect.zero)
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_COLOR(hexStr: "#333333")
        cl.numberOfLines = 0
        cl.adjustsFontSizeToFitWidth = true
        cl.textAlignment = .right
        return cl
    }()
    lazy var redDot: UILabel = {
        let la = UILabel()
        la.layer.cornerRadius = 3
        la.backgroundColor = UIColor.red
        la.layer.masksToBounds = true
        la.isHidden = true
        return la
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.image = JTBundleTool.getBundleImg(with:"voice_cell")
        iv.animationImages = [JTBundleTool.getBundleImg(with: "voice_cell_1")!,JTBundleTool.getBundleImg(with: "voice_cell_2")!,JTBundleTool.getBundleImg(with: "voice_cell")!]
        iv.animationDuration = 1
        iv.animationRepeatCount = 0
        iv.isUserInteractionEnabled = false
        iv.backgroundColor = UIColor.clear
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        trangle.image = JTBundleTool.getBundleImg(with: "rightTrangle")
        contentView.addSubview(trangle)
        trangle.snp_makeConstraints { (make) in
            make.right.equalTo(portraitV.snp_left).offset(-6.5)
            make.centerY.equalTo(portraitV)
            make.size.equalTo(CGSize(width: 6, height: 15))
        }
        
        contentView.addSubview(contentV)
        contentV.snp_makeConstraints { (make) in
            make.right.equalTo(trangle.snp_left)
            make.top.equalTo(portraitV).offset(-1)
            make.left.equalTo(contentView).offset(64)
            make.bottom.equalTo(contentView).offset(-11)
        }
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.centerY.equalTo(contentV)
            make.right.equalTo(contentV).offset(-10)
            make.size.equalTo(CGSize(width: 12, height: 17))
        }
        
        contentV.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.right.equalTo(imgv.snp_left).offset(-6)
            make.centerY.equalTo(imgv)
            make.left.equalTo(contentV).offset(5)
        }
        
        contentV.addSubview(redDot)
        redDot.snp_makeConstraints { (make) in
            make.left.equalTo(contentV).offset(8)
            make.centerY.equalTo(contentV)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
