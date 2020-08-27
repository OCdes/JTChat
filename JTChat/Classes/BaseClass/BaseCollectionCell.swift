//
//  BaseCollectionCell.swift
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
@objc class BaseCollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
