//
//  GroupSelectListView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/3.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class GroupSelectListView: BaseTableView {
    var dataArr: Array<Any> = [] {
        didSet {
            self.reloadData()
        }
    }
    var viewModel: GroupSelectViewModel?
    var selectSubject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupSelectViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        delegate = self
        dataSource = self
        tintColor = HEX_LightBlue
        register(GroupSelectListCell.self, forCellReuseIdentifier: "GroupSelectListCell")
        _ = viewModel?.rx.observe(Array<Any>.self, "dataArr").subscribe(onNext: { [weak self](arr) in
            self!.dataArr = arr ?? []
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupSelectListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupSelectListCell = tableView.dequeueReusableCell(withIdentifier: "GroupSelectListCell", for: indexPath) as! GroupSelectListCell
        let model = dataArr[indexPath.row] as! FriendModel
        cell.fmodel = model
        cell.seleBtn.tag = indexPath.row
        cell.seleBtn.addTarget(self, action: #selector(seleBtnClicked(btn:)), for: .touchUpInside)
        cell.isUserInteractionEnabled = !self.viewModel!.disables.contains(model.friendPhone)
        cell.contentView.alpha = self.viewModel!.disables.contains(model.friendPhone) ? 0.5 : 1
        return cell
    }
    
    @objc func seleBtnClicked(btn: UIButton) {
        let index = btn.tag
        let model = dataArr[index] as! FriendModel
        btn.isSelected = !btn.isSelected
        model.isSelected = btn.isSelected
        if btn.isSelected {
            self.viewModel?.selectArr.append(model)
            self.viewModel?.selePhones.append(model.friendPhone)
        } else {
            if let i = self.viewModel!.selePhones.firstIndex(of: model.friendPhone) {
                self.viewModel?.selectArr.remove(at: i)
                self.viewModel!.selePhones.remove(at: i)
            }
        }
        self.selectSubject.onNext("")
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.init(rawValue: UITableViewCell.EditingStyle.delete.rawValue | UITableViewCell.EditingStyle.insert.rawValue)!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

class GroupSelectListCell: BaseTableCell {
    var fmodel: FriendModel? {
        didSet {
            portraitV.kf.setImage(with: URL(string: fmodel!.avatar), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            titleLa.text = fmodel!.nickname
            seleBtn.isSelected = fmodel!.isSelected
        }
    }
    var cmodel: ContactorModel? {
        didSet {
            
        }
    }
    
    lazy var seleBtn: UIButton = {
        let sb = UIButton()
        sb.setImage(JTBundleTool.getBundleImg(with:"employee_selected"), for: .selected)
        sb.setImage(JTBundleTool.getBundleImg(with:"employee_not_selected"), for: .normal)
        return sb
    }()
    
    lazy var portraitV: UIImageView = {
        let pv = UIImageView()
        pv.image = JTBundleTool.getBundleImg(with:"groupicon")
        pv.layer.cornerRadius = 19
        pv.layer.masksToBounds = true
        return pv
    }()
    lazy var titleLa: UILabel = {
        let tl = UILabel()
        return tl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = HEX_FFF
        
        contentView.addSubview(seleBtn)
        seleBtn.snp_makeConstraints { (make) in
            make.left.top.bottom.equalTo(contentView)
            make.width.equalTo(50)
        }
        
        contentView.addSubview(portraitV)
        portraitV.snp_makeConstraints { (make) in
            make.left.equalTo(seleBtn.snp_right)
            make.top.equalTo(contentView).offset(13)
            make.bottom.equalTo(contentView).offset(-13)
            make.width.equalTo(portraitV.snp_height)
        }
        
        contentView.addSubview(titleLa)
        titleLa.snp_makeConstraints { (make) in
            make.left.equalTo(portraitV.snp_right).offset(20)
            make.centerY.equalTo(portraitV)
            make.right.equalTo(contentView).offset(-12)
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
