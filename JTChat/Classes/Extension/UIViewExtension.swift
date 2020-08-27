//
//  UIViewExtension.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/1/17.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
var indexPathKey = 1020
extension UIView {
    var indexPath: IndexPath {
        set {
            objc_setAssociatedObject(self, &indexPathKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &indexPathKey) as? IndexPath {
                return rs
            }
            return IndexPath.init(row: 0, section: 0)
        }
    }
}
