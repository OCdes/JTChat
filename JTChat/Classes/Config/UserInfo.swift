//
//  UserInfo.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/16.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import HandyJSON
import CoreLocation
class UserInfo: NSObject {
    
    var currentRoomID: String = ""
    
    var appModel = "0"
    
    var placeData: PlaceDataModel? {
        set {
            
        }
        get {
            return JSONDeserializer<PlaceDataModel>.deserializeFrom(dict: self.getConstancePlaceInfoData()) ?? PlaceDataModel()
        }
    }
    
    var hasShowUpdate: Bool? {
        set {
            USERDEFAULT.set(newValue ?? false, forKey: "hasShowUpdate")
        }
        get {
            return USERDEFAULT.bool(forKey: "hasShowUpdate")
        }
    }
    
    private var _userData: SignModel?
    var userData: SignModel? {
        set {
            _userData = newValue
        }
        get {
            let dict = getConstanceUserInfoData()
            if dict.keys.count > 0{
                let signModel = JSONDeserializer<SignModel>.deserializeFrom(dict: dict)
                return (signModel ?? SignModel())!
            }
            return _userData
        }
    }
    var roomStatusList: Dictionary<String, Any> {
        set {
            UserDefaults.standard.set(newValue, forKey: roomStatusKey)
        }
        get {
            let arr = UserDefaults.standard.object(forKey: roomStatusKey)
            if let a = arr {
                return a as! Dictionary<String, Any>
            } else {
                return Dictionary()
            }
            
        }
    }
    
    var roomareaList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: roomareaKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: roomareaKey) else { return []}
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var roomcateList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: rooomcateKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: rooomcateKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var productDepartList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: productDepartKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: productDepartKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var productAreaList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: productAreaKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: productAreaKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var employeeRoleList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: employeeRoleKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: employeeRoleKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var memberCardTypeList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: memberCardTypeKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: memberCardTypeKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var memberCardLevelList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: memberCardLevelKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: memberCardLevelKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var payTypeList: Array<Dictionary<String, Any>> {
        set {
            UserDefaults.standard.set(newValue, forKey: payTypeListKey)
        }
        get {
            guard let arr = UserDefaults.standard.object(forKey: payTypeListKey) else { return [] }
            return arr as! Array<Dictionary<String, Any>>
        }
    }
    
    var accontStr: String {
        set {}
        get {
            return self.userData?.data.emp_phone ?? ""
        }
    }
    
    var placeShopName: String {
        set {}
        get {
            return self.placeData?.data.placeInfo.placeName ?? ""
        }
    }
    let placeInfokey: String = "shopInfoKey"
    let userInfoKey: String = "userInfoKey"
    let roomStatusKey: String = "roomStatusKey"
    let roomareaKey: String = "roomareaKey"
    let rooomcateKey: String = "rooomcateKey"
    let productDepartKey: String = "productDepartKey"
    let productAreaKey: String = "productDepartKey"
    let employeeRoleKey: String = "employeeRoleKey"
    let memberCardTypeKey: String = "memberCardTypeKey"
    let memberCardLevelKey: String = "memberCardLevelKey"
    let payTypeListKey: String = "payTypeListKey"
    static let shared = UserInfo()
    override init() {
        super.init()
    }
    
    open func saveConstancePlaceInfoData(_ dict: Dictionary<String, Any>) {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        let str = UserInfo.shared.placeData?.data.placeInfo.agentUrl
        UserDefaults.standard.set(str, forKey: "agentUrl")
        UserDefaults.standard.set(data, forKey: placeInfokey)
        UserDefaults.standard.set(UserInfo.shared.placeData?.data.placeInfo.toJSON(), forKey: "placeInfo")
    }
    
    func getConstancePlaceInfoData()->Dictionary<String, Any> {
        let data = UserDefaults.standard.object(forKey: placeInfokey)
        if data != nil {
            let json = try? JSONSerialization.jsonObject(with: data  as! Data, options: .mutableContainers)
            let dict = json as! Dictionary<String, Any>
            return dict
        } else {
            return Dictionary()
        }
        
    }
    
    open func emptyPlaceInfo() {
        UserDefaults.standard.removeObject(forKey: placeInfokey)
    }
    
    open func saveConstanceUserInfoData(_ dict: Dictionary<String, Any>) {
        let data = try? JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        UserDefaults.standard.set(data, forKey: userInfoKey)
        let str = UserInfo.shared.userData?.data.businessDate
        UserDefaults.standard.set(str, forKey: "businessDate")
        let roleStr = UserInfo.shared.userData?.data.emp_roleid
        UserDefaults.standard.set(roleStr, forKey: "emp_roleid")
        let roleID = UserInfo.shared.userData?.data.emp_code
        USERDEFAULT.set(roleID, forKey: "emp_code")
        let token = UserInfo.shared.userData?.parameter.jwt
        USERDEFAULT.set(token, forKey: "jwt")
        let d = UserInfo.shared.userData?.data.toJSON() ?? Dictionary()
        USERDEFAULT.set(d, forKey: "userInnfoData")
        UserDefaults.standard.set(99999999, forKey: "MaxHistoryDays")
    }
    
    func getConstanceUserInfoData()->Dictionary<String, Any> {
        let data = UserDefaults.standard.object(forKey: userInfoKey)
        if data != nil {
            let json = try? JSONSerialization.jsonObject(with: data as! Data, options: .mutableContainers)
            let dict = json as! Dictionary<String, Any>
            return dict
        } else {
            return Dictionary()
        }
    }
    
    func resaveUserData() {
        let dict = self.userData?.toJSON() ?? Dictionary()
        saveConstanceUserInfoData(dict)
    }
    
    func resavePlaceData() {
        let dict = self.placeData?.toJSON() ?? Dictionary()
        saveConstancePlaceInfoData(dict)
    }
    
    open func emptyUserInfo() {
        SocketManager.manager.closeConnect()
        UserDefaults.standard.removeObject(forKey: userInfoKey)
    }
    
    var enableWorkbench: Bool = true
    
    var enableGPSSignup: Bool = false
    
    var currentLon: CLLocationDegrees?
    var currentLat: CLLocationDegrees?
    var lon: CLLocationDegrees? {
        set {}
        
        get {
            return UserInfo.shared.placeData?.data.placeDetail.longitude
        }
    }
    var lat: CLLocationDegrees? {
        set {}
        get {
            return UserInfo.shared.placeData?.data.placeDetail.latitude
        }
    }
    var isValidGps: Bool? {
        set{}
        get {
            return UserInfo.shared.placeData?.data.placeDetail.isValidGps
        }
    }
    
    var limitDistance: CLLocationDegrees? {
        set{}
        get {
            return UserInfo.shared.placeData?.data.placeDetail.limitDistance
        }
    }
    
    var emp_isAppLocation: Bool? {
        set{}
        get{
            return UserInfo.shared.userData?.data.emp_isAppLocation
        }
    }
    
    var emp_gpsLimitDistance: Int? {
        set {}
        get {
            return UserInfo.shared.userData?.data.emp_gpsLimitDistance
        }
    }
    
    var wifiEnable: Bool = false
    
}
