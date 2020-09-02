//
//  GroupInfoViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/8/5.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
class GroupInfoViewModel: BaseViewModel {
    var model: GroupInfoModel = GroupInfoModel()
    var groupID: String = ""
    var groupName: String = ""
    var groupDescrip: String = ""
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    func refreshData() {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DETAILOFGROUP, params: ["topicGroupID":groupID], success: { (msg, code, response, data) in
            
            self.model = JSONDeserializer<GroupInfoModel>.deserializeFrom(dict: ((data["data"] ?? data["Data"]) as! Dictionary<String, Any>))!
            self.groupName = self.model.topicGroupName
            self.groupDescrip = self.model.topicGroupDesc
            self.subject.onNext("")
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        })
    }
    
    func deleGroup() {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DELETGROUP, params: ["topicGroupID" : groupID], success: { (msg, code, response, data) in
            SVPShowSuccess(content: "群组已解散")
            DBManager.manager.deletRecentChat(byPhone: "", byTopicID: self.groupID)
            self.navigationVC?.popToRootViewController(animated: true)
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        })
    }
    
    func removeMember(m: GroupMemberModel) {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_REMOVEMEMFROMGROUP, params: ["topicGroupID" : groupID, "memberPhone":m.memberPhone], success: { (msg, code, response, data) in
            SVPShowSuccess(content: "移除成功")
            self.refreshData()
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        })
    }
    
    func leaveGroup() {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_REMOVEMEMFROMGROUP, params: ["topicGroupID" : groupID, "memberPhone":UserInfo.shared.accontStr], success: { (msg, code, response, data) in
            SVPShowSuccess(content: "退出成功")
            DBManager.manager.deletRecentChat(byPhone: "", byTopicID: self.groupID)
            self.navigationVC?.popToRootViewController(animated: true)
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message)
        })
    }
    
    func updateInfo() {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_UPDATEGROUPINFO, params: ["topicGroupID":groupID,"topicGroupName":groupName,"topicGroupDesc":groupDescrip], success: { (msg, code, response, data) in
            SVPShowSuccess(content: "修改成功")
            let m = GroupInfoModel()
            m.topicGroupID = self.groupID
            m.topicGroupName = self.groupName
            m.topicGroupDesc = self.groupDescrip
            DBManager.manager.updateGroupInfo(model: m)
            self.refreshData()
        }, fail: { (errorinfo) in
            SVPShowError(content: errorinfo.message)
        })
    }
}

class GroupInfoModel: BaseModel {
    var createTime: String = ""
    var creator: String = ""
    var members: Int = 1
    var topicGroupDesc: String = ""
    var topicGroupID: String = ""
    var topicGroupName: String = ""
    var membersList: Array<GroupMemberModel> = []
}

class GroupMemberModel: BaseModel {
    var avatar: String = ""
    var disableTalking: Bool = false
    var createTime: String = ""
    var isDisableTalking: Bool = false
    var isEnable: Bool = false
    var memberPhone: String = ""
    var nickname: String = ""
    var topicGroupID: String = ""
}
