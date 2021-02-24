//
//  SelectGroupMemVC.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/2/20.
//

import UIKit
import RxSwift
class SelectGroupMemVC: BaseViewController {
    var viewModel: GroupInfoViewModel = GroupInfoViewModel()
    var subject: PublishSubject<[GroupMemberModel]> = PublishSubject<[GroupMemberModel]>()
    lazy var tableView: SelectGroupMemListView = {
        let tv = SelectGroupMemListView.init(frame: CGRect.zero, style: .grouped, viewModel: self.viewModel)
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "群成员";
        // Do any additional setup after loading the view.
        view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        self.viewModel.refreshData()
        
        _ = self.tableView.subject.subscribe(onNext: { [weak self](a) in
            if a is GroupMemberModel {
                self?.subject.onNext([(a as! GroupMemberModel)])
            } else {
                self?.subject.onNext(self?.viewModel.model.membersList ?? [])
            }
            self?.navigationController?.popViewController(animated: true)
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
