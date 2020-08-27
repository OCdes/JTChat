//
//  SignInViewModel.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/12.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import SVProgressHUD
import HandyJSON

enum CodeType: UInt32 {
    case CodeTypeRegister = 161125
    //    case CodeTypeForgot = 152066
    //    case CodeTypeLogin = 152065
}

typealias sendCodeBlock = (_ resultOfSend: Bool)->Void

class SignInViewModel: BaseViewModel {
    var accountValid: Bool = false
    var passwordValid: Bool = false
    var loginBtnValid: Bool = false
    var accountStr: String = ""
    var passwordStr: String = ""
    var phoneStr: String = ""
    var verifyCode: String = ""
    var sendCodeBlock: sendCodeBlock = {a in}
    @objc dynamic var shopNameStr: String = ""
    var signModel: PlaceDataModel?
    override init() {
        super.init()
    }
    func getPlaceInfo() {
        let _ = NetServiceManager.manager.requestByType(requestType: RequestType.RequestTypeGet, url: URL_CLOUD + GET_PlACEINFO, params: ["Phone":self.accountStr,"Env":"App","AdapterAppID":3], success: { (msg, code, response, data) in
            if code == REQUEST_SUCCESSFUL {
                
                self.signModel = JSONDeserializer<PlaceDataModel>.deserializeFrom(dict:data)
                self.shopNameStr = self.signModel!.data.placeInfo.placeName
                BASE_URL = self.signModel?.data.placeInfo.agentUrl ?? ""
                UserInfo.shared.saveConstancePlaceInfoData(data)
            } else {
                SVPShowError(content: msg)
            }
        }) { (erroInfo) in
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
    
    func getPlaceInfoByID() {
        let _ = NetServiceManager.manager.requestByType(requestType: RequestType.RequestTypeGet, url: URL_CLOUD + GET_PlACEINFO, params: ["ID":self.accountStr,"Env":"App","AdapterAppID":3], success: { (msg, code, response, data) in
            if code == REQUEST_SUCCESSFUL {
                
                self.signModel = JSONDeserializer<PlaceDataModel>.deserializeFrom(dict:data)
                self.shopNameStr = self.signModel!.data.placeInfo.placeName
                BASE_URL = self.signModel?.data.placeInfo.agentUrl ?? ""
                UserInfo.shared.saveConstancePlaceInfoData(data)
            } else {
                SVPShowError(content: msg)
            }
        }) { (erroInfo) in
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
    //发送验证码
    func sendCodeWithType(type typeCode: CodeType) {
        let _ = NetServiceManager.manager.requestByType(requestType: RequestType.RequestTypePost, url: URL_CLOUD + POST_SENDCODE, params: ["Phone":self.phoneStr, "TemplateID" : typeCode.rawValue], success: { (msg, code, response, data) in
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            self.sendCodeBlock(true)
        }) { (erroInfo) in
            self.sendCodeBlock(false)
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
    //注册
    func signUp() {
        let _ = NetServiceManager.manager.requestByType(requestType: RequestType.RequestTypePost, api: POST_SIGNUP, params: ["phone":self.phoneStr, "smsCode":self.verifyCode, "password":self.passwordStr, "placeID":self.accountStr,"deviceID":UDID,"systemOS":"ios","versionNo":APP_VER ], success: { (msg, code, response, data) in
            if code == REQUEST_SUCCESSFUL {
                SVProgressHUD.showSuccess(withStatus: msg)
                self.navigationVC?.popToRootViewController(animated: true)
            } else {
                SVPShowError(content: msg)
            }
        }) { (erroInfo) in
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
    //登录
    func login() {
        SVPNoUserinteractShow(content: "登录中...")
        let _ = NetServiceManager.manager.requestByType(requestType: RequestType.RequestTypePost, api: POST_LOGIN, params: ["phone":accountStr,"password":passwordStr,"appID":"3","deviceID":UDID,"systemOS":"ios","versionNo":APP_VER], success: { (msg, code, response, data) in
            
            if code == REQUEST_SUCCESSFUL {
                
                UserInfo.shared.saveConstanceUserInfoData(data)
                SVPShowSuccess(content: "登录成功")
               
                SocketManager.manager.creatSocketConnect()
            } else {
                SVPShowError(content: msg)
            }
            
        }) { (erroInfo) in
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
    //找回密码
    func setNewPassword() {
        let _ = NetServiceManager.manager.requestByType(requestType: .RequestTypePost, url: URL_CLOUD + POST_FORGOT, params: ["phone":self.phoneStr,"smsCode":self.verifyCode,"password":self.passwordStr,"deviceID":UDID], success: { (msg, code, response, data) in
            SVProgressHUD.showSuccess(withStatus: "找回成功")
        }) { (erroInfo) in
            SVProgressHUD.showError(withStatus: (erroInfo.message.count>0 ? erroInfo.message : "未知错误"))
        }
    }
}
