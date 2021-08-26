//
//  GroupManagerTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/6.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import YPImagePicker
class GroupManagerTableView: BaseTableView {
    var dataArr: Array<String> = ["解散群组","转让群主"]
    var viewModel: GroupInfoViewModel?
    init(frame: CGRect, style: UITableView.Style, viewModel vm: GroupInfoViewModel) {
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
        register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GroupManagerTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let m = dataArr[indexPath.row]
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.textLabel?.text = m
        cell.textLabel?.textColor = HEX_333
        cell.backgroundColor = kIsFlagShip ? HEX_GOLDBLACK : HEX_FFF
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
        let s = dataArr[indexPath.row]
        switch s {
        case "解散群组":
            self.viewModel?.deleGroup()
        case "转让群主":
            let vc = GroupMemVC()
            vc.viewModel.model = self.viewModel!.model
            vc.tableView.selectMode = true
            _ = vc.tableView.subject.subscribe(onNext: { (a) in
                if let mm = a as? GroupMemberModel, mm.memberPhone != JTManager.shareManager().phone{
                    self.viewModel?.signGroupOwnerTo(targetPhone: mm.memberPhone)
                    self.viewModel?.navigationVC?.popViewController(animated: true)
                } else {
//                    SVPShowError(content: "请选则要转让的人")
                }
            })
            self.viewModel?.navigationVC?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
