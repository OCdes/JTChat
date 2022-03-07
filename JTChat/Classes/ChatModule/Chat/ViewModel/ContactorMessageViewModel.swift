//
//  ContactorMessageViewModel.swift
//  JTChat
//
//  Created by jingte on 2022/3/7.
//

import UIKit
import HandyJSON
import RxSwift
open class ContactorMessageViewModel: BaseViewModel {
    var personalListArr: Array<FriendModel> = []
    var groupListArr: Array<FriendModel> = []
    var addApplyArr: Array<ApplyNoteModel> = []
    private var employeeArr: [ContactorModel] = []
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    var disposeBag = DisposeBag()
    @objc dynamic var perNum: Int = 0
    @objc dynamic var groupNum: Int = 0
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kChatOnlineNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kReLoginName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAllGroupData), name: NotificationHelper.kChatOnGroupNotiName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kUpdateRecentList, object: nil)
    }
    
    @objc func getAllGroupData() {
        self.getAllRecentContactor(scrollView: UIScrollView())
    }
    
    @objc func getAllRecentContactor(scrollView: UIScrollView?) {
        let sub = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDAPPLY, params: [:]) { [weak self](msg, code, response, data) in
            print(data)
//            self?.addApplyData = (JSONDeserializer<ApplyNoteModel>.deserializeModelArrayFrom(array: ((data["data"] ?? data["Data"]) as! Array<Dictionary<String, Any>>))! as? Array<ApplyNoteModel>)!
//            self?.subject.onNext("")
        } fail: { (errorInfo) in
            SVProgressHUD.showError(withStatus: (errorInfo.message.count>0 ? errorInfo.message : "获取待处理事项错误"))
        }
        
        let sub1 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATFRIENDSlIST, params: [:], success: { (msg, code, reponse, data) in
            //
        }) { (errorInfo) in
            scrollView?.jt_endRefresh()
            SVPShowError(content: errorInfo.message)
        }
        let sub2 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATGROUPlIST, params: [:], success: { (msg, code, response, data) in
            
        }) { (errorInfo) in
            scrollView?.jt_endRefresh()
            SVPShowError(content: errorInfo.message)
        }
        let _ = Observable.zip(sub, sub1, sub2).subscribe(onNext: { [weak self](data, data1, data2) in
            scrollView?.jt_endRefresh()
            let dict = data as! Dictionary<String, Any>
            let dict1 = data1 as! Dictionary<String, Any>
            let dict2 = data2 as! Dictionary<String, Any>
            
            self?.addApplyArr = (JSONDeserializer<ApplyNoteModel>.deserializeModelArrayFrom(array: ((dict["data"] ?? dict["Data"]) as! Array<Dictionary<String, Any>>))! as? Array<ApplyNoteModel>)!
            
            var arr1: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict1["data"] ?? dict1["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            let arr2: Array<FriendModel> = JSONDeserializer<FriendModel>.deserializeModelArrayFrom(array: ((dict2["data"] ?? dict2["Data"]) as! Array<Dictionary<String, Any>>))! as! Array<FriendModel>
            arr1.append(contentsOf: arr2)
            var phoneOrTopicArr: Array<String> = []
            for m in arr1 {
                m.isReaded = true
                DBManager.manager.addRecentChat(model: m)
                phoneOrTopicArr.append(m.topicGroupID.count>0 ? m.topicGroupID : m.friendPhone)
            }
            var resArr = [FriendModel]()
            let semaphore = DispatchSemaphore(value: 0)
            DBManager.manager.getRecentList { (arr1, arr2) in
                resArr = Array(arr1)
                resArr.append(contentsOf: arr2)
                semaphore.signal()
            }
            semaphore.wait()
            for resm in resArr {
                let keys = resm.topicGroupID.count > 0 ? resm.topicGroupID : resm.friendPhone
                if !(phoneOrTopicArr as NSArray).contains(keys) {
                    DBManager.manager.deletRecentChat(byPhone: resm.topicGroupID.count > 0 ? "" : resm.friendPhone, byTopicID: resm.topicGroupID.count > 0 ? resm.topicGroupID : "")
                }
            }
            self!.updateRecentList()
        }).disposed(by: self.disposeBag)
        
    }
    
    func matchAllEmployee(with arr: Array<ContactorModel>) {
        if let earr = JTManager.manager.employeeDict["data"] as? Array<Dictionary<String, Any>> {
            for emodel in arr {
                for dict in earr {
                    if let jn = dict["jobNumber"] as? String, jn == emodel.jobNumber {
                        if let dd = dict["department"] as? String {
                            emodel.department = dd
                        }
                    }
                }
            }
        }
    }
    
    @objc func updateRecentList() {
        getMessageList(scrollView: UIScrollView())
    }
    
    open func getMessageList(scrollView: UIScrollView) {
        self.personalListArr = []
        self.groupListArr = []
        DBManager.manager.getRecentList { [weak self](arr1, arr2) in
            self!.personalListArr = arr1
            self!.groupListArr = arr2
            var nump = 0
            var numg = 0
            for m in arr1 {
                nump += m.unreadCount
            }
            for m in arr2 {
                numg += m.unreadCount
            }
            self!.perNum = nump
            self!.groupNum = numg
            self!.subject.onNext("")
        }
    }
    func addFriend(friendNickname: String?, friendPhone: String, friendAvatar: String?, remark: String?, result: @escaping ((_ b: Bool)->Void)) {
        if JTManager.manager.addFriendSilence {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDFRIEND, params: ["friendNickname":"","friendPhone":friendPhone,"friendAvatar":friendAvatar ?? ""], success: { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加成功")
                result(true)
            }) { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
        } else {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_APPLYADDFRIEND, params: ["friendPhone":friendPhone,"remark":remark ?? ""]) { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加申请已发出,等待对方验证通过")
                result(false)
            } fail: { (errorInfo) in
                
            }
            
        }
    }
    
    func getInfoOf(qrContent: String, result: @escaping(_ cinfo: ContactInfoModel)->Void) {
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: "/v1/chat/decryptEmpInfo", params: ["empQrcodeContent":qrContent], success: { (msg, code, repose, data) in
            let m = JSONDeserializer<ContactInfoModel>.deserializeFrom(dict: ((JTManager.manager.isSafeQrCode ? data["data"] : data["Data"]) as! Dictionary<String, Any>))
            if let mm = m {
                result(mm)
            }
        }, fail: { (errorInfo) in
            
        })
    }
    
    func setTop(model: FriendModel) {
        if model.topicGroupID.count > 0 {
            _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_UPDATEGROUPINFO, params: ["topicGroupID":model.topicGroupID,"topicGroupName":"","topicGroupDesc":"","isTop":(model.topTime.count > 0 ? "false" : "true")], success: { (msg, code, respones, data) in
                SVPShowSuccess(content: msg)
                self.getAllRecentContactor(scrollView: UIScrollView())
            }, fail: { (errorInfo) in
                SVPShowError(content: errorInfo.message)
            })
        } else {
            _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_SETALIAS, params: ["friendPhone":model.friendPhone,"aliasName":"","isTop":(model.topTime.count > 0 ? "false" : "true")], success: { (msg, code, response, data) in
                SVPShowSuccess(content: msg)
                self.getAllRecentContactor(scrollView: UIScrollView())
            }, fail: { (errorInfo) in
                SVPShowError(content: errorInfo.message)
            })
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
