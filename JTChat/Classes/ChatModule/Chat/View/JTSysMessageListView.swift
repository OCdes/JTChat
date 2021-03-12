//
//  JTSysMessageListView.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/3/12.
//

import UIKit

class JTSysMessageListView: BaseTableView {
    var dataArr: Array<JTSysMessageItemModel> = []
    var viewModel: JTSysMessageListViewModel?
    init(frame: CGRect, style: UITableView.Style, viewModel vm: JTSysMessageListViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        backgroundColor = HEX_COLOR(hexStr: "#f5f5f5")
        separatorStyle = .none
        delegate = self
        dataSource = self
        register(JTSysMessageItemCell.self, forCellReuseIdentifier: "JTSysMessageItemCell")
        _ = viewModel?.rx.observe([Any].self, "dataArr").subscribe(onNext: { [weak self](arr) in
            if let a = arr as? [JTSysMessageItemModel] {
                self?.dataArr = a
            }
            self?.reloadData()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension JTSysMessageListView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JTSysMessageItemCell = tableView.dequeueReusableCell(withIdentifier: "JTSysMessageItemCell", for: indexPath) as! JTSysMessageItemCell
        let m = dataArr[indexPath.section]
//        if indexPath.section == 0 {
//            let m = JTSysMessageItemModel()
//            m.title = "精特消息"
//            m.creatTime = "2021-03-12"
//            m.sender = "财务专员"
//            m.content = "定积分大奖哦发就发放假啊索朗多吉开发接口芬达发即将开始的啊烦死了就发拉屎坑发掘发发就立刻发链接阿斯顿发生发就打算开发了"
//            cell.model = m
//        }
        cell.model = m
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let m = dataArr[section]
        let timeLa = UILabel()
        timeLa.text = m.creatTime
        timeLa.textAlignment = .center
        timeLa.font = UIFont(name: "\(timeLa.font.fontName)-Medium", size: 11)
        return timeLa
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = dataArr[indexPath.section]
        if m.jumpUrl.count > 0 {
            let vc = JTSysMessageDetailVC()
            vc.url = m.jumpUrl
            viewModel?.navigationVC?.pushViewController(vc, animated: true)
        } else {
            SVPShowError(content: "当前消息暂无详情")
        }
    }
    
}

class JTSysMessageItemCell: BaseTableCell {
    var model: JTSysMessageItemModel = JTSysMessageItemModel() {
        didSet {
            self.titlelLa.text = model.title
            self.timeLa.text = "\(model.creatTime)         \(model.sender)"
            let parastyle = NSMutableParagraphStyle.init()
            parastyle.lineSpacing = 15
            parastyle.lineBreakMode = .byTruncatingTail
            self.contentLa.attributedText = NSAttributedString(string: model.content, attributes: [NSAttributedString.Key.paragraphStyle : parastyle])
        }
    }
    lazy var titlelLa: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.boldSystemFont(ofSize: 16)
        tl.textColor = HEX_COLOR(hexStr: "#040404")
        return tl
    }()
    lazy var timeLa: UILabel = {
        let tl = UILabel()
        tl.textColor = HEX_999
        tl.font = UIFont(name: "\(tl.font.fontName)-Medium", size: 11)
        return tl
    }()
    lazy var contentLa: UILabel = {
        let cl = UILabel()
        cl.textColor = HEX_COLOR(hexStr: "#040404")
        cl.font = UIFont(name: "\(cl.font.fontName)-Medium", size: 14)
        cl.numberOfLines = 2
        return cl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        let bgv = UIView()
        bgv.backgroundColor = HEX_FFF
        bgv.layer.cornerRadius = 4
        bgv.layer.masksToBounds = true
        contentView.addSubview(bgv)
        bgv.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        }
        
        bgv.addSubview(titlelLa)
        titlelLa.snp_makeConstraints { (make) in
            make.left.equalTo(bgv).offset(10)
            make.top.equalTo(bgv).offset(12.5)
            make.right.equalTo(bgv).offset(-10)
            make.height.equalTo(28)
        }
        
        bgv.addSubview(timeLa)
        timeLa.snp_makeConstraints { (make) in
            make.left.right.equalTo(titlelLa)
            make.top.equalTo(titlelLa.snp_bottom).offset(5)
            make.height.equalTo(21)
        }
        
        bgv.addSubview(contentLa)
        contentLa.snp_makeConstraints { (make) in
            make.left.right.equalTo(titlelLa)
            make.top.equalTo(timeLa.snp_bottom)
            make.height.equalTo(71)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        bgv.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.top.equalTo(contentLa.snp_bottom).offset(5)
            make.left.right.equalTo(titlelLa)
            make.height.equalTo(0.5)
        }
        
        let checkLa = UILabel()
        checkLa.textColor = HEX_333
        checkLa.font = UIFont(name: "\(checkLa.font.fontName)-Medium", size: 14)
        checkLa.text = "查看详情"
        bgv.addSubview(checkLa)
        checkLa.snp_makeConstraints { (make) in
            make.left.equalTo(titlelLa)
            make.top.equalTo(line.snp_bottom)
            make.size.equalTo(CGSize(width: 65, height: 35))
        }
        
        let arrow = UIImageView()
        arrow.image = JTBundleTool.getBundleImg(with: "trArrow")
        bgv.addSubview(arrow)
        arrow.snp_makeConstraints { (make) in
            make.right.equalTo(titlelLa)
            make.centerY.equalTo(checkLa)
            make.size.equalTo(CGSize(width: 5.5, height: 10))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

