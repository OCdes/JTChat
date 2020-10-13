//
//  AddFriendApplyViewModel.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit
import RxSwift
import HandyJSON
class AddFriendApplyViewModel: BaseViewModel {
    var myApplyArr: Array<MyApplyNoteModel> = []
    var dealApplyArr: Array<ApplyNoteModel> = []
    var subject: PublishSubject<Any> = PublishSubject<Any>()
    func refreshData(scrollView: UIScrollView) {
        let sub1 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_FETCHMYADDAPPLY, params: [:]) { (msg, code, response, data) in
            
        } fail: { (errorInfo) in
            scrollView.jt_endRefresh()
            SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "未知错误")
        }
        let sub2 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDAPPLY, params: [:]) { (msg, code, response, data) in
            
        } fail: { (errorInfo) in
            scrollView.jt_endRefresh()
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "未知错误")
        }
        
        let _ = Observable.zip(sub1, sub2).subscribe { [weak self](myApplyData, dealApplyData) in
            scrollView.jt_endRefresh()
            let myApplyDict = myApplyData as! [String:Any]
            let dealApplyDict = dealApplyData as! [String:Any]
            print(myApplyData,dealApplyData)
            if let dict = myApplyDict["Data"] as? [[String: Any]] {
                self!.myApplyArr = JSONDeserializer<MyApplyNoteModel>.deserializeModelArrayFrom(array: dict) as! [MyApplyNoteModel]
            }
            if let dict = dealApplyDict["Data"] as? [[String: Any]] {
                self!.dealApplyArr = JSONDeserializer<ApplyNoteModel>.deserializeModelArrayFrom(array: dict) as! [ApplyNoteModel]
            }
            self!.subject.onNext("")
        }

        

    }
    
    func dealFriendApply(model: ApplyNoteModel, isAgreen: Bool) {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DEALFRIENDAPPLY, params: ["friendPhone":model.friendPhone,"isAgree":isAgreen]) { [weak self](msg, code, response, data) in
            SVPShowSuccess(content: msg)
            self!.refreshData(scrollView: UIScrollView())
        } fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "处理失败")
        }

    }
}

class MyApplyNoteModel: BaseModel {
    var friendPhone: String = ""
    var approveResult: Bool = false
    var approveStatus: String = ""
    var userPhone: String = ""
    var avatarUrl: String = ""
    var nickName: String = ""
    var createTime: Int = 0
    
}
