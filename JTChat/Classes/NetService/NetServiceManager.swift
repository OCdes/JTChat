//
//  NetServiceManager.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/3.
//  Copyright © 2019 WanCai. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift
import SystemConfiguration.CaptiveNetwork

//http://localhost/TestSites/app.json
//网络环境枚举->分别为测试网络环境，开发网络环境，生产网络环境
enum NetworkEnvironment {
    case NetworkEnvironmentTest
    case NetworkEnvironmentDevelopment
    case NetworkEnvironmentProduct
    case NetworkEnviromentMerchantInfo
}
//请求类型
enum RequestType {
    case RequestTypeGet
    case RequestTypePost
    case RequestTypeUpload
    case RequestTypeDownload
}
//网络状态码
enum NetworkStautsCode : Int32 {
    case NetworkStatusCodeUnkonw        = -1
    case NetworkStatusCodeNotReachable  = 0
    case NetworkStautsCodeWWAN          = 1
    case NetworkStatusCodeWifi          = 2
    
}
/** 访问出错具体原因 */
struct AFSErrorInfo {
    var code = 0
    var message = ""
    var error: NSError?
}
//网络请求成功回调
typealias RequestSuccess = (_ msg: String,_ code: Int,_ response: AnyObject, _ data: Dictionary<String, Any>) -> Void
//网络请求失败回调
typealias RequestFail = (AFSErrorInfo)->Void
//网络状态
typealias NetworkStatus = (_ status: UInt32)->Void
//加载进度
typealias NetworkProgress = (_ value: Double)->Void


//网络环境
let currentNetworkEv: NetworkEnvironment = .NetworkEnvironmentProduct

let networkTimeout: TimeInterval = 20

var netBaseUrl: String = "http://192.168.0.82:14002"

func urlByNetworkEnv(env: NetworkEnvironment)->String{
    var urlStr = BASE_URL
    switch env {
    case .NetworkEnvironmentTest:
        urlStr = netBaseUrl
    case .NetworkEnvironmentDevelopment:
        urlStr = netBaseUrl
    case .NetworkEnvironmentProduct:
        urlStr = BASE_URL
    case .NetworkEnviromentMerchantInfo:
        urlStr = URL_CLOUD
    }
    
    return urlStr
}


class NetServiceManager: NSObject {
    private var sessionManager: SessionManager?
    static let manager = NetServiceManager()
    let dataCachePath = NSHomeDirectory()+"/Documents/NetworkDataCache/"
    let networkStatus: NetworkStautsCode = .NetworkStatusCodeWifi
    private var header:[String: Any] = {
        var httpHeader: HTTPHeaders = SessionManager.defaultHTTPHeaders
        return httpHeader
    }()
    private var subject: PublishSubject<Any>?
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = networkTimeout
        
