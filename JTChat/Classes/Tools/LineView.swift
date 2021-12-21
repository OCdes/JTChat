//
//  LineView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/1/18.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

@objc class LineView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HEX_COLOR(hexStr: kIsFlagShip ? "#1A1C29" : "#e1e1e1")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
