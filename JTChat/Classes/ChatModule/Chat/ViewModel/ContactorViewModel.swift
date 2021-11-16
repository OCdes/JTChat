//
//  ContactorViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/6/24.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON
import SVProgressHUD
open class ContactorViewModel: BaseViewModel {
    var searchText: String?
    var department: String?
    var sectionModel: ContactDataModel = ContactDataModel()
    var employeeArr: Array<ContactorModel>?
    var departmentArr: Array<DepartmentModel>?
    @objc dynamic var selectIDArr: Array<String> = []
    var selectArr: Array<ContactorModel> = []
    var groupID: String?
    var locationCollection: UILocalizedIndexedCollation!
    var subject = PublishSubject<Any>.init()
    var sureSubject = PublishSubject<Any>.init()
    var typeChange: Bool = false// false个人 true部门切换
    var typeEnable: Bool = false//是否允许切换
    var expendIndexPath: NSIndexPath?
    var selectenable: Bool = true//是否可选
    var pinyinArr: [Array<ContactorModel>] = []
    var indexTitles: Array<String> = []
    var addApplyData: Array<ApplyNoteModel> = []
    let disposeBag = DisposeBag()
    override init() {
        super.init()
        self.locationCollection = UILocalizedIndexedCollation.current()
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecentList), name: NotificationHelper.kReLoginName, object: nil)
    }
    
    @objc func updateRecentList() {
        refreshData(scrollView: UIScrollView())
    }
    
    func refreshData(scrollView: UIScrollView) {
        sectionModel = ContactDataModel.init()
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_CHATFRIENDSlIST, params: [:], success: { [weak self](msg, code, response, data) in
            scrollView.jt_endRefresh()
            let arr: Array<Any> = (data["data"] ?? data["Data"]) as! Array
            self!.employeeArr = JSONDeserializer<ContactorModel>.deserializeModelArrayFrom(array: arr)! as? Array<ContactorModel>
            self!.matchAllEmployee(with: self!.employeeArr!)
            if let deDict: Dictionary<String, Any> = USERDEFAULT.object(forKey: "cdepartmentDict") as? Dictionary<String, Any> {
                let deArr: Array<Any> = deDict["data"] as! Array
            self!.departmentArr = JSONDeserializer<DepartmentModel>.deserializeModelArrayFrom(array: deArr)! as? Array<DepartmentModel>
            }
            self!.listChangeWithType(b: self!.typeChange)
            self!.employeePersistence()
        }) { (errorInfo) in
            scrollView.jt_endRefresh()
            SVProgressHUD.showError(withStatus: (errorInfo.message.count>0 ? errorInfo.message : "可联系列表获取失败"))
        }
        
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDAPPLY, params: [:]) { [weak self](msg, code, response, data) in
            print(data)
            self!.addApplyData = (JSONDeserializer<ApplyNoteModel>.deserializeModelArrayFrom(array: ((data["data"] ?? data["Data"]) as! Array<Dictionary<String, Any>>))! as? Array<ApplyNoteModel>)!
            self!.subject.onNext("")
        } fail: { (errorInfo) in
            SVProgressHUD.showError(withStatus: (errorInfo.message.count>0 ? errorInfo.message : "获取待处理事项错误"))
        }

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
    
    func employeePersistence() {
        for model in self.employeeArr ?? [] {
            DBManager.manager.addContactor(model: model)
        }
    }
    
    func listChangeWithType(b: Bool) {
        self.pinyinArr = []
        self.indexTitles = []
        sectionModel.pinyinArr = []
        sectionModel.subdepartmentArr = []
        sectionModel.employeeArr = []
        sectionModel.subEmployeeArr = []
        if b == false {
            let indexCount = self.locationCollection.sectionTitles.count
            self.indexTitles = Array(self.locationCollection.sectionTitles)
            for _ in 0..<indexCount {
                self.pinyinArr.append(Array())
            }
            for em in self.employeeArr ?? [] {
                let seciotnNumber = self.locationCollection.section(for: em, collationStringSelector: #selector(getter: ContactorModel.nickName))
                em.isSelected = selectIDArr.contains(em.phone)
                self.pinyinArr[seciotnNumber].append(em )
            }
            for i in 0..<indexCount {
                let sortedPersonArr:Array<Any> = self.locationCollection.sortedArray(from: self.pinyinArr[i], collationStringSelector: #selector(getter: ContactorModel.nickName))
                self.pinyinArr[i] = sortedPersonArr as!Array<ContactorModel>
            }
            
            var tempArray = [Int]()
            for (i, em) in self.pinyinArr.enumerated() {
                if em.count == 0 {
                    tempArray.append(i)
                } else {
                    
                }
            }
            
            for i in tempArray.reversed() {
                self.pinyinArr.remove(at: i)
                self.indexTitles.remove(at: i)
            }
        } else {
            self.employeeArr?.forEach({ (model) in
                if model.department.count == 0 {
                    model.isSelected = selectIDArr.contains(model.phone )
                    sectionModel.employeeArr.append(model)
                }
            })
            sectionModel.subEmployeeArr.append(contentsOf: sectionModel.employeeArr )
            self.departmentArr?.forEach({ (model) in
                let m: ContactDataModel = ContactDataModel.init()
                m.departmentName = model.deptName
                m.departmentID = model.deptID
                if model.deptParentID.count > 0 {
                } else {
                    handleSubdepartmentArr(m: m)
                    if m.subEmployeeArr.count > 0 {
                        sectionModel.subdepartmentArr.append(m)
                        sectionModel.subEmployeeArr.append(contentsOf: m.subEmployeeArr)
                    }
                }
            })
        }
        self.subject.onNext("")
    }
    
    func handleSubdepartmentArr(m: ContactDataModel) {
        for model in self.departmentArr ?? [] {
            let mm = ContactDataModel()
            mm.departmentName = model.deptName
            mm.departmentID = model.deptID
            mm.departmentParentID = model.deptID
            if model.deptParentID.count > 0 {
                if model.deptParentID == m.departmentID {
                    m.subdepartmentArr.append(mm)
                }
            }
        }
        handleEmployeeArr(m: m)
        m.subEmployeeArr.append(contentsOf: m.employeeArr)
        if m.subdepartmentArr.count > 0 {
            for model in m.subdepartmentArr {
                handleSubdepartmentArr(m: model)
                m.subEmployeeArr.append(contentsOf: model.subEmployeeArr)
            }
        }
    }
    
    func dealSectionModel(m: ContactDataModel) {
        var b = true
        if m.subdepartmentArr.count > 0 || m.employeeArr.count > 0 {
            for model in m.subdepartmentArr {
                if model.subdepartmentArr.count == 0 {
                    if !model.isSelected {
                        b = false
                    }
                } else {
                    dealSectionModel(m: model)
                }
                
            }
            for model in m.employeeArr {
                if !model.isSelected {
                    b = false
                }
            }
        } else {
            b = false
        }
        m.isAllSelected = b
        if b {
            m.isSelected = true
        } else {
            m.isSelected = false
        }
    }
    
    func handleEmployeeArr(m: ContactDataModel) {
        for em in self.employeeArr! {
            let emodel = em
            if emodel.department.count > 0 {
                if emodel.department == m.departmentName {
                    emodel.isSelected = selectIDArr.contains(emodel.phone )
                    m.employeeArr.append(emodel)
                }
            }
        }
    }
    
    func addFriend(friendNickname: String?, friendPhone: String?, friendAvatar: String?, remark: String?, result: @escaping ((_ b: Bool)->Void)) {
        if JTManager.manager.addFriendSilence {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_ADDFRIEND, params: ["friendNickname":"","friendPhone":friendPhone ?? "","friendAvatar":friendAvatar ?? ""], success: { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加成功")
                result(true)
            }) { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
        } else {
            let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_APPLYADDFRIEND, params: ["friendPhone":friendPhone ?? "","remark":remark ?? ""]) { (msg, code, response, data) in
                SVPShowSuccess(content: "好友添加申请已发出,等待对方验证通过")
                result(false)
            } fail: { (errorInfo) in
                SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "好友添加失败")
                result(false)
            }
            
        }
        
    }
    func getInfoOf(qrContent: String, result: @escaping(_ cinfo: ContactInfoModel)->Void) {
        SVProgressHUD.show()
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: "/v1/chat/decryptEmpInfo", params: ["empQrcodeContent":qrContent,"type":"QRCODE"], success: { (msg, code, repose, data) in
            SVProgressHUD.dismiss()
            let m = JSONDeserializer<ContactInfoModel>.deserializeFrom(dict: ((JTManager.manager.isSafeQrCode ? data["data"] : data["Data"]) as! Dictionary<String, Any>))
            if let mm = m {
                result(mm)
            }
        }, fail: { (errorInfo) in
            SVProgressHUD.dismiss()
            SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "查询错误")
        })
    }
    
    func getInfoOf(phone: String, result: @escaping(_ cinfo: ContactInfoModel)->Void) {
        SVProgressHUD.show()
        _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: "/v1/chat/decryptEmpInfo", params: ["empQrcodeContent":phone,"type":"PHONE"], success: { (msg, code, repose, data) in
            SVProgressHUD.dismiss()
            let m = JSONDeserializer<ContactInfoModel>.deserializeFrom(dict: (( data["data"] ?? data["Data"]) as! Dictionary<String, Any>))
            if let mm = m {
                result(mm)
            }
        }, fail: { (errorInfo) in
            SVProgressHUD.dismiss()
            SVPShowError(content: errorInfo.message.count > 0 ? errorInfo.message : "查询错误")
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
