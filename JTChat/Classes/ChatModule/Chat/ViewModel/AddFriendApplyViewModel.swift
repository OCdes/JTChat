//
//  AddFriendApplyViewModel.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/10.
//

import UIKit

class AddFriendApplyViewModel: BaseViewModel {
    var dataArr: Array<ApplyNoteModel> = []
    func dealFriendApply(model: ApplyNoteModel, isAgreen: Bool) {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DEALFRIENDAPPLY, params: ["friendPhone":model.friendPhone,"isAgree":isAgreen]) { (msg, code, response, data) in
            SVPShowSuccess(content: msg)
        } fail: { (errorInfo) in
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "处理失败")
        }

    }
}
