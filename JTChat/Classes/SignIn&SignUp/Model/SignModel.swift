//
//  SignModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/13.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit

class SignModel: BaseModel {
    var msg: String = ""
    var code: Int = 0
    var data: SignDataModel = SignDataModel()
    var parameter: SignParameterModel = SignParameterModel()
}

class SignDataModel: BaseModel {
    var businessDate: String = ""
    var PlaceID: Int = 0//场所ID
    var empQRCode: String = ""//签到
    var emp_IDNumber: Int = 0//身份证号
    var emp_sex: Bool = false//员工性别:1男，0女
    var emp_entryDate: String = ""//入职时间
    var emp_department: String = ""//入职部门
    var dept_name: String = ""//入职部门
    var emp_isMergeRoom: Bool = false//允许并房
    var emp_name: String = ""//员工姓名
    var emp_isVacantSetting: Bool = false//设置空房
    var emp_waistCard: String = ""//腰牌
    var emp_isAllowUsher: Bool = false//允许带位
    var emp_remark: String = ""//描述
    var emp_position: String = ""//职务
    var dutyName: String = ""//职务
    var emp_roleid: Int = 0//员工功能权限ID
    var emp_isAllowedDiscount: Bool = false//允许打折
    var emp_bhw: String = ""//三围
    var emp_status: String = ""//上班状态
    var emp_isViewBooking: Bool = false//查看预订
    var emp_isTransferBooking: Bool = false//转移预订
    var emp_isEnable: Bool = false//是否删除
    var emp_code: String = ""//员工代码
    var emp_birthPlace: String = ""//籍贯
    var emp_isOpenRoom: Bool = false//允许开房
    var emp_abbreviation: String = ""//员工姓名简写
    var emp_phone: String = ""//手机号码
    var emp_isBooking: Bool = false//预订房间
    var emp_isUptBooking: Bool = false//修改预订
    var emp_stageName: String = ""//艺名
    var emp_isAPPAdmin: Bool = false//APP管理员
    var emp_birthday: String = ""//生日
    var emp_constellation: String = ""//星座
    var emp_isAllowedGift: Bool = false//允许赠送
    var emp_isSetRepairRoom: Bool = false//设维修房
    var emp_isCreateEmp: Bool = false//是否允许管理权限组员工
    var emp_isCreateRole: Bool = false//是否允许修改权限组或创建权限组
    var emp_password: String = ""//密码
    var emp_isUnsubscribe: Bool = false//退订房间
    var emp_height: String = ""//身高
    var emp_hobby: String = ""//爱好
    var emp_stageName_short: String = ""//艺名拼音简写
    var emp_isOnStage: Bool = false//允许上台
    var emp_isViewBill: Bool = false//查看账单
    var emp_isCancelUsher: Bool = false//取消带位
    var emp_isTransferRoom: Bool = false//允许转房
    var emp_id: String = ""//自增列主键（key）
    var emp_avatar: String = ""//头像
    var emp_photo: String = ""//照片
    var emp_video: String = ""//短视频
    var emp_standardticket: Double =  0//标准台费
    var emp_isAppLocation: Bool = false//是否开启工作台位置权限
    var emp_gpsLimitDistance: Int = 0//工作台位置权限控制范围
    var softwareServiceFee: SoftwareServiceFee = SoftwareServiceFee()
}

class SignParameterModel : BaseModel {
    
    var jwt: String = ""
}

class SoftwareServiceFee: BaseModel {
    var expireTime: String = ""
    var remainDays: String = "0"
    var startTime: String = ""
}
