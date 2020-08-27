//
//  BaseCollectionView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/20.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxCocoa
import RxSwift
import EmptyDataSet_Swift
@objc class BaseCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = HEX_FFF
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        emptyDataSetSource = self
        emptyDataSetDelegate = self
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BaseCollectionView: EmptyDataSetSource, EmptyDataSetDelegate {
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let mstr = NSMutableAttributedString.init(string: "暂无数据")
        mstr.addAttributes([NSAttributedString.Key.foregroundColor : HEX_LightBlue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: NSRange(location: 0, length: mstr.string.count))
        return mstr
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let img = UIImage.init(named: "emptyPlaceholder")
        return img
    }
    
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
