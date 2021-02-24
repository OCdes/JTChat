//
//  ContactorInfoViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/20.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import RxSwift
class ContactorInfoViewModel: BaseViewModel {
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    var employeeModel: ContactInfoModel = ContactInfoModel()
    
    func getDetail() {
        if employeeModel.phone.count > 0 {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DETAILOFCHATEMPLOYEE, params: ["targetPhone":employeeModel.phone], success: { [weak self](msg, code, response, data) in
                
                let dict = (data["data"] ?? data["Data"]) as! Dictionary<String, Any>
                self!.employeeModel = JSONDeserializer<ContactInfoModel>.deserializeFrom(dict: dict)!
                self!.subject.onNext("")
            }) { (errorInfo) in
                
            }
        }
    }
    
    func addFriend(friendNickname: String?, friendPhone: String?, friendAvatar: String?, remark: String?, result: @escaping ((_ b: Bool)->Void)) {
        if JTManager.manager.addFriendSilence {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDFRIEND, params: ["friendNickname":friendNickname ?? employeeModel.nickName,"friendPhone":friendPhone ?? employeeModel.phone,"friendAvatar":friendAvatar ?? employeeModel.avatarUrl], success: { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加成功")
                result(true)
            }) { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
        } else {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_APPLYADDFRIEND, params: ["friendPhone":friendPhone ?? employeeModel.phone,"remark":remark ?? ""]) { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加申请已发出,等待对方验证通过")
                result(false)
            } fail: { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
            
        }
        
    }
    
    func deletFriend(friendPhone: String) {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DELETFRIEND, params: ["friendPhone":friendPhone], success: { (msg, code, response, data) in
            DBManager.manager.deletRecentChat(byPhone: friendPhone, byTopicID: "")
            
            SVPShowSuccess(content: msg)
            self.navigationVC?.popToRootViewController(animated: true)
        }, fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "移除好友失败")
        })
    }
    
    func setPersonalChatViewBG(image: UIImage) {
        ChatimagManager.manager.saveChatBGImage(image: image, forGroup: self.employeeModel.phone)
    }
}

class ContactInfoModel: BaseModel {
    var defaultPhotoUrl: String = ""
    var department: String = ""
    var nickName: String = ""
    var roleID: String = ""
    var id: String = ""
    var createTime: Int = 0
    var gender: Int = 0
    var aliasName: String = ""
    var avatarUrl: String = ""
    var isFriend: Bool = false
    var jobNumber: String = ""
    var phone: String = ""
    
}
