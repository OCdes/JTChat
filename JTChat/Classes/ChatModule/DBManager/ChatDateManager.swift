//
//  ChatDateManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/30.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class ChatDateManager: NSObject {
    static let manager = ChatDateManager()
    var zeroTimestamp: TimeInterval = 0
    override init() {
        super.init()
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date())
        dateComponent.hour = 0
        dateComponent.minute = 0
        dateComponent.second = 0
        let date = calendar.date(from: dateComponent)
        zeroTimestamp = date?.timeIntervalSince1970 ?? 0
    }
    
    func dealDate(byTimestamp: TimeInterval)->String {
        let substamp = zeroTimestamp - byTimestamp
        let dayStamp: TimeInterval = 24*60*60
        let date = Date.init(timeIntervalSince1970: byTimestamp)
        let formate = DateFormatter()
        formate.locale = Locale.init(identifier: "zh_cn")
        if byTimestamp > zeroTimestamp {
            formate.dateFormat = "aaa hh:mm"
        } else {
            if substamp < dayStamp {
                formate.dateFormat = "昨天 aaa hh:mm"
            } else if substamp < 2*dayStamp {
                formate.dateFormat = "前天 aaa hh:mm"
            } else if substamp < dayStamp*7 {
                formate.dateFormat = "EEEE"
            } else {
                formate.dateFormat = "MM.dd"
            }
        }
        
        return formate.string(from: date)
    }
    
    func dealDate(byTimeStr: String)->String {
        let oFormat = DateFormatter()
        oFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let odate = oFormat.date(from: byTimeStr)
        if let byTimestamp = odate?.timeIntervalSince1970 {
            let substamp = zeroTimestamp - byTimestamp
            let dayStamp: TimeInterval = 24*60*60
            let date = Date.init(timeIntervalSince1970: byTimestamp)
            let formate = DateFormatter()
            formate.locale = Locale.init(identifier: "zh_cn")
            if byTimestamp > zeroTimestamp {
                formate.dateFormat = "aaa hh:mm"
            } else {
                if substamp < dayStamp {
                    formate.dateFormat = "昨天 aaa hh:mm"
                } else if substamp < 2*dayStamp {
                    formate.dateFormat = "前天 aaa hh:mm"
                } else if substamp < dayStamp*7 {
                    formate.dateFormat = "EEEE"
                } else {
                    formate.dateFormat = "MM.dd"
                }
            }
            return formate.string(from: date)
        } else {
            return byTimeStr
        }
        
    }
}
