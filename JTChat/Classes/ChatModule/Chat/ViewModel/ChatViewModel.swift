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
    var totalTimeArr: Array<String> = []
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationHelper.kChatOnlineNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NotificationHelper.kChatOnGroupNotiName, object: nil)
    }
    
    @objc func updateData() {
        refreshData(scrollView: UIScrollView())
        clearRedPot()
    }
    
    func clearRedPot() {
        if let m = self.originArr.last {
            if let d = USERDEFAULT.object(forKey: "currentID") as? String {
                if (m.senderPhone == d && m.topic_group.count == 0) || m.topic_group == d {
                    m.isReaded = true
                    DBManager.manager.updateRecentChat(model: m)
                }
            }
        }
    }
    
    func sendMessage(msg: String) {
        JTManager.shareManager().sendMessage(targetModel: contactor, msg: msg, suffix: nil)
        //        page = 1
        localUpdate(msg: msg, suffix: nil)
    }
    
    func sendAudioMessage(path: String) {
        JTManager.shareManager().sendMessage(targetModel: contactor, msg: path, suffix: "wav")
        localUpdate(msg: path, suffix: "wav")
    }
    
    func sendPicture(photos:[YPMediaItem]) {
        for item in photos {
            switch item {
            case .photo(p: let img):
                ChatimagManager.manager.saveImage(image: img.image)
                let msg = ChatimagManager.manager.MD5StrBy(image: img.image)
                JTManager.shareManager().sendMessage(targetModel: contactor, msg: msg, suffix: "jpg")
                self.localUpdate(msg: ChatimagManager.manager.MD5StrBy(image: img.image), suffix: "jpg")
            case .video(v: let video):
                
                let msg = AVFManager().saveLocalVideo(tmpPath: video.url.absoluteString)
                JTManager.shareManager().sendMessage(targetModel: contactor, msg: msg, suffix: "mp4")
            default: break
                
            }
            
            
        }
    }
    
    func localUpdate(msg: String , suffix: String?) {
        if let cmodel = contactor {
            let model = MessageModel()
            model.sender = cmodel.nickName
            model.senderPhone = cmodel.phone
            model.senderAvanter = cmodel.avatarUrl
            model.msgContent = msg
            model.packageType = (suffix ?? "").count > 0 ? 2 : 1
            model.topic_group = cmodel.topicGroupID
            model.timeStamp = Date().timeIntervalSince1970
            model.receiver = ""
            model.receiverPhone = (USERDEFAULT.object(forKey: "phone") ?? "") as! String
            model.receiverAvanter = ""
            model.isRemote = false
            model.isReaded = true
            calculateSize(model: model)
            self.originArr.append(model)
            if let sm = self.dataArr.last {
                sm.rowsArr.append(model)
            } else {
                let sm = MessageSectionModel()
                sm.time = ""
                sm.timeStamp = 0
                sm.rowsArr = [model]
                self.dataArr.insert(sm, at: 0)
            }
            DBManager.manager.updateRecentChat(model: model)
        }
        //        self.subject.onNext(1)
    }
    
    func refreshData(scrollView: UIScrollView) {
        if let cmodel = contactor {
            self.appendArr = []
            let model = MessageModel()
            model.sender = cmodel.nickName
            model.senderPhone = cmodel.phone
            model.senderAvanter = cmodel.avatarUrl
            model.topic_group = cmodel.topicGroupID
            model.receiver = ""
            model.receiverPhone = USERDEFAULT.object(forKey: "phone") as! String
            model.receiverAvanter = ""
            let semaphore = DispatchSemaphore(value: 0)
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
                semaphore.signal()
            }
            semaphore.wait()
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
    
    func calculateSize(model: MessageModel) {
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
            } else if model.msgContent.contains(".mp4") {
                let size = AVFManager().sizeOfVideo(filePath: model.msgContent)
                let containerWidth: CGFloat = (kScreenWidth-132)/2
                model.estimate_width = Float(containerWidth)
                model.estimate_height = Float((size.height/size.width)*(containerWidth/size.width))
                if model.estimate_height > Float(1.5*containerWidth) {
                    model.estimate_height = Float(1.5*containerWidth)
                }
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
    }
}

class MessageSectionModel: BaseModel {
    var time: String = ""
    var timeStamp: TimeInterval = 0
    var rowsArr: Array<MessageModel> = []
    
}
