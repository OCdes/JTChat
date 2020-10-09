//
//  RecentDialogView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/28.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class RecentDialogView: UIScrollView {
    var viewModel: MessageViewModel = MessageViewModel()
    lazy var personalListView: MessageListView = {
        let pl = MessageListView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: self.frame.height), style: .grouped, viewModel: self.viewModel)
        return pl
    }()
    lazy var groupListView: MessageListView = {
        let pl = MessageListView.init(frame: CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: self.frame.height), style: .grouped, viewModel: self.viewModel)
        return pl
    }()
    init(frame: CGRect, viewModel vm: MessageViewModel) {
        super.init(frame: frame)
        self.viewModel = vm
        self.contentSize = CGSize(width: kScreenWidth*2, height: frame.height)
        self.isScrollEnabled = false
        addSubview(personalListView)
//        personalListView.snp_makeConstraints { (make) in
//            make.left.top.bottom.equalTo(self)
//            make.width.equalTo(kScreenWidth)
//        }
        addSubview(groupListView)
//        groupListView.snp_makeConstraints { (make) in
//            make.right.top.bottom.equalTo(self)
//            make.width.equalTo(kScreenWidth)
//        }
        _ = viewModel.subject.subscribe(onNext: { [weak self](a) in
            self!.personalListView.dataArr = self!.viewModel.personalListArr
            self!.groupListView.dataArr = self!.viewModel.groupListArr
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
