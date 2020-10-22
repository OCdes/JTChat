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
    func JTChatNeedUpdateReadedCount()
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
    @objc open var phone: String = "" {
        didSet {
            USERDEFAULT.set(phone, forKey: "phone")
        }
    }
    @objc open var avatarUrl: String = "" {
        didSet {
            USERDEFAULT.set(phone, forKey: "JTavatarUrl")
        }
    }
    @objc open var isWaterShow: Bool = false {
        didSet {
            USERDEFAULT.set(isWaterShow, forKey: "isWaterShow")
        }
    }
    @objc open var isAutoResizeBottom: Bool = false {
        didSet {
            USERDEFAULT.set(isAutoResizeBottom, forKey: "isAutoResizeBottom")
        }
    }
    @objc open var isHideBottom: Bool = false {
        didSet {
            USERDEFAULT.set(isHideBottom, forKey: "isHideBottom")
        }
    }
    @objc open var placeID: Int = 0 {
        didSet {
            USERDEFAULT.set(placeID, forKey: "placeID")
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
    
    @objc open var addFriendSilence: Bool = false
    
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
        mmodel.receiverPhone = (USERDEFAULT.object(forKey: "phone") ?? "") as! String
        mmodel.receiverAvanter = ""
        mmodel.isReaded = false
        _ = DBManager.manager.AddChatLog(model: mmodel)
        DBManager.manager.updateRecentChat(model: mmodel)
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
        mmodel.receiverPhone = (USERDEFAULT.object(forKey: "phone") ?? "") as! String
        mmodel.receiverAvanter = ""
        mmodel.isReaded = false
        let _ = DBManager.manager.AddChatLog(model: mmodel)
        DBManager.manager.updateRecentChat(model: mmodel)
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
            model.receiver = ""
            model.receiverPhone = (USERDEFAULT.object(forKey: "phone") ?? "") as! String
            model.receiverAvanter = ""
            model.isRemote = false
            model.isReaded = true
            _ = DBManager.manager.AddChatLog(model: model)
            let socketData = SocketDataManager()
            socketData.fromUserId = (USERDEFAULT.object(forKey: "phone") ?? "") as! String
            socketData.targetUserId = cmodel.topicGroupID.count > 0 ? cmodel.topicGroupID : cmodel.phone
            socketData.eventType = cmodel.topicGroupID.count > 0 ? .EventTypeGroupChat : .EventTypeLineChat
            socketData.packageType = .PackageTypeData
            socketData.fileSuffix = suffix ?? ""
            socketData.placeId = (USERDEFAULT.object(forKey: "placeID") ?? "0") as! Int
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
    
    func updateUnreadedCount() {
//        if let de = self.delegate {
//            de.JTChatNeedUpdateReadedCount()
//        }
        NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
    }
    
    @objc open func signOut() {
        DBManager.manager.disposeDBManager()
    }
}


