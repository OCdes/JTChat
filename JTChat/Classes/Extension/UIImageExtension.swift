//
//  UIImageExtension.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/5.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

extension  UIImage {
  open class func imageWith(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: 1, height:     1)
    var alphaChannel: CGFloat = 0.01
        color.getRed(nil, green: nil, blue: nil, alpha: &alphaChannel)
        let isOpaqueImg: Bool = (alphaChannel == 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, isOpaqueImg, UIScreen.main.scale)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
