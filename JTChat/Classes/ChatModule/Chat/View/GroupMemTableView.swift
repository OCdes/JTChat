//
//  GroupMemTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/6.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
class GroupMemTableView: BaseTableView {
    var dataArr: Array<GroupMemberModel> = []
    var viewModel: GroupInfoViewModel?
    var selectMode: Bool = false
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupInfoViewModel) {
        super.init(frame: frame, style: style)
        viewModel = vm
        dataArr = vm.model.membersList
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
        register(GroupMemCell.self, forCellReuseIdentifier: "GroupMemCell")
        if ((USERDEFAULT.object(forKey: "phone") ?? "") as? String) == vm.model.creator {
            let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(ge:)))
            self.addGestureRecognizer(longPress)
        }
    }
    
    @objc func longPress(ge: UILongPressGestureRecognizer) {
        let point = ge.location(in: self)
        let indexPath = self.indexPathForRow(at: point)
        if let i = indexPath {
            let m = self.dataArr[i.row]
            if m.memberPhone != viewModel!.model.creator && viewModel!.model.creator == JTManager.manager.phone {
                let vc = UIAlertController.init(title: "提示", message: "是否要将\(m.nickname)移除群组", preferredStyle: .alert)
                let sure = UIAlertAction.init(title: "确定", style: .default) { (a) in
                    self.dataArr.remove(at: i.row)
                    self.reloadData()
                    self.viewModel?.removeMember(m: m)
                }
                vc.addAction(sure)
                let cancle = UIAlertAction.init(title: "取消", style: .cancel) { (a) in
                    
                }
                vc.addAction(cancle)
                self.viewModel?.navigationVC?.present(vc, animated: true, completion: nil)
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupMemTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = dataArr[indexPath.row]
        let cell: GroupMemCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemCell", for: indexPath) as! GroupMemCell
        cell.portraitV.kf.setImage(with: URL(string: m.avatar), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
        cell.titleLa.text = m.nickname
        cell.markLa.isHidden = m.memberPhone != viewModel!.model.creator
        return cell
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
        if selectMode {
            let em = dataArr[indexPath.row]
            self.subject.onNext(em)
        } else {
            let em = dataArr[indexPath.row]
            let mm = ContactorInfoViewModel()
            mm.employeeModel.phone = em.memberPhone
            let vc = ContacterInfoVC()
            vc.viewModel = mm
            viewModel?.navigationVC?.pushViewController(vc, animated: true)
        }
    }
    
}

class GroupMemCell: ContactersTableCell {
    lazy var markLa: UILabel = {
        let ml = UILabel()
        ml.font = UIFont.systemFont(ofSize: 10)
        ml.textColor = HEX_999
        ml.textAlignment = .right
        ml.text = "群主"
        ml.isHidden = true
        return ml
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(markLa)
        markLa.snp_makeConstraints { (make) in
            make.right.equalTo(contentView).offset(-10)
            make.top.bottom.equalTo(contentView)
            make.width.equalTo(25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
