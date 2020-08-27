//
//  ChatTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class ChatTableView: BaseTableView {
    var dataArr: Array<MessageSectionModel> = []
    var viewModel: ChatViewModel?
    var tapSubject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: ChatViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = HEX_COLOR(hexStr: "#EBEBEB")
        separatorStyle = .none
        delegate = self
        dataSource = self
        register(ChatTableLeftCell.self, forCellReuseIdentifier: "ChatTableLeftCell")
        register(ChatTableRightCell.self, forCellReuseIdentifier: "ChatTableRightCell")
        let _ = viewModel?.subject.subscribe(onNext: { [weak self](count) in
            let numOfSection = self!.numberOfSections(in: self!)
            self!.dataArr = (self!.viewModel?.dataArr ?? [])
            self!.reloadData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.init(uptimeNanoseconds: 3)) {
                if self!.viewModel!.page > 1 {
                    let offsection = self!.dataArr.count - numOfSection
                    let offrow = self!.numberOfRows(inSection: offsection > 0 ? offsection-1 : offsection)
                    self!.scrollToRow(at: IndexPath(row: offrow > 0 ? offrow-1 : offrow, section: offsection > 0 ? offsection-1 : offsection), at: .top, animated: false)
                } else {
                    self!.scrollTo(offsetY: self!.contentSize.height, animated: false)
                }
            }
        })
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tableViewTap)))
    }
    
    func scrollTo(offsetY:CGFloat, animated: Bool?) {
//        self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y-offsetY), animated: animated ?? false)
        if self.dataArr.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2)) {
                let section = self.numberOfSections(in: self)
                let rows = self.numberOfRows(inSection: section > 0 ? section-1 : 0)
                self.scrollToRow(at: IndexPath(row: rows>0 ? rows-1 : 0, section: section > 0 ? section-1 : 0), at: .bottom, animated: animated ?? false)
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

extension ChatTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr[section].rowsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArr[indexPath.section].rowsArr[indexPath.row]
        if !model.isRemote {
            let cell: ChatTableRightCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableRightCell", for: indexPath) as! ChatTableRightCell
            cell.model = model
            let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(long:)))
            cell.contentLa.addGestureRecognizer(longpress)
            return cell
        } else {
            let cell: ChatTableLeftCell = tableView.dequeueReusableCell(withIdentifier: "ChatTableLeftCell", for: indexPath) as! ChatTableLeftCell
            cell.model = model
            let longpress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(long:)))
            cell.contentLa.addGestureRecognizer(longpress)
            return cell
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
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: UIImage(named: "approvalPortrait"))
            if model.packageType == 1 {
                contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
                imgv.isHidden = true
            } else {
                imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
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
        pv.image = UIImage(named: "approvalPortrait")
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

class ChatTableRightCell: BaseTableCell {
    var model: MessageModel = MessageModel() {
        didSet {
            let m = DBManager.manager.getContactor(phone: model.receiverPhone)
            portraitV.kf.setImage(with: URL(string: m.avatarUrl), placeholder: UIImage(named: "approvalPortrait"))
            if model.packageType == 1 {
                contentLa.attributedText = MessageAttriManager.manager.exchange(content: "\(model.msgContent)")
                imgv.isHidden = true
            } else {
                imgv.image = UIImage.init(data: Data.init(base64Encoded: model.msgContent)!)
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
        pv.image = UIImage(named: "approvalPortrait")
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