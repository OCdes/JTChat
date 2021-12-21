//
//  MessageAttriManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class MessageAttriManager: NSObject {
    static let manager = MessageAttriManager()
    func exchange(content: String) -> NSAttributedString {
        let characters = (content as NSString).components(separatedBy: "[")
        var emojiStrs:Array<String> = []
        let regularExp = try! NSRegularExpression(pattern: "\\[\\u4E00-\\u9FA5\\]", options: [])
        let matches = regularExp.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        for match in matches {
            print(NSStringFromRange(match.range))
        }
        for str in characters {
            if str.count > 0 {
                let arr = (str as NSString).components(separatedBy: "]")
                if arr.count > 0 {
                    if let s = arr.first {
                        if !emojiStrs.contains(s) {
                            emojiStrs.append(s)
                        }
                    }
                }
            }
        }
        let attribu = NSMutableAttributedString.init(string: content)
        let path = JTBundleTool.bundle.path(forResource: "iconName", ofType: "json")!
        let data = (NSData.init(contentsOfFile: path)!) as Data
        let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>
        
        for emStr in emojiStrs.reversed() {
            if let name = dict?["\(emStr)"] {
                while attribu.string.contains("[\(emStr)]") {
                    var ranges = Array<NSRange>()
                    _ = findAimstrAllRange(baseStr: attribu.string as NSString, aimStr: "[\(emStr)]", baseRange: NSRange.init(location: 0, length: attribu.string.count), result: &ranges)
                    if let range = ranges.first {
                        let attac = NSTextAttachment()
                        attac.image = JTBundleTool.getBundleImg(with:(name as! String))
                        attac.bounds = CGRect(x: 0, y: -5, width: 20, height: 20)
                        let att = NSMutableAttributedString.init(string: "")
                        att.append(NSAttributedString.init(attachment: attac))
                        attribu.replaceCharacters(in: range, with: att)
                    }
                }
            }
            
        }
        let paragraphyStyle = NSMutableParagraphStyle.init()
        attribu.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphyStyle, NSAttributedString.Key.kern : 0.3, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16)], range: NSRange.init(location: 0, length: attribu.length))
        
        return attribu
    }
    
    func emojiString() {
        
    }
    
    func findAimstrAllRange(baseStr : NSString, aimStr: String, baseRange : NSRange, result : inout Array<NSRange>) -> Array<NSRange> {

        let range = baseStr.range(of: aimStr, options: NSString.CompareOptions.literal, range: baseRange)
        //找到
        if range.length > 0{
            result.append(range)
            let detectLength = range.location + range.length
            let rangeNew = NSRange(location: detectLength, length: baseStr.length - detectLength)
            _ = findAimstrAllRange(baseStr: baseStr, aimStr: aimStr, baseRange: rangeNew, result: &result)
        }
        return result
    }
    
}
