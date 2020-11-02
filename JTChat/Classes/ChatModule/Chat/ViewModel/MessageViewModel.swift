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
    var disposeBag = DisposeBag()
    @objc dynamic var perNum: Int = 0
    @objc dynamic var groupNum: Int = 0
    override init() {
        super.init()
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kChatOnlineNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kReLoginName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllGroupData), name: NotificationHelper.kChatOnGroupNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kUpdateRecentList, object: nil)
    }
    
    @objc func getAllGroupData() {
        self.getAllRecentContactor(scrollView: UIScrollView())
    }
    
    @objc func getAllRecentContactor(scrollView: UIScrollView?) {
        let sub1 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATFRIENDSlIST, params: [:], success: { (msg, code, reponse, data) in
            //
        }) { (errorInfo) in
            scrollView?.jt_endRefresh()
            SVPShowError(content: errorInfo.message)
        }
        let sub2 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATGROUPlIST, params: [:], success: { (msg, code, response, data) in

        }) { (errorInfo) in
            scrollView?.jt_endRefresh()
            SVPShowError(content: errorInfo.message)
        }
        let _ = Observable.zip(sub1, sub2).subscribe(onNext: { [weak self](data1, data2) in
            scrollView?.jt_endRefresh()
            let dict1 = data1 as! Dictionary<String, Any>
            let dict2 = data2 as! Dictionary<String, Any>
            var arr1: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict1["data"] ?? dict1["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            let arr2: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict2["data"] ?? dict2["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            arr1.append(contentsOf: arr2)
            var phoneOrTopicArr: Array<String> = []
            for m in arr1 {
                m.isReaded = true
                DBManager.manager.addRecentChat(model: m)
                phoneOrTopicArr.append(m.topicGroupID.count>0 ? m.topicGroupID : m.friendPhone)
            }
            var resArr = [FriendModel]()
            let semaphore = DispatchSemaphore(value: 0)
            DBManager.manager.getRecentList { (arr1, arr2) in
                resArr = Array(arr1)
                resArr.append(contentsOf: arr2)
                semaphore.signal()
            }
            semaphore.wait()
            for resm in resArr {
                let keys = resm.topicGroupID.count > 0 ? resm.topicGroupID : resm.friendPhone
                if !(phoneOrTopicArr as NSArray).contains(keys) {
                    DBManager.manager.deletRecentChat(byPhone: resm.topicGroupID.count > 0 ? "" : resm.friendPhone, byTopicID: resm.topicGroupID.count > 0 ? resm.topicGroupID : "")
                }
            }
            self!.updateRecentList()
        }).disposed(by: self.disposeBag)
        
    }
    
    @objc func updateRecentList() {
        getMessageList(scrollView: UIScrollView())
    }
    
    func getMessageList(scrollView: UIScrollView) {
        self.personalListArr = []
        self.groupListArr = []
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
    func addFriend(friendNickname: String?, friendPhone: String, friendAvatar: String?, remark: String?, result: @escaping ((_ b: Bool)->Void)) {
        if JTManager.manager.addFriendSilence {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDFRIEND, params: ["friendNickname":"","friendPhone":friendPhone,"friendAvatar":friendAvatar ?? ""], success: { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加成功")
                result(true)
            }) { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
        } else {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_APPLYADDFRIEND, params: ["friendPhone":friendPhone,"remark":remark ?? ""]) { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加申请已发出,等待对方验证通过")
                result(false)
            } fail: { (errorInfo) in
                
            }
            
        }
        
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
    var aliasName: String = ""
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
    var voiceIsReaded: Bool = false
}

