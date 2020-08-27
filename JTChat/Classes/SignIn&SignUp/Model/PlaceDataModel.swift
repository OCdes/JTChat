//
//  PlaceDataModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import CoreLocation
class PlaceDataModel: BaseModel {
    var msg: String = ""
    var code: Int = 0
    var data: RegistData = RegistData()
}

class RegistData: BaseModel {
    var placeInfo: MerchantPlaceInfo = MerchantPlaceInfo()
    var placeDetail: MerchantDetail = MerchantDetail()
}

class MerchantPlaceInfo: BaseModel {
    var id: String = ""
    var placeAddress: String = ""
    var contact: String = ""
    var notifyUrl: String = ""
    var appKey: String = ""
    var placeFoodPicPrefix: String = ""
    var placeGiftPicPrefix: String = ""
    var switchGroupID: String = ""
    var status: String = ""
    var createTime: String = ""
    var remark: String = ""
    var phone: String = ""
    var placeName: String = ""
    var merchantID: String = ""
    var appSecret: String = ""
    var isDelete: String = ""
    var workbenchScheme: String = ""
    var agentUrl: String = ""
    var placeTypeID: String = ""
}

class MerchantDetail: BaseModel {
    var isShowWatermark: Bool = false
    var isBindDevice: String = ""
    var cityCode: String = ""
    var isValidGps: Bool = false
    var service: String = ""
    var icon: String = ""
    var id: String = ""
    var env: String = ""
    var iconUrl: String = ""
    var placeID: String = ""
    var limitDistance: CLLocationDegrees = 0
    var isUsedActivityCode: String = ""
    var star: String = ""
    var sound: String = ""
    var longitude: CLLocationDegrees = 0
    var latitude: CLLocationDegrees = 0
    var workTime: String = ""
    var banner1: String = ""
    var banner2: String = ""
    var banner3: String = ""
    var banner1Url: String = ""
    var banner2Url: String = ""
    var banner3Url: String = ""
    var buySoftwareServiceType: String = ""
    var searchDaysLimit: Int = 0
    var appAttendanceWifi: String = ""
    var appUpdateVersionRemind: Bool = false
}
