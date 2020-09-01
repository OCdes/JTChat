//
//  InputView.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/4.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class InputView: BottomLineInputView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    //左图标
    init(frame: CGRect,leftImgStr leftStr: String, placeHolder holder:String) {
        super.init(frame: frame)
        let leftV = UIView(frame:CGRect(x:0, y:0, width:25.5, height:frame.height))
        let leftIcon = UIImageView(image: JTBundleTool.getBundleImg(with: leftStr))
        leftIcon.frame = CGRect(x: 0, y: 0, width: 15.5, height: 17.5)
        leftIcon.center.y = leftV.center.y
        leftV.addSubview(leftIcon)
        leftView = leftV
        leftViewMode = UITextField.ViewMode.always
        clearButtonMode = UITextField.ViewMode.whileEditing;
        attributedPlaceholder = NSMutableAttributedString(string: holder, attributes: [NSAttributedString.Key.foregroundColor:HEX_999])
        font = UIFont.systemFont(ofSize: 16)
        textColor = HEX_333
    }
    //右图标
    init(frame: CGRect,rightImgStr rightStr: String, placeHolder holder: String, action: Selector) {
        super.init(frame: frame)
        let leftV = UIView(frame:CGRect(x:0, y:0, width:10, height:frame.height))
        leftView = leftV
        leftViewMode = UITextField.ViewMode.always
        let rightV = UIView(frame:CGRect(x:0, y:0, width:25.5, height:frame.height))
        let rightBtn = UIButton.init(frame:CGRect(x:0, y:0, width:25.5, height:frame.height))
        rightBtn.setImage(JTBundleTool.getBundleImg(with:rightStr), for: UIControl.State.normal)
        rightBtn.addTarget(self, action: action, for: UIControl.Event.touchUpInside)
        rightV.addSubview(rightBtn)
        rightView = rightV
        rightViewMode = UITextField.ViewMode.whileEditing
        font = UIFont.systemFont(ofSize: 16)
        textColor = UIColor.white
        self.placeholder = holder
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

