//
//  SelectGroupMemListView.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/2/20.
//

import UIKit
import RxSwift
class SelectGroupMemListView: UITableView {
    var dataArr: Array<GroupMemberModel> = []
    var viewModel: GroupInfoViewModel?
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
        _ = viewModel!.subject.subscribe(onNext: { [weak self](a) in
            self?.dataArr = self?.viewModel?.model.membersList ?? []
            self?.reloadData()
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SelectGroupMemListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return dataArr.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupMemCell = tableView.dequeueReusableCell(withIdentifier: "GroupMemCell", for: indexPath) as! GroupMemCell
        if indexPath.section == 0 {
            cell.titleLa.text = "所有人(\(dataArr.count))"
        } else {
            let m = dataArr[indexPath.row]
            cell.portraitV.kf.setImage(with: URL(string: m.avatar), placeholder: JTBundleTool.getBundleImg(with:"approvalPortrait"))
            cell.titleLa.text = m.nickname
        }
        cell.markLa.isHidden = true
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
        if indexPath.section == 0 {
            self.subject.onNext("所有人")
        } else {
            let m = dataArr[indexPath.row]
            self.subject.onNext(m)
        }
    }
    
}
