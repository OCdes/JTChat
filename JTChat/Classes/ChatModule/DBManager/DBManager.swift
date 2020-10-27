//
//  DBManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/20.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import FMDB
@objc
open class DBManager: NSObject {
    struct DBStatic {
        fileprivate static var instance: DBManager?
    }
    class var manager: DBManager {
        if DBStatic.instance == nil {
            DBStatic.instance = DBManager()
        }
        return DBStatic.instance!
    }
    private var dbQueue: FMDatabaseQueue?
    private override init() {
        super.init()
        initChatListDataBase()
    }
    
    func disposeDBManager() {
        dbQueue?.interrupt()
        dbQueue?.close()
        dbQueue?.inDatabase({ (db) in
            print("数据库终止执行语句-->\(db.interrupt())")
        })
        dbQueue = nil
        DBManager.DBStatic.instance = nil
        print("数据库销毁了")
    }
    
    @objc open class func shareManager()->DBManager {
        return manager
    }
    
    private func initChatListDataBase() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        let filePath = "\(docPath)/\(USERDEFAULT.object(forKey: "placeID") ?? "")\(USERDEFAULT.object(forKey: "phone") ?? "")chatList.sqlite"
        dbQueue = FMDatabaseQueue.init(path: filePath)
        self.dbQueue?.inDatabase({ (db) in
            let chatLogSQL = "CREATE TABLE IF NOT EXISTS [ChatLogList] ([id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,[sender] VARCHAR(16) NOT NULL,[sender_phone] VARCHAR(16) NOT NULL,[sender_avantar] VARCHAR(255) NULL,[receiver] VARCHAR(16)  NOT NULL,[receiver_phone] VARCHAR(11) NOT NULL,[receiver_avantar] VARCHAR(255) NULL,[package_type] INTEGER NOT NULL,[package_content] TEXT NOT NULL,[create_time] DATETIME NOT NULL,[time_stamp] TIMESTAMP NOT NULL,[topic_group] VARCHAR(16) NULL,[estimate_height] FLOAT NOT NULL,[estimate_width] FLOAT NOT NULL,[is_remote] INTEGER NOT NULL,[is_read] INTEGER NOT NULL)"//,[alisa_name] VARCHAR(16)  NULL
            if db.open() {
                db.executeStatements(chatLogSQL)
                if !db.interrupt() {
                    print("db.lastError()")
                }
            }
        })
        self.dbQueue?.inDatabase({ (db) in
            let recentListCreatSQL = "CREATE TABLE IF NOT EXISTS [RecentChatList] ([id] INTEGER  PRIMARY KEY AUTOINCREMENT NOT NULL,[sender] VARCHAR(16)  NOT NULL,[sender_phone] VARCHAR(16) NOT NULL,[sender_avantar] VARCHAR(255) NULL,[package_type] INTEGER  NOT NULL,[package_content] TEXT  NOT NULL,[create_time] TIMESTAMP  NOT NULL,[topic_group] VARCHAR(32) NULL,[topic_group_name] VARCHAR(255) NULL,[creator] VARCHAR(255) NULL,[is_read] INTEGER NOT NULL, [unread_count] INTEGER NOT NULL)"//,[alisa_name] VARCHAR(16)  NULL
            if db.open() {
                db.executeStatements(recentListCreatSQL)
                if !db.interrupt() {
                    print("db.lastError()")
                }
            }
        })
        self.dbQueue?.inDatabase({ (db) in
            let contactorListSQL = "CREATE TABLE IF NOT EXISTS [ContactorList] ([id] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,[name] VARCHAR(32) NULL,[nick_name] VARCHAR(32) NOT NULL,[avantar] VARCHAR(255) NULL,[phone] VARCHAR(16) NOT NULL)"//,[alisa_name] VARCHAR(16)  NULL
            if db.open() {
                db.executeStatements(contactorListSQL)
                if !db.interrupt() {
                    print("db.lastError()")
                }
            }
        })
        alert(table: "ChatLogList", arg: "alias_name", type: "VARCHAR(16)")
        alert(table: "RecentChatList", arg: "alias_name", type: "VARCHAR(16)")
        alert(table: "ContactorList", arg: "alias_name", type: "VARCHAR(16)")
    }
    
    func alert(table: String, arg: String, type: String) {
        if isExist(tableName: table) {
            self.dbQueue?.inDatabase({ (db) in
                if db.open() {
                    if !db.columnExists(arg, inTableWithName: table) {
                        let alertColumnSQL = "ALTER TABLE \(table) ADD \(arg) \(type) not null default('')"
                        if db.executeStatements(alertColumnSQL) {
                            print("\(table) 插入 \(arg)成功")
                        } else {
                            print("\(table) 插入 \(arg)失败")
                        }
                    }
                    db.close()
                }
            })
        } else {
            print("\(table)不存在")
        }
    }
    
    func isExist(tableName: String)->Bool {
        var b = false
        let semaphore = DispatchSemaphore(value: 0)
        self.dbQueue?.inDatabase({ (db) in
            if db.open() {
                let existSQL = "select count(*) as total from sqlite_master where type='table' and name = '\(tableName)'"
                let result = db.executeQuery(existSQL, withArgumentsIn: [])
                if let rs = result {
                    while rs.next() {
                        let total = rs["total"] as! Int
                        b = total > 0
                    }
                }
                db.close()
            }
            semaphore.signal()
        })
        semaphore.wait()
        return b
    }
    
    func getRecentList(resultBlock:@escaping((_ personArr: Array<FriendModel>, _ groupArr: Array<FriendModel>)->Void)) {
        let semaphore = DispatchSemaphore(value: 0)
        var pArr: Array<FriendModel> = []
        var gArr: Array<FriendModel> = []
        self.dbQueue?.inDatabase({ (db) in
            print("currentDBQueueThread:\(Thread.current)")
            if db.open() {
                let queryPersonSQL = "SELECT * FROM RecentChatList ORDER BY create_time DESC"
                let pResult = db.executeQuery(queryPersonSQL, withArgumentsIn: [])
                if let pr = pResult {
                    while pr.next() {
                        let model = FriendModel()
                        model.nickname = pr["sender"] as! String
                        model.aliasName = pr["alias_name"] as! String
                        model.friendPhone = pr["sender_phone"] as! String
                        model.avatar = pr["sender_avantar"] as! String
                        model.packageType = pr["package_type"] as! Int
                        model.msgContent  = pr["package_content"] as! String
                        let ti = pr["create_time"] as! TimeInterval
                        model.createTime = ChatDateManager.manager.dealDate(byTimestamp: ti)
                        model.isReaded = pr["is_read"] as! Bool
                        model.topicGroupID  = pr["topic_group"] as! String
                        model.topicGroupName = pr["topic_group_name"] as! String
                        model.creator = pr["creator"] as! String
                        model.unreadCount = pr["unread_count"] as! Int
                        if model.topicGroupID.count > 0  {
                            gArr.append(model)
                        } else {
                            pArr.append(model)
                        }
                    }
                    db.close()
                } else {
                    db.close()
                }
            }
            semaphore.signal()
        })
        semaphore.wait()
        resultBlock(pArr, gArr)
    }
    
    @objc open func getRecentUnreadCount()->Int {
        var allnum = 0
        DBManager.manager.getRecentList { (arr1, arr2) in
            var nump = 0
            var numg = 0
            for m in arr1 {
                nump += m.unreadCount
            }
            for m in arr2 {
                numg += m.unreadCount
            }
            allnum = nump + numg
        }
        return allnum
    }
    
    func addRecentChat(model: FriendModel) {
        let m = getRecent(byPhone: model.friendPhone, byTopicID: model.topicGroupID)
        if (m.friendPhone.count == 0 && m.topicGroupID.count == 0) {
            DispatchQueue.global().async {
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        let insertSQL = "INSERT INTO RecentChatList (sender,alias_name,sender_phone,sender_avantar,package_type,package_content,create_time,topic_group,topic_group_name,creator,is_read, unread_count) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
                        
                        if model.createTime.count > 0 {
                            if model.createTime.contains(":") {
                                let format = DateFormatter()
                                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                if let date = format.date(from: model.createTime) {
                                    let timeInterval = date.timeIntervalSince1970
                                    db.executeUpdate(insertSQL, withArgumentsIn: [model.nickname,model.aliasName, model.friendPhone, model.avatar, model.packageType, model.msgContent,timeInterval, model.topicGroupID,model.topicGroupName,model.creator, model.isReaded, model.unreadCount])
                                    if !db.interrupt() {
                                        print("db.lastError()")
                                    }
                                }
                            } else {
                                db.executeUpdate(insertSQL, withArgumentsIn: [model.nickname,model.aliasName, model.friendPhone, model.avatar, model.packageType, model.msgContent,(Int(model.createTime) ?? 0)/1000, model.topicGroupID,model.topicGroupName,model.creator, model.isReaded, model.unreadCount])
                                if !db.interrupt() {
                                    print("db.lastError()")
                                }
                            }
                            
                        } else if model.timeStamp > 0 {
                            db.executeUpdate(insertSQL, withArgumentsIn: [model.nickname,model.aliasName, model.friendPhone, model.avatar, model.packageType, model.msgContent,model.timeStamp, model.topicGroupID,model.topicGroupName,model.creator, model.isReaded, model.unreadCount])
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                        } else {
                            let timeInterval = Date().timeIntervalSince1970
                            db.executeUpdate(insertSQL, withArgumentsIn: [model.nickname,model.aliasName, model.friendPhone, model.avatar, model.packageType, model.msgContent,timeInterval, model.topicGroupID,model.topicGroupName,model.creator, model.isReaded, model.unreadCount])
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                        }
                        DispatchQueue.main.async {
                            print("最近列表添加完成")
                            NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                            NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                        }
                    }
                    db.close()
                })
            }
        } else {
            if model.topicGroupID.count > 0 {
                let m = GroupInfoModel()
                m.topicGroupName = model.topicGroupName
                m.topicGroupID = model.topicGroupID
                updateGroupInfo(model: m)
            }
            if model.friendPhone.count > 0 {
                updateRecentInfo(model: model)
            }
            DispatchQueue.main.async {
                print("最近列表无需添加，开始刷新数据")
                NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
            }
        }
    }
    
    func deletRecentChat(byPhone: String, byTopicID: String) {
        let m = getRecent(byPhone: byPhone, byTopicID: byTopicID)
        var deletSQL = ""
        if (m.friendPhone.count > 0) {
            deletSQL = "DELETE FROM RecentChatList WHERE sender_phone = '\(byPhone)'"
        } else if (m.topicGroupID.count > 0 ) {
            deletSQL = "DELETE FROM RecentChatList WHERE topic_group = '\(byTopicID)'"
        }
        
        if deletSQL.count > 0 {
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        if db.executeUpdate(deletSQL, withArgumentsIn: []) {
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                            DispatchQueue.main.async {
                                print("最近列表删除完成")
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                            }
                        }
                    }
                    db.close()
                    semaphore.signal()
                })
            }
            semaphore.wait()
        } else {
            print("移除最近联系人/群组 错误")
        }
    }
    
    func deletChat(in friendPhone: String, or groupID: String) {
        var deletSQL = ""
        if (friendPhone.count > 0) {
            deletSQL = "DELETE FROM RecentChatList WHERE sender_phone = '\(friendPhone)' and receiver_phone = '\(JTManager.manager.phone)'"
        } else if (groupID.count > 0 ) {
            deletSQL = "DELETE FROM RecentChatList WHERE topic_group = '\(groupID)' and topic_group = '\(groupID)'"
        }
        
        if deletSQL.count > 0 {
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        db.executeUpdate(deletSQL, withArgumentsIn: [])
                        if !db.interrupt() {
                            print("db.lastError()")
                        }
                    }
                    db.close()
                    semaphore.signal()
                })
            }
            semaphore.wait()
        } else {
            print("移除最近联系人/群组会话 错误")
        }
    }
    
    func updateRecentChat(model: MessageModel) {
        print("进入更新消息消息列表")
        let m = getRecent(byPhone: model.topic_group.count > 0 ? "" : model.senderPhone, byTopicID: model.topic_group)
        if m.friendPhone.count > 0 {
            if m.nickname.count > 0 {
                DispatchQueue.global().async {
                    self.dbQueue?.inDatabase({ (db) in
                        if db.open() {
                            let updateSQL = "UPDATE RecentChatList SET package_type=\(model.packageType),package_content='\(model.msgContent)',topic_group='\(model.topic_group)',create_time=\(model.timeStamp),is_read=\(model.isReaded),unread_count=\(model.isReaded ? 0 : m.unreadCount+1) WHERE sender_phone='\(model.senderPhone)'"
                            if db.executeUpdate(updateSQL, withArgumentsIn: []) {
                                if !db.interrupt() {
                                    print("db.lastError()")
                                }
                                DispatchQueue.main.async {
                                    print("更新最近列表完成")
                                    NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                                    NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                                }
                            }
                        }
                        db.close()
                    })
                }
            } else {
                let m = getContactor(phone: model.senderPhone)
                if m.phone.count > 0 && m.nickName.count > 0 {
                    let fm = FriendModel()
                    fm.nickname = m.nickName
                    fm.aliasName = m.aliasName
                    fm.friendPhone = m.phone
                    fm.avatar = m.avatarUrl
                    fm.isReaded = model.isReaded
                    fm.createTime = model.creatTime
                    fm.timeStamp = model.timeStamp
                    fm.topicGroupID = model.topic_group
                    fm.packageType = model.packageType
                    fm.msgContent = model.msgContent
                    fm.unreadCount = model.isReaded ? 0 : 1
                    updateRecentInfo(model: fm)
                }
            }
            
        } else if m.topicGroupID.count > 0 {
            if m.topicGroupName.count > 0 {
                DispatchQueue.global().async {
                    self.dbQueue?.inDatabase({ (db) in
                        if db.open() {
                            let updateSQL = "UPDATE RecentChatList SET package_type=\(model.packageType),package_content='\(model.msgContent)',topic_group='\(m.topicGroupID)',create_time=\(model.timeStamp),is_read=\(model.isReaded),unread_count=\(model.isReaded ? 0 : m.unreadCount+1) WHERE topic_group='\(model.topic_group)'"
                            if db.executeUpdate(updateSQL, withArgumentsIn: []) {
                                if !db.interrupt() {
                                    print("db.lastError()")
                                }
                                DispatchQueue.main.async {
                                    print("更新最近列表完成")
                                    NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                                    NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                                }
                            }
                        }
                        db.close()
                    })
                }
            } else {
                updateRecentChat(model: model)
            }
            
        } else {
            if model.senderPhone.count > 0 {
                let fm = FriendModel()
                fm.nickname = model.sender
                fm.friendPhone = model.senderPhone
                fm.avatar = model.senderAvanter
                fm.isReaded = model.isReaded
                fm.createTime = model.creatTime
                fm.timeStamp = model.timeStamp
                fm.topicGroupID = model.topic_group
                fm.packageType = model.packageType
                fm.msgContent = model.msgContent
                fm.unreadCount = model.isReaded ? 0 : 1
                addRecentChat(model: fm)
            }
            print("当前对话人\(model.senderPhone)未存入表,接收人是\(model.receiverPhone)")
        }
    }
    
    func updateRecentInfo(model: FriendModel) {
        if model.friendPhone.count > 0 {
            DispatchQueue.global().async {
                self.dbQueue?.inDatabase({ (db) in
                    let updateSQL = "UPDATE RecentChatList SET sender='\(model.nickname)',alias_name='\(model.aliasName)',sender_avantar='\(model.avatar)' WHERE sender_phone='\(model.friendPhone)'"
                    if db.open() {
                        if db.executeStatements(updateSQL) {
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                            DispatchQueue.main.async {
                                print("个人联系人信息更新成功")
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                            }
                        }
                    }
                    db.close()
                })
            }
        }
    }
    
    func updateGroupInfo(model: GroupInfoModel) {
        if getRecent(byPhone: "", byTopicID: model.topicGroupID).topicGroupID.count > 0 {
            DispatchQueue.global().async {
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        let updateSQL = "UPDATE RecentChatList SET topic_group_name='\(model.topicGroupName)' WHERE topic_group='\(model.topicGroupID)'"
                        if db.executeUpdate(updateSQL, withArgumentsIn: []) {
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                            DispatchQueue.main.async {
                                print("个人联系人信息更新成功")
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRecentList, object: nil)
                                NotificationCenter.default.post(name: NotificationHelper.kUpdateRedDot, object: nil)
                            }
                        }
                    }
                    db.close()
                })
            }
        } else {
            let fm = FriendModel()
            fm.createTime = model.createTime
            fm.topicGroupID = model.topicGroupID
            fm.topicGroupName = model.topicGroupName
            addRecentChat(model: fm)
        }
        
    }
    
    func resetRecentList() {
        if isExist(tableName: "RecentChatList") {
            let deletSQL = "DELETE FROM RecentChatList"
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        if db.executeStatements(deletSQL) {
                            semaphore.signal()
                            print("重置最近联系人成功")
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                        }
                    }
                    db.close()
                })
            }
            semaphore.wait()
        }
    }
    
    func getRecent(byPhone: String?, byTopicID: String?) -> FriendModel {
        let model = FriendModel()
        if isExist(tableName: "RecentChatList") {
            if let phone = byPhone, phone.count > 0 {
                let semaphore = DispatchSemaphore(value: 0)
                let selectSQL = "SELECT * FROM RecentChatList WHERE sender_phone = '\(phone)';"
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        let result = db.executeQuery(selectSQL, withArgumentsIn: [])
                        if let rSet = result {
                            while rSet.next() {
                                model.nickname = rSet["sender"] as! String
                                model.aliasName = rSet["alias_name"] as! String
                                model.avatar = rSet["sender_avantar"] as! String
                                model.friendPhone = rSet["sender_phone"] as! String
                                model.unreadCount = rSet["unread_count"] as! Int
                            }
                        }
                    }
                    db.close()
                    semaphore.signal()
                })
                semaphore.wait()
            }
            if let topic = byTopicID, topic.count > 0 {
                let semaphore = DispatchSemaphore(value: 0)
                let selectSQL = "SELECT * FROM RecentChatList WHERE topic_group='\(topic)';"
                DispatchQueue.global().async {
                    
                    self.dbQueue?.inDatabase({ (db) in
                        if db.open() {
                            let result = db.executeQuery(selectSQL, withArgumentsIn: [])
                            if let rSet = result {
                                while rSet.next() {
                                    model.topicGroupID = rSet["topic_group"] as! String
                                    model.topicGroupName = rSet["topic_group_name"] as! String
                                    model.creator = rSet["creator"] as! String
                                    model.unreadCount = rSet["unread_count"] as! Int
                                }
                            }
                        }
                        db.close()
                        semaphore.signal()
                    })
                }
                semaphore.wait()
            }
        }
        return model
    }
    
    func AddChatLog(model: MessageModel)->Bool {
        var b = false
        DispatchQueue.global().async {
            self.dbQueue?.inDatabase({ (db) in
                if db.open() {
                    var msgStr: String = model.msgContent
                    if model.packageType == 1 {
                        let height = MessageAttriManager.manager.exchange(content: model.msgContent).boundingRect(with: CGSize(width: (kScreenWidth-132), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: NSStringDrawingContext()).size.height+38
                        var width: CGFloat = kScreenWidth-132
                        if height < 62 {
                            width = MessageAttriManager.manager.exchange(content: model.msgContent).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 16), options: .usesLineFragmentOrigin, context: NSStringDrawingContext()).size.width
                            width = width > (kScreenWidth-132) ? (kScreenWidth-132) : width
                        }
                        model.estimate_height = Float(height)
                        model.estimate_width = Float(width)
                    } else {
                        if model.msgContent.contains(".wav") {
                            let height = 62
                            let seconds = AVFManager().durationOf(filePath: model.msgContent)
                            
                            let width = (Int(kScreenWidth)-132)/2*(seconds>30 ? 30 : seconds)/30 + 60
                            model.estimate_width = Float(width)
                            model.estimate_height = Float(height)
                        } else {
                            let imgData = model.isRemote ? Data.init(base64Encoded: model.msgContent) : ChatimagManager.manager.GetImageDataBy(MD5Str: model.msgContent)
                            if let id = imgData {
                                msgStr = model.isRemote ? ChatimagManager.manager.MD5By(data: id) : model.msgContent
                                let img = UIImage.init(data: id)
                                if let ig = img {
                                    let swidth = Double(kScreenWidth-122)
                                    let width = Double(ig.size.width)
                                    let height = Double(ig.size.height)
                                    let scale = Double(height/width)
                                    if scale > 1 {
                                        let scaleW = Double(swidth/3)
                                        if width > swidth {
                                            let contrastHeight = Double(scale*scaleW)
                                            if contrastHeight > swidth*2/3 {
                                                model.estimate_width = Float(swidth*2/3)/Float(scale)
                                                model.estimate_height = Float(swidth*2/3)
                                            } else {
                                                model.estimate_width = Float(scaleW)
                                                model.estimate_height = Float(contrastHeight)
                                            }
                                        } else {
                                            if height > swidth*2/3 {
                                                model.estimate_width = Float(swidth*2/3)/Float(scale)
                                                model.estimate_height = Float(swidth*2/3)
                                            } else {
                                                model.estimate_width = Float(width)
                                                model.estimate_height = Float(height)
                                            }
                                        }
                                        
                                    } else {
                                        if width > swidth {
                                            let scaleW = Double(swidth/2)
                                            let contrastHeight = Double(scale*scaleW)
                                            if contrastHeight < swidth/3 {
                                                model.estimate_width = Float(scaleW)
                                                model.estimate_height = Float(swidth/3)
                                            } else {
                                                model.estimate_width = Float(scaleW)
                                                model.estimate_height = Float(contrastHeight)
                                            }
                                        } else {
                                            if height < swidth/3 {
                                                model.estimate_width = Float(width)
                                                model.estimate_height = Float(swidth/3)
                                            } else {
                                                model.estimate_width = Float(width)
                                                model.estimate_height = Float(height)
                                            }
                                        }
                                        
                                    }
                                    model.estimate_height = model.estimate_height+38
                                }
                            }
                            
                        }
                        
                    }
                    
                    let insertSQL = "INSERT INTO ChatLogList (sender,sender_phone,sender_avantar,receiver,receiver_phone,receiver_avantar,package_type,package_content,create_time,time_stamp,topic_group,estimate_height,estimate_width,is_remote,is_read) VALUES (?,?,?,?,?,?,?,?,datetime('now','localtime'),?,?,?,?,?,?)"
                    
                    print("----------MD5:\(msgStr) time:\(Date())")
                    b = db.executeUpdate(insertSQL, withArgumentsIn: [model.sender,model.senderPhone,model.senderAvanter,model.receiver,model.receiverPhone,model.receiverAvanter,model.packageType,msgStr,model.timeStamp,model.topic_group,model.estimate_height,model.estimate_width,model.isRemote,model.isReaded])
                    if !db.interrupt() {
                        print("db.lastError()")
                    }
                    if b {
                        DispatchQueue.main.async {
                            print("聊天数据插入成功")
                            NotificationCenter.default.post(name: model.topic_group.count > 0 ? NotificationHelper.kChatOnGroupNotiName : NotificationHelper.kChatOnlineNotiName, object: nil)
                        }
                    }
                }
                db.close()
            })
        }
        print("聊天记录插入：\(b),时间\(Date())")
        //        updateRecentChat(model: model)
        return b
    }
    
    func addContactor(model: ContactorModel) {
        if getContactor(phone: model.phone).phone.count == 0 {
            DispatchQueue.global().async {
                self.dbQueue?.inDatabase({ (db) in
                    if db.open() {
                        let contactorInsetSQL = "INSERT INTO ContactorList (nick_name,avantar,phone,alias_name) VALUES(?,?,?,?)"
                        if db.executeUpdate(contactorInsetSQL, withArgumentsIn: [model.nickName,model.avatarUrl,model.phone,model.aliasName]) {
                            if !db.interrupt() {
                                print("db.lastError()")
                            }
                        }
                    }
                    db.close()
                })
            }
        }
    }
    
    func getContactor(phone: String) -> ContactorModel {
        let contactorSQL = "SELECT * FROM ContactorList WHERE phone='\(phone)'"
        let model = ContactorModel()
        if isExist(tableName: "ContactorList") {
            let semaphore = DispatchSemaphore(value: 0)
            self.dbQueue?.inDatabase({ (db) in
                if db.open() {
                    let result = db.executeQuery(contactorSQL, withArgumentsIn: [])
                    if let rs = result {
                        while rs.next() {
                            model.avatarUrl = rs["avantar"] as! String
                            model.nickName = rs["nick_name"] as! String
                            model.phone = rs["phone"] as! String
                            if let als = rs["alias_name"] {
                                model.aliasName = als as! String
                            }
                            
                        }
                    }
                }
                db.close()
                semaphore.signal()
            })
            semaphore.wait()
        }
        
        return model
    }
    
    func getChatLog(model: MessageModel, page: Int, nums: Int, resultBlock:@escaping((_ arr: Array<MessageModel>)->Void)) {
        var arr: Array<MessageModel> = []
        if isExist(tableName: "ChatLogList") {
            if model.topic_group.count > 0  {
                let semaphore = DispatchSemaphore(value: 0)
                self.dbQueue!.inDatabase({ (db) in
                    let timeSQL = "select strftime('%Y-%m-%d %H:%M',create_time) as ctime,count(*) as total from ChatLogList where topic_group = '\(model.topic_group)' and receiver_phone = '\(model.receiverPhone)' group by ctime order by create_time desc limit 10 offset \(nums)"
                    var darr: Array<Dictionary<String, Any>> = []
                    if db.open() {
                        let result = db.executeQuery(timeSQL, withArgumentsIn: [])
                        if let rs = result {
                            var dataNum = 0
                            while rs.next() {
                                var d: Dictionary<String, Any> = Dictionary()
                                d["ctime"] = rs["ctime"] as! String
                                d["total"] = rs["total"] as! Int
                                darr.append(d)
                                dataNum += rs["total"] as! Int
                            }
                            rs.close()
                        }
                    }
                    if darr.count > 0 {
                        var dataNum: Int = 0
                        for dict in darr {
                            if let ctime: String = dict["ctime"] as? String, let total = dict["total"] as? Int {
                                let logSql = "select *from ChatLogList where strftime('%Y-%m-%d %H:%M',create_time) = '\(ctime)' and topic_group = '\(model.topic_group)' and receiver_phone = '\(model.receiverPhone)' order by time_stamp desc"
                                let result = db.executeQuery(logSql, withArgumentsIn: [])
                                if let rs = result {
                                    while(rs.next()) {
                                        let m = MessageModel()
                                        m.sender = rs["sender"] as! String
                                        m.senderPhone = rs["sender_phone"] as! String
                                        m.senderAvanter = rs["sender_avantar"] as! String
                                        m.receiver = rs["receiver"] as! String
                                        m.receiverPhone = rs["receiver_phone"] as! String
                                        m.receiverAvanter = rs["receiver_avantar"] as! String
                                        let timestamp = rs["create_time"] as! String
                                        m.creatTime = ChatDateManager.manager.dealDate(byTimeStr: timestamp)
                                        let oFormat = DateFormatter()
                                        oFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                        m.timeStamp = oFormat.date(from: timestamp)!.timeIntervalSince1970
                                        m.packageType = rs["package_type"] as! Int
                                        let msgStr = rs["package_content"] as! String
                                        if m.packageType == 2 {
                                            if msgStr.contains(".wav") {
                                                m.msgContent = msgStr
                                            } else {
                                                m.msgContent = ChatimagManager.manager.GetImageDataBy(MD5Str: msgStr).base64EncodedString()
                                            }
                                        } else {
                                            m.msgContent = msgStr
                                        }
                                        m.topic_group = rs["topic_group"] as! String
                                        m.estimate_height = rs["estimate_height"] as! Float
                                        m.estimate_width = rs["estimate_width"] as! Float
                                        m.isRemote = rs["is_remote"] as! Bool
                                        arr.append(m)
                                    }
                                    rs.close()
                                }
                                dataNum += total
                            }
                        }
                    }
                    db.close()
                    arr = arr.reversed()
                    resultBlock(arr)
                    semaphore.signal()
                })
                semaphore.wait()
            } else {
                let semaphore = DispatchSemaphore(value: 0)
                self.dbQueue!.inDatabase({ (db) in
                    let timeSQL = "select strftime('%Y-%m-%d %H:%M',create_time) as ctime,count(*) as total from ChatLogList where sender_phone = '\(model.senderPhone)' and receiver_phone = '\(model.receiverPhone)' and topic_group = '' group by ctime order by create_time desc limit 10 offset \(nums) "
                    var darr: Array<Dictionary<String, Any>> = []
                    if db.open() {
                        let result = db.executeQuery(timeSQL, withArgumentsIn: [])
                        if let rs = result {
                            var dataNum = 0
                            while rs.next() {
                                var d: Dictionary<String, Any> = Dictionary()
                                d["ctime"] = rs["ctime"] as! String
                                d["total"] = rs["total"] as! Int
                                darr.append(d)
                                dataNum += rs["total"] as! Int
                            }
                            rs.close()
                        }
                        
                        if darr.count > 0 {
                            var dataNum: Int = 0
                            for dict in darr {
                                if let ctime: String = dict["ctime"] as? String, let total = dict["total"] as? Int {
                                    if dataNum <= 10 {
                                        let logSql = "select *from ChatLogList where strftime('%Y-%m-%d %H:%M',create_time) = '\(ctime)' and sender_phone = '\(model.senderPhone)' and receiver_phone = '\(model.receiverPhone)' and topic_group = '' order by time_stamp desc"
                                        let result = db.executeQuery(logSql, withArgumentsIn: [])
                                        if let rs = result {
                                            while(rs.next()) {
                                                let m = MessageModel()
                                                m.sender = rs["sender"] as! String
                                                m.senderPhone = rs["sender_phone"] as! String
                                                m.senderAvanter = rs["sender_avantar"] as! String
                                                m.receiver = rs["receiver"] as! String
                                                m.receiverPhone = rs["receiver_phone"] as! String
                                                m.receiverAvanter = rs["receiver_avantar"] as! String
                                                let timestamp = rs["create_time"] as! String
                                                m.creatTime = ChatDateManager.manager.dealDate(byTimeStr: timestamp)
                                                let oFormat = DateFormatter()
                                                oFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                                m.timeStamp = oFormat.date(from: timestamp)!.timeIntervalSince1970
                                                m.packageType = rs["package_type"] as! Int
                                                let msgStr = rs["package_content"] as! String
                                                if m.packageType == 2 {
                                                    if msgStr.contains(".wav") {
                                                        m.msgContent = msgStr
                                                    } else {
                                                        m.msgContent = ChatimagManager.manager.GetImageDataBy(MD5Str: msgStr).base64EncodedString()
                                                    }
                                                } else {
                                                    m.msgContent = msgStr
                                                }
                                                m.topic_group = rs["topic_group"] as! String
                                                m.estimate_height = rs["estimate_height"] as! Float
                                                m.estimate_width = rs["estimate_width"] as! Float
                                                m.isRemote = rs["is_remote"] as! Bool
                                                arr.append(m)
                                            }
                                            rs.close()
                                        }
                                        dataNum += total
                                    } else {
                                        break
                                    }
                                }
                            }
                        }
                        arr = arr.reversed()
                        resultBlock(arr)
                    }
                    db.close()
                    semaphore.signal()
                })
                semaphore.wait()
            }
        } else {
            resultBlock(Array())
        }
    }
}
