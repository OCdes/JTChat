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
class ContactorViewModel: BaseViewModel {
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
    var typeChange: Bool = true// false个人 true部门切换
    var typeEnable: Bool = false//是否允许切换
    var expendIndexPath: NSIndexPath?
    var selectenable: Bool = true//是否可选
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
        let subject1 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POSST_FETCHEMPLOYEETOCHAT, params: [:], success: { (msg, code, response, data) in
            
        }) { (errorInfo) in
            scrollView.jt_endRefresh()
            SVProgressHUD.showError(withStatus: (errorInfo.message.count>0 ? errorInfo.message : "未知错误"))
        }
        
        let subject2 = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, api: POST_DEPARTMENTDATA, params: ["":""], success: { (msg, code, response, data) in
            
        }) { (errorInfo) in
            scrollView.jt_endRefresh()
        }
        
        _ = Observable.zip(subject1, subject2).subscribe(onNext: { [weak self](employeeData, departmentData) in
//            print(employeeData, departmentData)
            
            let employeeDict: Dictionary<String, Any> = employeeData as! Dictionary<String, Any>
            //            let dict: Dictionary<String, Any> = employeeDict["data"] as! Dictionary<String, Any>
            let arr: Array<Any> = employeeDict["data"] as! Array
            self!.employeeArr = JSONDeserializer<ContactorModel>.deserializeModelArrayFrom(array: arr)! as? Array<ContactorModel>
            let deDict: Dictionary<String, Any> = departmentData as! Dictionary<String, Any>
            let deArr: Array<Any> = deDict["data"] as! Array
            self!.departmentArr = JSONDeserializer<DepartmentModel>.deserializeModelArrayFrom(array: deArr)! as? Array<DepartmentModel>
            self!.listChangeWithType(b: self!.typeChange)
            self!.employeePersistence()
        })
        
    }
    
    func employeePersistence() {
        for model in self.employeeArr ?? [] {
            DBManager.manager.addContactor(model: model)
        }
    }
    
    func listChangeWithType(b: Bool) {
        sectionModel.pinyinArr = []
        sectionModel.subdepartmentArr = []
        sectionModel.employeeArr = []
        sectionModel.subEmployeeArr = []
        if b == false {
            let indexCount = self.locationCollection.sectionTitles.count
            for _ in 0..<indexCount {
                let m = ContactDataModel.init()
                sectionModel.pinyinArr.append(m)
            }
            for em in self.employeeArr ?? [] {
                let seciotnNumber = self.locationCollection.section(for: em, collationStringSelector: #selector(getter: ContactorModel.nickName))
                em.isSelected = selectIDArr.contains(em.phone)
                sectionModel.pinyinArr[seciotnNumber].employeeArr.append(em )
            }
            for i in 0..<indexCount {
                let sortedPersonArr:Array<Any> = self.locationCollection.sortedArray(from: sectionModel.pinyinArr[i].employeeArr, collationStringSelector: #selector(getter: ContactorModel.nickName))
                self.sectionModel.pinyinArr[i].employeeArr = sortedPersonArr as!Array<ContactorModel>
            }
            
            var tempArray = [Int]()
            for (i, em) in sectionModel.pinyinArr.enumerated() {
                if em.employeeArr.count == 0 {
                    tempArray.append(i)
                } else {
                    sectionModel.pinyinArr[i].departmentName = self.locationCollection.sectionTitles[i]
                }
            }
            
            for i in tempArray.reversed() {
                sectionModel.pinyinArr.remove(at: i)
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
                    sectionModel.subdepartmentArr.append(m)
                    sectionModel.subEmployeeArr.append(contentsOf: m.subEmployeeArr)
                }
            })
            //            dealSectionModel(m: sectionModel!)
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
    
    func addFriend() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
