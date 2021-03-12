//
//  JTSysMessageListViewModel.swift
//  JTChat
//
//  Created by 袁炳生 on 2021/3/11.
//

import UIKit

class JTSysMessageListViewModel: BaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    
    override init() {
        super.init()
//        if let arr = USERDEFAULT.object(forKey: "latestJTMessageList") as? [[String:Any]], arr.count > 0 {
//            for var dict in arr {
//                dict["isReaded"] = true
//            }
//        }
        USERDEFAULT.setValue([], forKey: "latestJTMessageList")
        NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
    }
    
    func refreshData(scroll : UIScrollView) {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_FETCHSYSMESSAGELIST, params: [:], success: { (msg, code, response, data) in
            if let arr = data["data"] as? [[String:Any]] {
                self.dataArr = ([JTSysMessageItemModel].deserialize(from: arr) ?? []) as [Any]
            }
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        })
    }
    
}

class JTSysMessageItemModel: BaseModel {
    var title: String = ""
    var content: String = ""
    var creatTime: String = ""
    var sender: String = ""
    var jumpUrl: String = ""
}
