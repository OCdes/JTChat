//
//  SocketManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/5/25.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import AudioToolbox
import CocoaAsyncSocket
let kMessageTag = 1320
class SocketManager: NSObject {
    static let manager = SocketManager()
    private var socketManager: GCDAsyncSocket?
    var connected: Bool = false
    var connectTimer: Timer?
    var reconnectCount = 0
    var readBuffer: Data = Data()
    lazy var reconnectTimer: DispatchSourceTimer = {
        let timer = DispatchSource.makeTimerSource()
        let start = DispatchTime.now()
        let interval = DispatchTimeInterval.seconds(5)
        timer.schedule(deadline: start, repeating: interval, leeway: DispatchTimeInterval.microseconds(0))
        return timer
    }()
    override init() {
        super.init()
        socketManager = GCDAsyncSocket.init(delegate: self, delegateQueue: DispatchQueue.main)
        self.reconnectTimer.setEventHandler {
            if self.reconnectCount > 5 {
                self.reconnectTimer.suspend()
            } else {
                self.reconnectCount += 1
                self.creatSocketConnect()
            }
        }
    }
    
    func creatSocketConnect() {
        //        closeConnect()
        if let token = UserInfo.shared.userData?.parameter.jwt, token.count > 0  {
            connectWith(host: "47.99.76.66", port: 7002)//192.168.0.82
        }
        
    }
    
    func connectWith(host: String, port: UInt16) {
        if let token = UserInfo.shared.userData?.parameter.jwt, token.count > 0 {
            if !connected {
                do {
                    connected = ((try socketManager?.connect(toHost: host, onPort: port, withTimeout: 60)) != nil)
                } catch {
                    connected = false
                    print("socket连接失败")
                }
            } else {
                self.reconnectTimer.suspend()
                print("socket 已连接")
            }
        }
    }
    
    func invalidConnect() {
        self.connected = false
        if self.connectTimer?.isValid ?? false {
            self.connectTimer?.invalidate()
        }
        if !self.reconnectTimer.isCancelled {
            self.reconnectTimer.suspend()
        }
    }
    
    func closeConnect() {
        if self.connected {
            self.connected = false
            if self.connectTimer?.isValid ?? false {
                self.connectTimer?.invalidate()
            }
            if self.socketManager?.isConnected ?? false {
                self.socketManager?.disconnect()
            }
            
        }
        
    }
    
    func initizializeSockert() {
        let socketData = SocketDataManager()
        let data = UserInfo.shared.userData?.data
        socketData.fromUserId = data?.emp_phone ?? ""
        socketData.targetUserId = ""
        socketData.eventType = .EventTypeDefault
        socketData.packageType = .PackageTypeInitial
        socketData.fileSuffix = ""
        socketData.placeId = data?.PlaceID ?? 0
        socketData.transType = .TransTypeByteStream
        socketData.contentString = UDID
        socketManager?.write(socketData.getFullData(), withTimeout: -1, tag: 0)
        print("初始化 Socket")
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
                model.receiver = um.emp_stageName ?? ""
                model.receiverPhone = um.emp_phone ?? ""
                model.receiverAvanter = um.emp_avatar ?? ""
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
            socketManager?.write(socketData.getFullData(), withTimeout: -1, tag: 0)
        } else {
            SVPShowError(content: "当前用户无效")
        }
    }
    
    func play() {
        if silenced() {
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        } else {
            AudioServicesPlayAlertSound(1004)
        }
    }
    
    func silenced() -> Bool {
        return false
    }
    
    func addTimer() {
        connectTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(longConnectToSocket), userInfo: nil, repeats: true)
        RunLoop.current.add(connectTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc func longConnectToSocket() {
        let socketData = SocketDataManager()
        let data = UserInfo.shared.userData?.data
        socketData.fromUserId = data?.emp_phone ?? ""
        socketData.targetUserId = ""
        socketData.eventType = .EventTypeDefault
        socketData.packageType = PackageType.PackageTypeHeartBeat
        socketData.fileSuffix = ""
        socketData.placeId = data?.PlaceID ?? 0
        socketData.transType = TransType.TransTypeByteStream
        socketData.contentString = UDID
        socketManager?.write(socketData.getFullData(), withTimeout: -1, tag: 0)
        print("发送心跳包")
    }
}

extension SocketManager: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("socket 连接成功")
        initizializeSockert()
        addTimer()
        socketManager?.readData(withTimeout: -1, tag: 0)
        connected = true
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socket 连接断开\(err.debugDescription)")
        invalidConnect()
        reconnectTimer.resume()
    }
    
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("收到客户端发来的包")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        self.readBuffer.append(data)
        while self.readBuffer.count > 60 {
            let lengthData = self.readBuffer.subdata(in: 0..<4)
            var length: UInt32 = 0
            (lengthData as NSData).getBytes(&length, length: 4)
            length = UInt32(bigEndian:length)
            print("readBuffer:\(self.readBuffer.count)----allDataCount:\(length)")
            if self.readBuffer.count >= length+4 {
                dealSocketData(data: self.readBuffer)
            } else {
                socketManager?.readData(withTimeout: -1, tag: 0)
                break;
            }
        }
    }
    
    func dealSocketData(data: Data) {
        let model = SocketDataManager()
        model.unpackageData(data: self.readBuffer)
        self.readBuffer = Data()
        let str = model.contentString
        switch model.eventType {
        case .EventTypePrewarning:
            if str.count > 0 {
                guard let sdata = str.data(using: .utf8) else { return  }
                let d = try? JSONSerialization.jsonObject(with: sdata, options: .mutableContainers) as? Dictionary<String, Any>
                if var dict = d {
                    play()
                    let formate = DateFormatter()
                    formate.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateNow = Date()
                    let temp = "\(dateNow.timeIntervalSince1970)"
                    dict["times"] = temp
                    var marr: Array<Dictionary<String, Any>> = (USERDEFAULT.object(forKey: "latestPrewarningList") ?? []) as! Array<Dictionary<String, Any>>
                    marr.insert(dict, at: marr.startIndex)
                    USERDEFAULT.set(marr, forKey: "latestPrewarningList")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewPrewarningIsComing"), object: nil)
                }
            }
            break
        case .EventTypePop:
            if str.count > 0 {
                guard let sdata = str.data(using: .utf8) else { return  }
                let d = try? JSONSerialization.jsonObject(with: sdata, options: .mutableContainers) as? Dictionary<String, Any>
                if let dict = d {
                    let popv = PopAlertView.init(frame: CGRect.zero)
                    popv.titleLa.text = (dict["sub_type"] as? String ) ?? ""
                    popv.contentLa.text = (dict["content"] as? String ) ?? ""
                    popv.portraitV.image = JTBundleTool.getBundleImg(with:"remote_msg")
                    popv.show()
                }
            }
            break
        case .EventTypeApproval:
            break
        case .EventTypeOutSign:
            RootConfig.reLogin()
            break
        case .EventTypeLineChat:
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
            play()
            break
        case .EventTypeGroupChat:
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
            play()
            break
        default:
            break
        }
        socketManager?.readData(withTimeout: -1, tag: 0)
    }
}



/*
 4 elements
 ▿ 0 : 2 elements
 - key : "content"
 - value : 软件服务还有9天到期，请尽快续费。软件服务还有9天到期，请尽快续费。软件服务还有9天到期，请尽快续费。
 ▿ 1 : 2 elements
 - key : "type"
 - value : Popup
 ▿ 2 : 2 elements
 - key : "create_time"
 - value : 2020-06-10 15:17:25
 ▿ 3 : 2 elements
 - key : "sub_type"
 - value : 预警
 */
