//
//  AddFriendTableView.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit

class AddFriendTableView: BaseTableView {
    var dataArr: Array<ApplyNoteModel> = [] {
        didSet {
            self.reloadData()
        }
    }
    var viewModel: AddFriendApplyViewModel?
    init(frame: CGRect, style: UITableView.Style, viewModel vm: AddFriendApplyViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        dataArr = vm.dataArr
        delegate = self
        dataSource = self
        register(AddFriendAppyCell.self, forCellReuseIdentifier: "AddFriendAppyCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddFriendTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddFriendAppyCell = tableView.dequeueReusableCell(withIdentifier: "AddFriendAppyCell", for: indexPath) as! AddFriendAppyCell
        cell.model = dataArr[indexPath.row]
        cell.agreeBtn.tag = indexPath.row
        cell.disagreeBtn.tag = indexPath.row
        cell.agreeBtn.addTarget(self, action: #selector(agreeBtnClicked(btn:)), for: .touchUpInside)
        cell.disagreeBtn.addTarget(self, action: #selector(disagreeBtnClicked(btn:)), for: .touchUpInside)
        return cell
    }
    
    @objc func agreeBtnClicked(btn: UIButton) {
        self.viewModel!.dealFriendApply(model: dataArr[btn.tag], isAgreen: true)
    }
    
    @objc func disagreeBtnClicked(btn: UIButton) {
        self.viewModel!.dealFriendApply(model: dataArr[btn.tag], isAgreen: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
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
        pv.image = JTBundleTool.getBundleImg(with:"groupicon")
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

