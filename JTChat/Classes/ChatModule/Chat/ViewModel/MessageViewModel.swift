//
//  MessageViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/22.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
class MessageViewModel: BaseViewModel {
    var personalListArr: Array<FriendModel> = []
    var groupListArr: Array<FriendModel> = []
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    @objc dynamic var perNum: Int = 0
    @objc dynamic var groupNum: Int = 0
    override init() {
        super.init()
        let sub1 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATFRIENDSlIST, params: [:], success: { (msg, code, reponse, data) in
//            
        }) { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        }
        let sub2 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATGROUPlIST, params: [:], success: { (msg, code, response, data) in
            
        }) { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        }
        let _ = Observable.zip(sub1, sub2).subscribe(onNext: { (data1, data2) in
            let dict1 = data1 as! Dictionary<String, Any>
            let dict2 = data2 as! Dictionary<String, Any>
            var arr1: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict1["data"] ?? dict1["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            let arr2: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict2["data"] ?? dict2["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            arr1.append(contentsOf: arr2)
            for m in arr1 {
                m.isReaded = true
                DBManager.manager.addRecentChat(model: m)
            }
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kChatOnlineNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kReLoginName, object: nil)
    }
    
    @objc func updateRecentList() {
        getMessageList(scrollView: UIScrollView())
    }
    
    func getMessageList(scrollView: UIScrollView) {
        DBManager.manager.getRecentList { [weak self](arr1, arr2) in
            self!.personalListArr = arr1
            self!.groupListArr = arr2
            var nump = 0
            var numg = 0
            for m in arr1 {
                nump += m.unreadCount
            }
            for m in arr2 {
                numg += m.unreadCount
            }
            self!.perNum = nump
            self!.groupNum = numg
            self!.subject.onNext("")
        }
    }
    func addFriend() {
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class FriendModel: BaseModel {
    var avatar: String = ""
    var createTime: String = ""
    var timeStamp: TimeInterval = 0
    var enable: String = ""
    var friendPhone: String = ""
    var isEnable: String = ""
    var nickname: String = ""
    var placeID: String = ""
    var remark: String = ""
    var userPhone: String = ""
    var packageType: Int = 0
    var msgContent: String = ""
    var isReaded: Bool = false
    var isSelected: Bool = false
    var topicGroupID: String = ""
    var topicGroupName: String = ""
    var creator: String = ""
    var unreadCount: Int = 0
}

