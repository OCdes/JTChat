//
//  StringExtension.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/8.
//  Copyright © 2020 WanCai. All rights reserved.
//

import Foundation

extension String {
    static func colorString(_ allStr: String, in colorStr: String, with color:UIColor) -> NSAttributedString {
        let mstr = NSMutableAttributedString.init(string: allStr)
        let range = (allStr as NSString).range(of: colorStr)
        if range.length > 0 {
            mstr.addAttributes([.foregroundColor:color], range: range)
        }
        return mstr
    }
}
