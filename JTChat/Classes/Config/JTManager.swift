//
//  JTManager.swift
//  Alamofire
//
//  Created by LJ on 2020/9/1.
//

import UIKit

@objc

public protocol JTChatDelegate: NSObjectProtocol {
    
    func JTChatNeedToSendMessage(data: Data)
}

open class JTManager: NSObject {
    public static let manager = JTManager()
    @objc open weak var delegate: JTChatDelegate?
    @objc open var url: String = "" {
        didSet {
            USERDEFAULT.set(url, forKey: "baseURL")
        }
    }
    @objc open var jwt: String = "" {
        didSet {
            USERDEFAULT.set(jwt, forKey: "jwt")
        }
    }
    @objc open var ctoken: String = "" {
        didSet {
            USERDEFAULT.set(ctoken, forKey: "ctoken")
        }
    }
    @objc open var socketUrl: String = "" {
        didSet {
            USERDEFAULT.set(socketUrl, forKey: "baseSocket")
        }
    }
    
    @objc open var departmentDict: Dictionary<String, Any> = [:] {
        didSet {
            USERDEFAULT.set(departmentDict, forKey: "cdepartmentDict")
        }
    }
    
    @objc open var employeeDict: Dictionary<String, Any> = [:] {
        didSet {
            USERDEFAULT.set(employeeDict, forKey: "cemployeeDict")
        }
    }
    
    @objc open class func shareManager()->JTManager {
        return manager
    }
    @objc open func didRecievePersonalChatMessage(data: Data) {
        let model = SocketDataManager()
        model.unpackageData(data: data)
        let str = model.contentString
        let mmodel = MessageModel()
        mmodel.senderPhone = model.fromUserId
        mmodel.receiverPhone = model.targetUserId
        mmodel.packageType = Int(model.transType.rawValue)
        mmodel.msgContent = str.count > 0 ? str : " "
        if model.transType == .TransTypeFileStream {
            ChatimagManager.manager.saveImage(imageDataStr: model.contentString)
        }
        mmodel.timeStamp = Date().timeIntervalSince1970
        mmodel.isRemote = true
        let cm = DBManager.manager.getContactor(phone: model.fromUserId)
        mmodel.sender = cm.nickName
        mmodel.senderAvanter = cm.avatarUrl
        mmodel.receiverPhone = UserInfo.shared.userData?.data.emp_phone ?? ""
        mmodel.receiverAvanter = UserInfo.shared.userData?.data.emp_avatar ?? ""
        mmodel.isReaded = false
        let _ = DBManager.manager.AddChatLog(model: mmodel)
        NotificationCenter.default.post(name: NotificationHelper.kChatOnlineNotiName, object: nil)
    }
    
    @objc open func didRecieveGroupChatMessage(data: Data) {
        let model = SocketDataManager()
        model.unpackageData(data: data)
        let str = model.contentString
        let mmodel = MessageModel()
        mmodel.senderPhone = model.fromUserId
        mmodel.packageType = Int(model.transType.rawValue)
        if model.transType == .TransTypeFileStream {
            ChatimagManager.manager.saveImage(imageDataStr: model.contentString)
        }
        mmodel.msgContent = str.count > 0 ? str : " "
        mmodel.timeStamp = Date().timeIntervalSince1970
        mmodel.topic_group = model.targetUserId
        mmodel.isRemote = true
        let cm = DBManager.manager.getContactor(phone: model.fromUserId)
        mmodel.sender = cm.nickName
        mmodel.senderAvanter = cm.avatarUrl
        mmodel.receiverPhone = UserInfo.shared.userData?.data.emp_phone ?? ""
        mmodel.receiverAvanter = UserInfo.shared.userData?.data.emp_avatar ?? ""
        mmodel.isReaded = false
        let _ = DBManager.manager.AddChatLog(model: mmodel)
        NotificationCenter.default.post(name: NotificationHelper.kChatOnlineNotiName, object: nil)
    }
    
    func sendMessage(targetModel: ContactorModel?, msg: String?, suffix: String?) {
        if let cmodel = targetModel, (cmodel.phone.count > 0 || cmodel.topicGroupID.count > 0){
            let model = MessageModel()
            model.sender = cmodel.nickName
            model.senderPhone = cmodel.phone
            model.senderAvanter = cmodel.avatarUrl
            model.msgContent = msg ?? ""
            model.packageType = (suffix ?? "").count > 0 ? 2 : 1
            model.topic_group = cmodel.topicGroupID
            model.timeStamp = Date().timeIntervalSince1970
            let userModel = UserInfo.shared.userData?.data
            if let um = userModel {
                model.receiver = um.emp_stageName 
                model.receiverPhone = um.emp_phone 
                model.receiverAvanter = um.emp_avatar 
            }
            model.isRemote = false
            model.isReaded = true
            let _ = DBManager.manager.AddChatLog(model: model)
            let socketData = SocketDataManager()
            let data = UserInfo.shared.userData?.data
            socketData.fromUserId = data?.emp_phone ?? ""
            socketData.targetUserId = cmodel.topicGroupID.count > 0 ? cmodel.topicGroupID : cmodel.phone
            socketData.eventType = cmodel.topicGroupID.count > 0 ? .EventTypeGroupChat : .EventTypeLineChat
            socketData.packageType = .PackageTypeData
            socketData.fileSuffix = suffix ?? ""
            socketData.placeId = data?.PlaceID ?? 0
            socketData.transType = (suffix ?? "").count > 0 ? .TransTypeFileStream : .TransTypeByteStream
            socketData.contentString = (socketData.transType == .TransTypeFileStream) ? (ChatimagManager.manager.GetImageDataBy(MD5Str: msg ?? "").base64EncodedString()) : (msg ?? "")
            let messageOfSend = socketData.getFullData()
            if let de = self.delegate {
                de.JTChatNeedToSendMessage(data: messageOfSend)
            }
        } else {
            SVPShowError(content: "当前用户无效")
        }
    }
    
}


