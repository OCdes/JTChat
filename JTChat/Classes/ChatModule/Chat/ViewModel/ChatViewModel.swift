//
//  ChatViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/29.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import YPImagePicker
class ChatViewModel: BaseViewModel {
    var contactor: ContactorModel?
    var page: Int = 1
    var dataArr: Array<MessageSectionModel> = []
    var originArr: Array<MessageModel> = []
    var appendArr: Array<MessageModel> = []
    var subject: PublishSubject<Int> = PublishSubject<Int>()
    var first: Bool = true
    var sendCount: Int = 0
    var totalTimeArr: Array<String> = []
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationHelper.kChatOnlineNotiName, object: nil)
    }
    
    @objc func updateData() {
        refreshData(scrollView: UIScrollView())
        let model = self.appendArr.last
        if let m = model {
            DBManager.manager.updateRecentChat(model: m)
        }
    }
    
    func sendMessage(msg: String) {
        SocketManager.manager.sendMessage(targetModel: contactor, msg: msg, suffix: nil)
        sendCount += 1
        page = 1
        refreshData(scrollView: UIScrollView())
    }
    func sendPicture(photos:[YPMediaItem]) {
        for item in photos {
            switch item {
            case .photo(p: let img):
                ChatimagManager.manager.saveImage(image: img.image)
                SocketManager.manager.sendMessage(targetModel: contactor, msg: ChatimagManager.manager.MD5StrBy(image: img.image), suffix: "jpg")
                sendCount += 1
                page = 1
                refreshData(scrollView: UIScrollView())
            case .video(v: _):
                SVPShow(content: "")
            default: break
                
            }
            
            
        }
    }
    func refreshData(scrollView: UIScrollView) {
        if let cmodel = contactor {
            let model = MessageModel()
            model.sender = cmodel.nickName
            model.senderPhone = cmodel.phone
            model.senderAvanter = cmodel.avatarUrl
            model.topic_group = cmodel.topicGroupID
            let userModel = UserInfo.shared.userData?.data
            if let um = userModel {
                model.receiver = um.emp_stageName ?? ""
                model.receiverPhone = um.emp_phone ?? ""
                model.receiverAvanter = um.emp_avatar ?? ""
            }
            DBManager.manager.getChatLog(model: model, page: page, nums: page == 1 ? 0 : self.totalTimeArr.count) { [weak self](arr) in
                self!.first = false
                scrollView.jt_endRefresh()
                self!.appendArr = arr
                if self!.page == 1 {
                    self!.originArr = self!.appendArr
                    self!.dealSectionData()
                } else {
                    self!.originArr.insert(contentsOf: self!.appendArr, at: 0)
                    if let mm = arr.last, arr.count > 0 {
                        let sm = MessageSectionModel()
                        sm.time = mm.creatTime
                        sm.timeStamp = mm.timeStamp
                        sm.rowsArr = arr
                        self!.dataArr.insert(sm, at: 0)
                        self!.totalTimeArr.append(mm.creatTime)
                        self!.subject.onNext(1)
                    }
                }
                if self!.appendArr.count == 0 {
                    scrollView.jt_endHeaderRefreshWithNoMoreData()
                } else {
                    scrollView.jt_endRefresh()
                }
                
            }
            if let m = self.originArr.last {
                m.isReaded = true
                DBManager.manager.updateRecentChat(model: m)
            }
        }
        
    }
    
    private func dealSectionData() {
        var timeArr: Array<String> = []
        var arr: Array<MessageSectionModel> = []
        if appendArr.count == 0 {
            return
        }
        for model in originArr {
            if !totalTimeArr.contains(model.creatTime) {
                totalTimeArr.append(model.creatTime)
            }
            if timeArr.count == 0 {
                timeArr.append(model.creatTime)
                let sm = MessageSectionModel()
                sm.time = model.creatTime
                sm.timeStamp = model.timeStamp
                sm.rowsArr.append(model)
                arr.append(sm)
            } else {
                if model.timeStamp - arr.last!.timeStamp > 5*60 {
                    timeArr.append(model.creatTime)
                    let sm = MessageSectionModel()
                    sm.time = model.creatTime
                    sm.timeStamp = model.timeStamp
                    sm.rowsArr.append(model)
                    arr.append(sm)
                } else {
                    arr.last?.rowsArr.append(model)
                }
            }
        }
        dataArr = arr
        self.subject.onNext(1)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationHelper.kChatOnlineNotiName, object: nil)
    }
}

class MessageSectionModel: BaseModel {
    var time: String = ""
    var timeStamp: TimeInterval = 0
    var rowsArr: Array<MessageModel> = []
    
}
