//
//  AddFriendTableView.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit

class AddFriendTableView: BaseTableView {
    
    var viewModel: AddFriendApplyViewModel = AddFriendApplyViewModel()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: AddFriendApplyViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        register(AddFriendAppyCell.self, forCellReuseIdentifier: "AddFriendAppyCell")
        register(MyApplyNoteCell.self, forCellReuseIdentifier: "MyApplyNoteCell")
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            self!.reloadData()
            print("申请列表线程: \(Thread.current)")
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddFriendTableView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var num = 0
        if self.viewModel.myApplyArr.count > 0 {
            num += 1
        }
        if self.viewModel.dealApplyArr.count > 0 {
            num += 1
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.myApplyArr.count > 0 && self.viewModel.dealApplyArr.count > 0 {
            if section == 1 {
                return self.viewModel.myApplyArr.count
            } else {
                return self.viewModel.dealApplyArr.count
            }
        } else {
            return self.viewModel.myApplyArr.count > 0 ? self.viewModel.myApplyArr.count : self.viewModel.dealApplyArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.myApplyArr.count > 0 && self.viewModel.dealApplyArr.count > 0 {
            if indexPath.section == 1 {
                let cell: MyApplyNoteCell = tableView.dequeueReusableCell(withIdentifier: "MyApplyNoteCell", for: indexPath) as! MyApplyNoteCell
                cell.model = self.viewModel.myApplyArr[indexPath.row]
                return cell
            } else {
                let cell: AddFriendAppyCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendAppyCell", for: indexPath) as! AddFriendAppyCell
                cell.model = self.viewModel.dealApplyArr[indexPath.row]
                cell.agreeBtn.tag = indexPath.row
                cell.disagreeBtn.tag = indexPath.row
                cell.agreeBtn.addTarget(self, action: #selector(agreeBtnClicked(btn:)), for: .touchUpInside)
                cell.disagreeBtn.addTarget(self, action: #selector(disagreeBtnClicked(btn:)), for: .touchUpInside)
                return cell
            }
        } else {
            if self.viewModel.myApplyArr.count > 0  {
                let cell: MyApplyNoteCell = tableView.dequeueReusableCell(withIdentifier: "MyApplyNoteCell", for: indexPath) as! MyApplyNoteCell
                cell.model = self.viewModel.myApplyArr[indexPath.row]
                return cell
            } else {
                let cell: AddFriendAppyCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendAppyCell", for: indexPath) as! AddFriendAppyCell
                cell.model = self.viewModel.dealApplyArr[indexPath.row]
                cell.agreeBtn.indexPath = indexPath
                cell.disagreeBtn.tag = indexPath.row
                cell.agreeBtn.addTarget(self, action: #selector(agreeBtnClicked(btn:)), for: .touchUpInside)
                cell.disagreeBtn.addTarget(self, action: #selector(disagreeBtnClicked(btn:)), for: .touchUpInside)
                return cell
            }
        }
        
    }
    
    @objc func agreeBtnClicked(btn: UIButton) {
        self.viewModel.dealFriendApply(model: self.viewModel.dealApplyArr[btn.tag], isAgreen: true)
    }
    
    @objc func disagreeBtnClicked(btn: UIButton) {
        self.viewModel.dealFriendApply(model: self.viewModel.dealApplyArr[btn.tag], isAgreen: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 30))
        v.backgroundColor = HEX_COLOR(hexStr: "#e1e1e1")
        let label = UILabel.init(frame: CGRect(x: 14, y: 0, width: kScreenWidth-28, height: 30))
        label.font = UIFont.systemFont(ofSize: 14)
        v.addSubview(label)
        if self.viewModel.myApplyArr.count > 0 && self.viewModel.dealApplyArr.count > 0 {
            if section == 1 {
                label.text = "我发起的"
            } else {
                label.text = "我收到的"
            }
        } else {
            label.text = self.viewModel.myApplyArr.count > 0 ? "我发起的" : "我收到的"
        }
        return v
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

class AddFriendAppyCell: BaseTableCell {
    var model: ApplyNoteModel = ApplyNoteModel() {
        didSet {
            self.portraitV.kf.setImage(with: URL(string: model.avatar), placeholder: JTBundleTool.getBundleImg(with: "approvalPortrait"))
            self.titleLa.text = model.nickname
            self.remarkLa.text = model.remark
            self.statusLa.isHidden = !model.finished
        }
    }
    private lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        pv.layer.cornerRadius = 19
        pv.layer.masksToBounds = true
        return pv
    }()
    private lazy var titleLa: UILabel = {
        let tl = UILabel()
        return tl
    }()
    private lazy var remarkLa: UILabel = {
        let rl = UILabel()
        return rl
    }()
    lazy var statusLa: UILabel = {
        let sl = UILabel()
        sl.text = "已添加"
        sl.textAlignment = .center
        sl.font = UIFont.systemFont(ofSize: 14)
        sl.textColor = HEX_COLOR(hexStr: "#e1e1e1")
        sl.isHidden = true
        return sl
    }()
    lazy var agreeBtn: UIButton = {
        let ab = UIButton()
        ab.setImage(JTBundleTool.getBundleImg(with: "agreeIcon"), for: .normal)
        return ab
    }()
    lazy var disagreeBtn: UIButton = {
        let db = UIButton()
        db.setImage(JTBundleTool.getBundleImg(with: "disagreeIcon"), for: .normal)
        return db
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(11.5)
            make.top.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-13)
            make.width.equalTo(portraitV.snp_height)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(20)
            make.top.equalTo(portraitV)
            make.right.equalTo(contentView).offset(-100)
        }
        
        contentView.addSubview(remarkLa)
        remarkLa.snp_makeConstraints { (make) in
            make.top.equalTo(portraitV.snp_centerY)
            make.left.right.equalTo(titleLa)
        }
        
        contentView.addSubview(statusLa)
        statusLa.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(contentView)
            make.width.equalTo(100)
        }
        
        contentView.addSubview(self.agreeBtn)
        self.agreeBtn.snp_makeConstraints { (make) in
            make.top.bottom.equalTo(contentView)
            make.right.equalTo(contentView).offset(-20)
            make.width.equalTo(40)
        }
        
        contentView.addSubview(self.disagreeBtn)
        self.disagreeBtn.snp_makeConstraints { (make) in
            make.right.equalTo(self.agreeBtn.snp_left)
            make.top.size.equalTo(self.agreeBtn)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.equalTo(titleLa)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyApplyNoteCell: BaseTableCell {
    var model: MyApplyNoteModel? {
        didSet {
            self.portraitV.kf.setImage(with: URL(string: model!.avatarUrl), placeholder: JTBundleTool.getBundleImg(with: "approvalPortrait"))
            self.titleLa.text = model!.nickName
            self.statusLa.text = model!.approveStatus
        }
    }
    private lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with:"approvalPortrait")
        pv.layer.cornerRadius = 19
        pv.layer.masksToBounds = true
        return pv
    }()
    private lazy var titleLa: UILabel = {
        let tl = UILabel()
        return tl
    }()
    lazy var statusLa: UILabel = {
        let sl = UILabel()
        sl.text = ""
        sl.textAlignment = .center
        sl.font = UIFont.systemFont(ofSize: 14)
        sl.textColor = HEX_COLOR(hexStr: "#e1e1e1")
        return sl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = HEX_FFF
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(contentView).offset(11.5)
            make.top.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-13)
            make.width.equalTo(portraitV.snp_height)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(20)
            make.top.bottom.equalTo(portraitV)
            make.right.equalTo(contentView).offset(-100)
        }
        
        contentView.addSubview(statusLa)
        statusLa.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(contentView)
            make.width.equalTo(100)
        }
        
        let line = LineView.init(frame: CGRect.zero)
        contentView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.left.right.equalTo(titleLa)
            make.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
