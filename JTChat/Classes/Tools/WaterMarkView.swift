//
//  WaterMarkView.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/5/21.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import CoreFoundation
let HORIZONTAL_SPACE = 30//水平间距
let VERTICAL_SPACE = 50//竖直间距
let CG_TRANSFORM_ROTATION = (Double.pi / 6)//旋转角度(正旋45度 || 反旋45度)
var image = UIImage()

class WaterMarkView: UIImageView {

    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        let font = UIFont.systemFont(ofSize: 14)
        let color = HEX_COLOR(hexStr: "#F0F0F0").withAlphaComponent(0.2)
        
        let width = frame.width
        let height = frame.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        let sprtLength = sqrt(width*width+height*height)
        let attribute = [NSAttributedString.Key.font:font,
                         NSAttributedString.Key.foregroundColor:color]
        let markStr = text
        let attrStr = NSMutableAttributedString(string: markStr,attributes: attribute)
        let strHeight = attrStr.size().height
        let strWidth = attrStr.size().width
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.concatenate(CGAffineTransform(translationX: width/2, y: height/2))
        
        context?.concatenate(CGAffineTransform(rotationAngle: CGFloat(CG_TRANSFORM_ROTATION)))
        
        context?.concatenate(CGAffineTransform(translationX: -width/2, y: -height/2))
        //计算绘制行数和列数
        let horcount: Int = Int(sprtLength/(strWidth+CGFloat(HORIZONTAL_SPACE))+1)
        let vercount: Int = Int(sprtLength/(strHeight+CGFloat(VERTICAL_SPACE))+1)
        //
        let originX = -(sprtLength-width)/2
        let originY = -(sprtLength-height)/2
        
        var tempOriginX = originX
        var tempOriginY = originY
        
        for i in 0..<(horcount*vercount) {
            markStr.draw(in: CGRect(x: tempOriginX, y: tempOriginY, width: strWidth, height: strHeight), withAttributes: attribute)
            if i%horcount == 0 && i != 0 {
                tempOriginX = originX
                tempOriginY += (strHeight + CGFloat(VERTICAL_SPACE))
            } else {
                tempOriginX += (strWidth + CGFloat(HORIZONTAL_SPACE))
            }
        }
        
        let finalImg = UIGraphicsGetImageFromCurrentImageContext()
        context?.saveGState()
        UIGraphicsEndImageContext()
        image = finalImg
        
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isUserInteractionEnabled == false || self.isHidden == true || self.alpha <= 0.01 {
            return nil
        }
        
        if !self.point(inside: point, with: event) {
            return nil
        }
        
        for (_, value) in subviews.enumerated().reversed() {
            let cp = value.convert(point, to: value)
            let firstV = value.hitTest(cp, with: event)
            if (firstV != nil) {
                return firstV
            }
        }
        return self
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
}


