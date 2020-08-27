//
//  GroupSelectViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/3.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
class GroupSelectViewModel: BaseViewModel {
    @objc dynamic var dataArr:Array<Any> = []
    var selectArr: Array<FriendModel> = []
    var selePhones: Array<String> = []
    var disables: Array<String> = []
    var doneSubject: PublishSubject<Any> = PublishSubject<Any>()
    var seleDataArr: Array<GeneralSelectModel>? {
        set {
            
        }
        get {
            var arr: Array<GeneralSelectModel> = []
            for fm in self.selectArr {
                let em = GeneralSelectModel()
                em.name = fm.nickname
                em.avatar = fm.avatar
                em.phone = fm.friendPhone
                arr.append(em)
            }
            return arr
        }
    }
    var topicGroupName: String = ""
    var topicGroupDesc: String = ""
    var topicGroupID: String = ""
    var fmodel: FriendModel = FriendModel()
    func refreshData() {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATFRIENDSlIST, params: [:], success: { [weak self](msg, code, reponse, data) in
            
            let arr = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: (data["data"] as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            if self!.selePhones.count > 0 {
                for m in arr {
                    m.isSelected = self!.selePhones.contains(m.friendPhone)
                }
            }
            self!.dataArr = arr
        }) { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        }
    }
    func dealData() {
        if self.selePhones.count > 0 {
            self.selectArr = []
            for m in (self.dataArr as! Array<FriendModel>) {
                m.isSelected = self.selePhones.contains(m.friendPhone)
                if m.isSelected {
                    self.selectArr.append(m)
                }
            }
        }
    }
    
    func creatGroup() {
        if topicGroupID.count > 0  {
            addMembers()
        } else {
            var arr: Array<String> = []
            var str: String = ""
            if self.selectArr.count == 0 {
                return
            }
            if self.selectArr.count > 1{
                for i in 0..<2 {
                    arr.append(self.selectArr[i].nickname)
                }
                if self.selectArr.count > 2 {
                    str = "\((arr as NSArray).componentsJoined(by: ","))等人的群聊"
                } else {
                    str = "\((arr as NSArray).componentsJoined(by: ","))的群聊"
                }
            } else {
                if self.selectArr.count > 0 {
                    arr.append(self.selectArr.first!.nickname)
                }
                str = "\((arr as NSArray).componentsJoined(by: ","))的群聊"
            }
            _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CREATGROUP, params: ["topicGroupName":str,"topicGroupDesc":""], success: { [weak self](msg, code, reponse, data) in
                
                self!.fmodel = JSONDeserializer<FriendModel>.deserializeFrom(dict: (data["data"] as! Dictionary<String,Any>))!
                self!.topicGroupID = self!.fmodel.topicGroupID
                self!.topicGroupName = self!.fmodel.topicGroupName
                DBManager.manager.addRecentChat(model: self!.fmodel)
                self!.addMembers()
            }) { (errorInfo) in
                SVPShowError(content: errorInfo.message)
            }
        }
        
    }
    
    func addMembers() {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDMEMBERTOGROUP, params: ["topicGroupID":topicGroupID,"memberPhones":(self.selePhones as NSArray).componentsJoined(by: ",")], success: { (msg, code, reponse, data) in
            
            self.doneSubject.onNext("")
            
        }) { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        }
    }
}
