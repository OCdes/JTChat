//
//  ContactorResultViewModel.swift
//  JTChat
//
//  Created by 袁炳生 on 2020/10/13.
//

import UIKit
import HandyJSON
class ContactorResultViewModel: BaseViewModel {
    @objc dynamic var dataArr: [Any] = []
    var key: String = ""
    func search(scrollView: UIScrollView) {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POSST_FETCHEMPLOYEETOCHAT, params: [:]) { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
            let arr = JSONDeserializer<ContactorSearchModel>.deserializeModelArrayFrom(array: ((data["data"] ?? data["Data"]) as! Array<Dictionary<String, Any>>))!
            var marr = [ContactorSearchModel]()
            for model in arr {
                if let m = model, m.phone.contains(self!.key) || m.aliasName.contains(self!.key) || m.nickName.contains(self!.key) {
                    marr.append(m)
                }
            }
            self!.dataArr = marr as Array<Any>
        } fail: { (errorInfo) in
            scrollView.jt_endRefresh()
            SVPShowError(content: errorInfo.message.count>0 ? errorInfo.message : "未知错误")
        }

    }
}
