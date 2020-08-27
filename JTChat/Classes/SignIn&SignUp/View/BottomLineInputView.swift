//
//  BottomLineInputView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/5.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class BottomLineInputView: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = HEX_COLOR(hexStr: "#414141").cgColor
        layer.borderWidth = 0.3
        layer.cornerRadius = 3.02
        layer.masksToBounds = true;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
