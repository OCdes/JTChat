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
class ChatTableView: UITableView {
    var dataArr: Array<MessageSectionModel> = []
    var viewModel: ChatViewModel?
    var recordManager: RecorderManager = RecorderManager()
    var previousImgv: UIImageView?
    var playerVC: AVPlayerViewController = AVPlayerViewController()
    var tapSubject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ChatViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = HEX_COLOR(hexStr: "#EBEBEB")
        separatorStyle = .none
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2)) {
                let section = self.numberOfSections(in: self)
                if section > 0 {
                    let rows = self.dataArr[section-1].rowsArr.count-1
                    if rows > 0 {
                        self.scrollToRow(at: IndexPath(row: rows-1, section:section-1), at: .middle, animated: animated ?? false)
                    }
                }
                
            }
        }
    }
    
    @objc func tableViewTap() {
        self.tapSubject.onNext("")
    }
    
    deinit {
        if let iv = self.previousImgv {
            iv.stopAnimating()
        }
        self.recordManager.stopPlayAudio(by: "")
        print(" chattableview 销毁了")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatTableView: UITableViewDelegate, UITableViewDataSource {
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
                return cell
            } else if model.packageType == 2 && model.msgContent.contains(".mp4") {
                let cell: RightVideoCell = tableView.dequeueReusableCell(withIdentifier: "RightVideoCell", for: indexPath) as! RightVideoCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                cell.contentV.addGestureRecognizer(tap)
                return cell
            } else if model.packageType == 2 {
                let cell: RightImgVCell = tableView.dequeueReusableCell(withIdentifier: "RightImgVCell", for: indexPath) as! RightImgVCell
                cell.model = model
                cell.contentV.indexPath = indexPath
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
//                cell.contentV.addGestureRecognizer(tap)
                return cell
            }  else {
                let cell: ChatTableRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableRightCell", for: indexPath) as! ChatTableRightCell
                cell.model = model
                cell.contentV.indexPath = indexPath
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
//                cell.contentV.addGestureRecognizer(tap)
                return cell
            }
        } else {
            if model.packageType == 2 && model.msgContent.contains(".wav") {
                let cell: LeftVoiceCell = tableView.dequeueReusableCell(withIdentifier: "LeftVoiceCell", for: indexPath) as! LeftVoiceCell
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tag(tap:)))
                cell.model = model
                cell.contentV.indexPath = indexPath
                cell.contentV.addGestureRecognizer(tap)
                return cell
            } else if model.packageType == 2 && model.msgContent.contains(".mp4") {
                let cell: LeftVideoCell = tableView.dequeueReusableCell(withIdentifier: "LeftVideoCell", for: indexPath) as! LeftVideoCell
                cell.model = model
                cell.contentV.indexPath = indexPath
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
                cell.contentV.addGestureRecognizer(tap)
                return cell
            } else if model.packageType == 2 {
                let cell: LeftImgVCell = tableView.dequeueReusableCell(withIdentifier: "LeftImgVCell", for: indexPath) as! LeftImgVCell
                cell.model = model
                cell.contentV.indexPath = indexPath
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
//                cell.contentV.addGestureRecognizer(tap)
                return cell
            } else {
                let cell: ChatTableLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableLeftCell", for: indexPath) as! ChatTableLeftCell
                cell.model = model
                cell.contentV.indexPath = indexPath
//                let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapNormalCell(tap:)))
//                cell.contentV.addGestureRecognizer(tap)
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
                imgv.startAnimating()
                self.previousImgv = imgv
                let duration = (AVFManager().durationOf(filePath: model.msgContent))
                self.recordManager.stopPlayAudio(by: "")
                self.recordManager.playAudio(by: model.msgContent)
                if !model.voiceIsReaded {
                    model.voiceIsReaded = true
                    DBManager.manager.updateChatLog(model: model)
                }
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(duration)) {
                    DispatchQueue.main.async {
                        imgv.stopAnimating()
                        self.recordManager.stopPlayAudio(by: model.msgContent)
                    }
                }
            }
            
        }
        
        
    }
    
    @objc func longPress(long: UILongPressGestureRecognizer) {
        let menu = UIMenuController.shared
        let cItem = UIMenuItem.init(title: "复制", action: #selector(copyItem))
        let reItem = UIMenuItem.init(title: "转发", action: #selector(retweetItem))
        let deItem = UIMenuItem.init(title: "删除", action: #selector(deletItem))
        menu.menuItems = [cItem,reItem,deItem]
        menu.setTargetRect(CGRect(x: 30, y: 5, width: 100, height: 30), in: long.view!)
        menu.setMenuVisible(true, animated: true)
    }
    
    
    
    @objc func copyItem() {
        
    }
    
    @objc func retweetItem() {
        
    }
    
    @objc func deletItem() {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArr[indexPath.section].rowsArr[indexPath.row]
        return CGFloat(model.estimate_height > 62 ? model.estimate_height : 62)
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
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            if model.packageType == 1 {
                contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
                imgv.isHidden = true
            } else {
                if model.msgContent.contains("mp4") {
                    _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: CGSize(width: CGFloat(model.estimate_width), height: CGFloat(model.estimate_height)), toImgView: imgv)
                } else {
                    imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
                }
                imgv.isHidden = false
            }
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(35.5+kScreenWidth-122-CGFloat(model.estimate_width)))
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.init(name: "iconfont", size: 16)
        cl.textColor = HEX_333
        cl.numberOfLines = 0
        cl.isUserInteractionEnabled = true
        return cl
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.isHidden = true
        return iv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 6, height: 15), false, UIScreen.main.scale)
            let c = UIGraphicsGetCurrentContext()
            if let context = c {
                context.saveGState()
                context.setFillColor(HEX_FFF.cgColor)
                var points = [CGPoint](repeating: CGPoint.zero, count: 3)
                points[0] = CGPoint(x: 6, y: 0)
                points[1] = CGPoint(x: 0, y: 5)
                points[2] = CGPoint(x: 6, y: 10)
                context.addLines(between: points)
                context.closePath()
                context.drawPath(using: .fill)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                context.restoreGState()
                DispatchQueue.main.async {
                    trangle.image = image
                }
            }
        }
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
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftImgVCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(58 + kScreenWidth-116-CGFloat(model.estimate_width)))
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
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
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(11)
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftVideoCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.senderPhone)
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: CGSize(width: CGFloat(model.estimate_width), height: CGFloat(model.estimate_height)), toImgView: imgv)
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(58 + kScreenWidth-116-CGFloat(model.estimate_width)))
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
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
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(11)
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
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LeftVoiceCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            //            let m = DBManager.manager.getContactor(phone: model.receiverPhone)
            contentLa.text = "\(AVFManager().durationOf(filePath: model.msgContent))\""
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            redDot.isHidden = model.voiceIsReaded
            contentV.snp_updateConstraints { (make) in
                make.right.equalTo(contentView).offset(-(kScreenWidth-122-CGFloat(model.estimate_width)+35.5))
            }
            
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_FFF
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_333
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
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(9.5)
            make.top.equalTo(contentView).offset(11)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        let trangle = UIImageView.init()
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 6, height: 15), false, UIScreen.main.scale)
            let c = UIGraphicsGetCurrentContext()
            if let context = c {
                context.saveGState()
                context.setFillColor(HEX_FFF.cgColor)
                var points = [CGPoint](repeating: CGPoint.zero, count: 3)
                points[0] = CGPoint(x: 6, y: 0)
                points[1] = CGPoint(x: 0, y: 5)
                points[2] = CGPoint(x: 6, y: 10)
                context.addLines(between: points)
                context.closePath()
                context.drawPath(using: .fill)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                context.restoreGState()
                DispatchQueue.main.async {
                    trangle.image = image
                }
            }
        }
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ChatTableRightCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            //            let m = DBManager.manager.getContactor(phone: model.receiverPhone)
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            if model.packageType == 1 {
                contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
                imgv.isHidden = true
            } else {
                if model.msgContent.contains("mp4") {
                    let size = CGSize(width: CGFloat(model.estimate_width), height: CGFloat(model.estimate_height))
                    _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: size, toImgView:imgv)
                } else {
                    imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
                }
                imgv.isHidden = false
            }
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-122-CGFloat(model.estimate_width)+35.5)
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_333
        cl.numberOfLines = 0
        cl.adjustsFontSizeToFitWidth = true
        return cl
    }()
    lazy var imgv: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 3
        iv.contentMode = .scaleAspectFit
        iv.layer.masksToBounds = true
        iv.isHidden = true
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
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 6, height: 15), false, UIScreen.main.scale)
            let c = UIGraphicsGetCurrentContext()
            if let context = c {
                context.saveGState()
                context.setFillColor(HEX_COLOR(hexStr: "#CEE6FA").cgColor)
                var points = [CGPoint](repeating: CGPoint.zero, count: 3)
                points[0] = CGPoint(x: 6, y: 5)
                points[1] = CGPoint(x: 0, y: 10)
                points[2] = CGPoint(x: 0, y: 0)
                context.addLines(between: points)
                context.closePath()
                context.drawPath(using: .fill)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                context.restoreGState()
                DispatchQueue.main.async {
                    trangle.image = image
                }
            }
        }
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
        
        contentV.addSubview(imgv)
        imgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightImgVCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-116-CGFloat(model.estimate_width)+58)
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    
    lazy var contentV: UIView = {
        let cv = UIView()
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RightVideoCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            portraitV.kf.setImage(with: URL(string: JTManager.manager.avatarUrl), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
                    let size = CGSize(width: CGFloat(model.estimate_width), height: CGFloat(model.estimate_height))
            _ = AVFManager().firstFrameOfVideo(filePath: model.msgContent, size: size, toImgView:imgv)
                    
            contentV.snp_updateConstraints { (make) in
                make.left.equalTo(contentView).offset(kScreenWidth-116-CGFloat(model.estimate_width)+58)
            }
        }
    }
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    
    lazy var contentV: UIView = {
        let cv = UIView()
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
            make.size.equalTo(CGSize(width: 45, height: 45))
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
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
        pv.layer.cornerRadius = 18
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        return pv
    }()
    lazy var contentV: UIView = {
        let cv = UIView()
        cv.layer.cornerRadius = 3
        cv.backgroundColor = HEX_COLOR(hexStr: "#CEE6FA")
        return cv
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.font = UIFont.systemFont(ofSize: 16)
        cl.font = UIFont.init(name: "emoji", size: 16)
        cl.textColor = HEX_333
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
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 6, height: 15), false, UIScreen.main.scale)
            let c = UIGraphicsGetCurrentContext()
            if let context = c {
                context.saveGState()
                context.setFillColor(HEX_COLOR(hexStr: "#CEE6FA").cgColor)
                var points = [CGPoint](repeating: CGPoint.zero, count: 3)
                points[0] = CGPoint(x: 6, y: 5)
                points[1] = CGPoint(x: 0, y: 10)
                points[2] = CGPoint(x: 0, y: 0)
                context.addLines(between: points)
                context.closePath()
                context.drawPath(using: .fill)
                let image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                context.restoreGState()
                DispatchQueue.main.async {
                    trangle.image = image
                }
            }
        }
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
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(ChatTableView.copyItem) || action == #selector(ChatTableView.retweetItem) || action == #selector(ChatTableView.deletItem) {
            return true
        }
        return false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
