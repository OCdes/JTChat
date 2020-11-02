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
    
    open func imageAddSubImage(img: UIImage) -> UIImage? {
        var rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        let imageSize = self.size
        rect.origin.x = (imageSize.width - img.size.width)/2
        rect.origin.y = (imageSize.height - img.size.height)/2
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        img.draw(in: rect)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImg
    }
}