        sessionManager = SessionManager.init(configuration: configuration, delegate: SessionDelegate.init(), serverTrustPolicyManager: nil)
        
    }
    
    public func checkWifi() {
        UserInfo.shared.wifiEnable = UserInfo.shared.placeData?.data.placeDetail.appAttendanceWifi ?? "" == self.getSSID()
        if UserInfo.shared.wifiEnable && !(UserInfo.shared.isValidGps ?? false) {
            LocationManager.manager.endLocation()
            UserInfo.shared.enableGPSSignup = false
        } else {
            if UserInfo.shared.isValidGps ?? false {
                LocationManager.manager.startLocation()
            }
        }
    }
    
    private func getSSID() -> String {
        let interfaces = CNCopySupportedInterfaces()
        var ssid = ""
        if interfaces != nil {
            let interfacesArray = CFBridgingRetain(interfaces) as! Array<Any>
            if interfacesArray.count > 0 {
                let interfaceName = interfacesArray[0] as! CFString
                let ussafeInterfaceData = CNCopyCurrentNetworkInfo(interfaceName)
                if (ussafeInterfaceData != nil) {
                    let interfaceData = ussafeInterfaceData as! Dictionary<String, Any>
                    ssid = interfaceData["SSID"]! as! String
                 }
            }
        }
        return ssid
    }
    
    public func requestByType(requestType: RequestType, url: String, params: [String: Any], success: @escaping RequestSuccess, fail: @escaping RequestFail)->PublishSubject<Any> {
        let sub: PublishSubject = PublishSubject<Any>()
        if let a = UserInfo.shared.userData?.parameter.jwt {
            self.header["jwt"] = a
        }
        switch requestType {
        case .RequestTypeGet:
            self.GET(requestType: requestType, url: url, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypePost:
            self.POST(requestType: requestType, url: url, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeUpload:
            self.POST(requestType: requestType, url: url, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeDownload:
            self.GET(requestType: requestType, url: url, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        }
        return sub
    }
    
    public func requestByType(requestType: RequestType, api: String, params: [String: Any], success: @escaping RequestSuccess, fail: @escaping RequestFail)->PublishSubject<Any> {
        let sub: PublishSubject = PublishSubject<Any>()
        if let a = UserInfo.shared.userData?.parameter.jwt {
            self.header["jwt"] = a
        }
        let uStr = urlByNetworkEnv(env: currentNetworkEv) + api
        print("\(uStr)\(params)")
        switch requestType {
        case .RequestTypeGet:
            self.GET(requestType: requestType, url: uStr, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }

        case .RequestTypePost:
            self.POST(requestType: requestType, url: uStr, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }

        case .RequestTypeUpload:
            self.POST(requestType: requestType, url: uStr, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        case .RequestTypeDownload:
            self.GET(requestType: requestType, url: uStr, params: params, success: { (msg, code, response, data) in
                success(msg,code,response,data)
                sub.onNext(data)
                sub.dispose()
            }) { (errorInfo) in
                fail(errorInfo)
            }
        }
        return sub
    }
}

extension NetServiceManager {
    
    fileprivate func GET(requestType: RequestType, url: String, params: [String: Any], success:@escaping RequestSuccess, fail:@escaping RequestFail){
        self.sessionManager?.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: self.header as? HTTPHeaders).validate().responseJSON(completionHandler: { (response) in
            self.handleResponse(response: response, successBlock: success, faliedBlock: fail)
        })
    }

    fileprivate func POST(requestType: RequestType, url: String, params: [String: Any], success:@escaping RequestSuccess, fail:@escaping RequestFail){
        var paraItems:[String] = Array()
        for (key,value) in params {
            paraItems.append("\(key)=\(value)")
        }
        let paraStr = paraItems.joined(separator: "&")
        let urlReqest = URL.init(string: url)
        var request = URLRequest.init(url: urlReqest!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = paraStr.data(using: .utf8)
        self.sessionManager?.request(url, method: HTTPMethod.post, parameters: params, encoding: URLEncoding.default, headers: self.header as? HTTPHeaders).responseJSON(completionHandler: { (response) in
            return self.handleResponse(response: response, successBlock: success, faliedBlock: fail)
        })
    }
    
    func UploadImage(images: [UIImage], api: String, param: Dictionary<String, Any>, isShowHUD: Bool, progressBlock: @escaping NetworkProgress, successBlock:@escaping RequestSuccess,faliedBlock:@escaping RequestFail) {
        if let a = UserInfo.shared.userData?.parameter.jwt {
            self.header["jwt"] = a
            self.header["content-type"] = "multipart/form-data"
        }
        images.forEach { (image) in
            postImage(image: image, url: BASE_URL+api, param: param, headers: self.header as! HTTPHeaders, isShowHUD: isShowHUD, progressBlock: progressBlock, successBlock: successBlock, faliedBlock: faliedBlock)
        }
    }
        
    //    上传图片
        func postImage(image: UIImage, url: String, param: Parameters?, headers: HTTPHeaders, isShowHUD: Bool, progressBlock: @escaping NetworkProgress, successBlock:@escaping RequestSuccess,faliedBlock:@escaping RequestFail) {
            
            let imageData = image.jpegData(compressionQuality: 1.0) 
            self.sessionManager?.upload(multipartFormData: { (multipartFormData) in
                //采用post表单上传
                // 参数解释
                let dataStr = DateFormatter.init()
                dataStr.dateFormat = "yyyyMMddHHmmss"
                let fileName = "\(dataStr.string(from: Date.init())).png"
                multipartFormData.append(imageData!, withName: "file", fileName: fileName, mimeType: "image/jpg/png/jpeg")
                if let dict = param {
                    for (key, value) in dict {
                        multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
                
            }, to: url, headers: headers, encodingCompletion: { (encodingResult) in
                
                switch encodingResult {
                case .success(let upload, _, _):
                    //连接服务器成功后，对json的处理
                    upload.responseJSON { response in
                        //解包
                        self.handleResponse(response: response, successBlock: successBlock, faliedBlock: faliedBlock)
    //                    print("json:\(result)")
                    }
                    //获取上传进度
                    upload.uploadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                        progressBlock(progress.fractionCompleted);
                        print("图片上传进度: \(progress.fractionCompleted)")
                    }
                    break
                case .failure(let encodingError):
                    self.handleRequestError(error: encodingError as NSError, faliedBlock: faliedBlock)
                    break
                }
            })
        }
    /** 处理服务器响应数据*/
    private func handleResponse(response:DataResponse<Any>, successBlock: RequestSuccess ,faliedBlock: RequestFail){
        if let error = response.result.error {
            // 服务器未返回数据
                self.handleRequestError(error: error as NSError , faliedBlock: faliedBlock)
            
        }else if let value = response.result.value {
            // 服务器又返回数h数据
            if (value as? NSDictionary) == nil {
                // 返回格式不对
                self.handleRequestSuccessWithFaliedBlcok(faliedBlock: faliedBlock)
            }else{
                self.handleRequestSuccess(value: response.data as Any, data: value as! Dictionary<String, Any>, successBlock: successBlock, faliedBlock: faliedBlock)
            }
        }
    }
    
    /** 处理请求失败数据*/
    private func handleRequestError(error: NSError, faliedBlock: RequestFail){
        var errorInfo = AFSErrorInfo();
        errorInfo.code = error.code;
        errorInfo.error = error;
        if ( errorInfo.code == -1009 ) {
            errorInfo.message = "无网络连接";
        }else if ( errorInfo.code == -1001 ){
            errorInfo.message = "请求超时";
        }else if ( errorInfo.code == -1005 ){
            errorInfo.message = "网络连接丢失(服务器忙)";
        }else if ( errorInfo.code == -1004 ){
            errorInfo.message = "服务没有启动";
        }else if ( errorInfo.code == 404 || errorInfo.code == 3) {
        }
        faliedBlock(errorInfo)
    }
    
     /** 处理请求成功数据*/
    private func handleRequestSuccess(value: Any, data: Dictionary<String , Any>, successBlock: RequestSuccess,faliedBlock: RequestFail){
        let code: Int = (data["error_code"] ?? (data["code"] ?? data["status"] ?? "101")) as! Int
        let msg: String = (data["msg"] ?? data["Msg"] ?? data["message"] ?? "未知错误") as! String
        if code == REQUEST_SUCCESSFUL {
            successBlock(msg,code,value as AnyObject,data)
        } else if code == 501 {
            RootConfig.reLogin()
        } else {
            var errorInfo = AFSErrorInfo();
            errorInfo.code = code;
            errorInfo.message = msg.count > 0 ? msg : "";
            faliedBlock(errorInfo)
        }
    }
    
    /** 服务器返回数据解析出错*/
    private func handleRequestSuccessWithFaliedBlcok(faliedBlock:RequestFail){
        var errorInfo = AFSErrorInfo();
        errorInfo.code = -1;
        errorInfo.message = "数据解析出错";
    }
}

