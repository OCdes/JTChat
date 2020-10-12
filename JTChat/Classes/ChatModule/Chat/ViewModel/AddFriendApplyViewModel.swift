//
//  AddFriendApplyViewModel.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit
import RxSwift
class AddFriendApplyViewModel: BaseViewModel {
    var dataArr: Array<ApplyNoteModel> = []
    var subject: PublishSubject<Bool> = PublishSubject<Bool>()
    func dealFriendApply(model: ApplyNoteModel, isAgreen: Bool) {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DEALFRIENDAPPLY, params: ["friendPhone":model.friendPhone,"isAgree":isAgreen]) { [weak self](msg, code, response, data) in
            SVPShowSuccess(content: msg)
            model.finished = true
            self!.subject.onNext(isAgreen)
        } fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "处理失败")
        }

    }
}
