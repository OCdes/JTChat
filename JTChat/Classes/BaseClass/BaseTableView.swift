//
//  BaseTableView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/1/14.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxCocoa
import RxSwift
import EmptyDataSet_Swift
@objc class BaseTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        backgroundColor = HEX_FFF
        emptyDataSetSource = self
        emptyDataSetDelegate = self
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BaseTableView: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let mstr = NSMutableAttributedString.init(string: "暂无数据")
        mstr.addAttributes([NSAttributedString.Key.foregroundColor : HEX_LightBlue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: mstr.string.count))
        return mstr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let img = UIImage.init(named: "emptyPlaceholder")
        return img
    }
    
//    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return false
//    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        self.jt_startRefresh()
    }
    
}

