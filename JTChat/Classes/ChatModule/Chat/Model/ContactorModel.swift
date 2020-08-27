//
//  ContactorModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2020/7/20.
//  Copyright © 2020 WanCai. All rights reserved.
//

import UIKit

class ContactorModel: BaseModel {
    var avatarUrl: String = ""
    var createTime: String = ""
    var defaultPhotoUrl: String = ""
    var department: String = ""
    var friend: String = ""
    var gender: Bool = false
    var iD: String = ""
    var isFriend: Bool = false
    var jobNumber: String = ""
    @objc var nickName: String = ""
    var phone: String = ""
    var placeID: String = ""
    var roleID: String = ""
    var isSelected: Bool = false
    var topicGroupID: String = ""
}

class ContactDataModel: BaseModel {
    var departmentName: String = ""
    var departmentID: String = ""
    var departmentParentID: String = ""
    var employeeArr: Array<ContactorModel> = []
    var subEmployeeArr: Array<ContactorModel> = []
    var subdepartmentArr: Array<ContactDataModel> = []
    var pinyinArr: Array<ContactDataModel> = []
    var isSelected: Bool = false
    var isAllSelected: Bool = false {
        didSet {
            if employeeArr.count > 0 {
                employeeArr.forEach { (model) in
                    model.isSelected = isAllSelected
                }
            }
            if subdepartmentArr.count > 0 {
                subdepartmentArr.forEach { (model) in
                    model.isSelected = isAllSelected
                    model.isAllSelected = isAllSelected
                }
            }
        }
    }
    
    
}
