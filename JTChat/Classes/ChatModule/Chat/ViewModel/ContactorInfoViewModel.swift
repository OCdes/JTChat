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
    var employeeModel: ContactorModel = ContactorModel()
    
    func getDetail() {
        if employeeModel.phone.count > 0 {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DETAILOFCHATEMPLOYEE, params: ["targetPhone":employeeModel.phone], success: { [weak self](msg, code, response, data) in
                
                let dict = (data["data"] ?? data["Data"]) as! Dictionary<String, Any>
                self!.employeeModel = JSONDeserializer<ContactorModel>.deserializeFrom(dict: dict)!
                self!.subject.onNext("")
            }) { (errorInfo) in
                
            }
        }
    }
    
    func addFriend(friendNickname: String?, friendPhone: String?, friendAvatar: String?, result: @escaping ((_ b: Bool)->Void)) {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDFRIEND, params: ["friendNickname":friendNickname ?? employeeModel.nickName,"friendPhone":friendPhone ?? employeeModel.phone,"friendAvatar":friendAvatar ?? employeeModel.avatarUrl], success: { (msg, code, response, data) in
            SVPShowSuccess(content: "好友添加成功")
            result(true)
        }) { (errorInfo) in
            SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
            result(false)
        }
    }
    
    
}
