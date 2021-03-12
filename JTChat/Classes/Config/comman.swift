//
//  comman.swift
//  Swift-jtyh
//
//  Created by LJ on 2019/12/4.
//  Copyright © 2019 WanCai. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Moya
import SVProgressHUD
import HandyJSON
import Kingfisher
import Photos

let USERDEFAULT = UserDefaults.standard
//屏幕尺寸
let kScreenWidth: CGFloat = UIScreen.main.bounds.width
let kScreenHeight: CGFloat = UIScreen.main.bounds.height
//tabbar是否隐藏及其高度
let kTabbarHidden: Bool = true
let kTabBarHeight: CGFloat = 49
//机型判断
let kiPhoneXOrXS: Bool = kScreenHeight >= 812
let kiPhonePlus: Bool = kScreenHeight == 736 && kScreenWidth == 414
let kiPhonoe678: Bool = kScreenHeight == 667 && kScreenWidth == 375
let kiPhone45SC: Bool = kScreenHeight == 480 && kScreenHeight == 320
struct NotificationHelper {
    static let kChatOnlineNotiName = Notification.Name("kChatOnlineNotiName")
    static let kChatOnGroupNotiName = Notification.Name("kChatOnGroupNotiName")
    static let kReLoginName = Notification.Name("kReLoginName")
    static let kUpdateRedDot = Notification.Name("NewPrewarningIsComing")
    static let kUpdateRecentList = Notification.Name("kUpdateRecentList")
}
//设备ID
let UDID = UDIDManager.getUDID()
let APP_VER = JTBundleTool.bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
//--------------------------- 全局函数 -------------------------
//获取十六进制颜色
func HEX_COLOR(hexStr x: String)->UIColor {
    var hexString = x.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if (hexString.hasPrefix("#")) {
        let index = hexString.index(hexString.startIndex, offsetBy: 1)
        hexString = String(hexString[index...])
    }
    let scanner = Scanner(string: hexString)
    var color: UInt64 = 0
    scanner.scanHexInt64(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

func DECEM_COLOR(decemStr x: String)-> UIColor {
    var hexColorStr = "#"
    let decemInt = (x as NSString).intValue
    let red = (decemInt & 0xff0000) >> 16
    let green = (decemInt & 0x00ff00) >> 8
    let blue = (decemInt & 0x0000ff)
    if (blue >= 0 && blue <= 255) && (green >= 0 && green <= 255) && (red >= 0 && red <= 255) {
        var tr = String(format: "%0x", red)
        var tg = String(format: "%0x", green)
        var tb = String(format: "%0x", blue)
        tr = tr.count == 1 ? "0"+tr : tr
        tg = tg.count == 1 ? "0"+tg : tg
        tb = tb.count == 1 ? "0"+tb : tb
        hexColorStr = hexColorStr + tr + tg + tb
    } else { return HEX_FFF}
    return HEX_COLOR(hexStr: hexColorStr)
}

func isPurnInt(string: String) -> Bool {
    let regStr = "^[0-9]*$"
    let regex = try? NSRegularExpression(pattern: regStr, options: [])
    
    
    if string.count > 0 {
        if let result = regex?.matches(in: string, options: [], range: NSRange(location: 0, length: string.count)), result.count != 0 {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func isNum(str: String) -> Bool {
    let regStr = "^([0-9]{1,}[.]?[0-9]*)$"
    let regex = try? NSRegularExpression(pattern: regStr, options: [])
    
    
    if str.count > 0 {
        if let result = regex?.matches(in: str, options: [], range: NSRange(location: 0, length: str.count)), result.count != 0 {
            return true
        } else {
            return false
        }
    } else {
        return false
    }
}

func isEmailSuffixEqualToAt(textStr: String) -> Bool {
    if textStr.count > 0 , textStr.hasSuffix("@") {
        let regex = "[0-9a-zA-Z]@"
        let predicate = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: textStr)
    } else {
        return false
    }
}

func currentDateStr() -> String {
    let date = Date()
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}

func checkCameraAuth()->Bool {
    let auth = AVCaptureDevice.authorizationStatus(for: .video)
    if auth == .denied {
        let alertvc = UIAlertController(title: "提示", message: "您的相机权限未开启，请开启权限以扫描二维码", preferredStyle: .alert)
        alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
            let url = URL(string: UIApplication.openSettingsURLString)
            if let u = url, UIApplication.shared.canOpenURL(u) {
                UIApplication.shared.open(u, options: [:], completionHandler: nil)
            }
        }
        alertvc.addAction(sureAction)
        APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
        return false
    }
    return true
}

func checkPhotoLibaray()->Bool {
    if #available(iOS 14, *) {
        let status = PHPhotoLibrary.authorizationStatus(for:.readWrite)
        if status == .denied {
            let alertvc = UIAlertController(title: "提示", message: "您的照片权限未开启，请开启权限以发送图片", preferredStyle: .alert)
            alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                let url = URL(string: UIApplication.openSettingsURLString)
                if let u = url, UIApplication.shared.canOpenURL(u) {
                    UIApplication.shared.open(u, options: [:], completionHandler: nil)
                }
            }
            alertvc.addAction(sureAction)
            APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
            return false
        } else if status == .limited {
            let resut = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
            for i in 0..<resut.count {
                let re = resut[i]
                let asset = PHAsset.fetchAssets(in: re, options: nil)
                if asset.count == 0 && i == 0 {
                    return false
                }
            }
        }
        return true
    } else {
        // Fallback on earlier versions
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .denied {
            let alertvc = UIAlertController(title: "提示", message: "您的照片权限未开启，请开启权限以发送图片", preferredStyle: .alert)
            alertvc.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            let sureAction = UIAlertAction.init(title: "去打开", style: .destructive) { (ac) in
                let url = URL(string: UIApplication.openSettingsURLString)
                if let u = url, UIApplication.shared.canOpenURL(u) {
                    UIApplication.shared.open(u, options: [:], completionHandler: nil)
                }
            }
            alertvc.addAction(sureAction)
            APPWINDOW.rootViewController?.present(alertvc, animated: true, completion: nil)
            return false
        }
        return true
    }
}

func SVPShowSuccess(content str: String) {
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.showSuccess(withStatus: str)
}

func SVPShowError(content str: String) {
    SVProgressHUD.setDefaultMaskType(.none)
    SVProgressHUD.showError(withStatus: str)
}

func SVPShow(content str: String) {
    SVProgressHUD.show(withStatus: str)
}

func SVPNoUserinteractShow(content str: String) {
    SVProgressHUD.setDefaultMaskType(.clear)
    SVProgressHUD.show(withStatus: str)
    
}

func hideCardId(str: String) -> String {
    if str.count > 0  {
        let s = (str as NSString).substring(with: NSRange(location: str.count-4, length: 4))
        return "****\(s)"
    } else {
        return ""
    }
}

func timeExchange(time: String)-> String {
    if time.count > 0 {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date: Date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "MM-dd HH:mm"
        return dateFormatter.string(from: date)
    } else {
        return "日期格式无效"
    }
}

//--------------------------------------------------------------
let HEX_333 = HEX_COLOR(hexStr: "#333333")
let HEX_666 = HEX_COLOR(hexStr: "#666666")
let HEX_999 = HEX_COLOR(hexStr: "#999999")
let HEX_FFF = HEX_COLOR(hexStr: "#FFFFFF")
let HEX_LightBlue = HEX_COLOR(hexStr: "#408CE2")
let HEX_ThemeBlack = HEX_COLOR(hexStr: "#1A1C29")
let HEX_F5F5F5 = HEX_COLOR(hexStr: "#f5f5f5")
let PLACEHOLDERIMG = JTBundleTool.getBundleImg(with:"placeHolder")



let APPWINDOW: UIWindow = (UIApplication.shared.delegate?.window!)!
//云端地址
let URL_CLOUD = "https://cloud.hzjtyh.com"
public var BASE_URL = (USERDEFAULT.object(forKey: "baseURL") as? String) ?? ""
public let ACCESS_TOKEN = USERDEFAULT.object(forKey: "jwt") as! String
//请求状态码
//NOTE:网络请求状态码
let REQUEST_SUCCESSFUL: Int = 0
let REQUEST_LOGINFORBIDEN: Int = 1013
let REQUEST_SERVERERRO: Int = -400
let REQUEST_UNKNOWNERROR: Int = 1
let REQUEST_NOTOKEN: Int = 6601
let REQUEST_UNVALIDTOKEN: Int = 1005
let REQUEST_TODIVCELOGIN: Int = 6603
let REQUEST_NOPAYUSER: Int = 2001
//获取场所信息
let GET_PlACEINFO = "/api/v1/getPlaceInfo"
///获取营业日期
let GET_BUSINESSDATE = "/v1/config/getBusinessDate"
//发送验证码
let POST_SENDCODE = "/api/sms/sendSmsCode"
//登录
let POST_LOGIN = "/v1/login/appUser"
//注册
let POST_SIGNUP = "/v1/login/appRegister"
//忘记密码
let POST_FORGOT = "/v1/login/appForgetPassword"
//更新密码
let POST_CHNAGEPWD = "/v1/person/changePassword"
//获取 APP 版本信息
let POST_APPINFO = "/api/v1/getAppInfo"
///----------------------------------------工作台-------------------------------------
//获取公共信息配置 类型typeID: 1:房台类型 2:房台区域 3:房台状态 4:出品部门 5:出品区域
let POST_CONFIG = "/v1/config/getPublicConfiguration"
//获取工作台方案
let POST_WORKBENCH = "/v1/workbench/getPlaceEmployeeWorkbench"
//获取场所公共配置
let POST_PUBLICONFIG = "/v1/config/getPublicConfiguration"
//获取所有房台房态
let POST_ROOMSTATUS = "/v1/room/roomStatusNow"
///更改房间状态
let POST_CHANGEROOMSTATUS = "/v1/room/changeRoomStatus"
//获取本组或者我的房态
let POST_ROOMSTATUSOFSELF = "/v1/room/roomStatusBySelf"
//上传员工头像
let POST_UPLOADAVATAR = "/v1/person/uploadAvatar"
//获取工作组
let POST_GETWORKGROUPS = "/v1/workbench/getPlaceWorkgroup"
//删除工作组方案
let POST_DELETWORKGROUP = "/v1/workbench/delPlaceWorkgroup"
//添加员工到工作组
let POST_ADDEMPLOYEETOGROUP = "/v1/workbench/setEmployeeWrokgroup"
//获取对应工作组的员工
let POST_WORKGROUPEMPLOYEES = "/v1/workbench/getWrokgroupEmployees"
//创建或者更新工作组
let POST_UPDATEWORKGROUP = "/v1/workbench/setPlaceWorkgroup"
//从工作组移除员工
let POST_DELETEMPLOYEEFROMGROUP = "/v1/workbench/removeEmployeeWrokgroup"
//获取场所员工
let POST_GETEMPLOYEEDATA = "/v1/config/getPlaceEmployees"
//获取场所所有部门
let POST_DEPARTMENTDATA = "/v1/config/getPlaceDepartment"
///获取工作组已设置的菜单
let POST_GROUPMENUS  = "/v1/workbench/getWorkgroupMenus"
//获取所有工作组系统菜单
let POST_ALLGROUPMENUS = "/v1/workbench/getSystemWorkbenchMenu"
//设置工作组菜单
let POST_SETGROUPMENUS = "/v1/workbench/setWorkgroupMenus"
//账单消费详情
let POST_BILLDETAIL = "/v1/room/getOpenRoomBill"
//账单消费菜品详情
let POST_BILLCONSUME = "/v1/room/getOpenRoomBillDetail"
//账单上台人员
let POST_BILLSIGN = "/v1/ticket/getOnWorkList"
//获取会员列表
let POST_MEMBERLIST = "/v1/vip/getVipMembers"
//获取会员个人详情
let POST_MEMBERDETAIL = "/v1/vip/getVipMemberInfo"
//获取会员充值列表
let POST_MEMBERCHARGE = "/v1/vip/getVipMemberRechareList"
//获取会员消费列表
let POST_MEMBERCONSUME = "/v1/vip/getVipMemberConsumeList"
//获取会员系统配置
let POST_MEMBERCONFIG = "/v1/vip/getVipMemberConfiguration"
// 添加会员
let POST_CREATMEMBER = "/v1/vip/bindingVipMember"
//获取房间开房套餐
let POST_OPENROOMSET = "/v1/room/getOpenRoomPackage"
//执行开房
let POST_DOOPENROOM = "/v1/room/doOpenRoom"
//获取当前预订信息
let POST_RESERVATIONINFO = "/v1/room/getRoomBooking"
//取消房间预订
let POST_CANCLERESERVATION = "/v1/room/doRoomCancelBooking"
//预订、修改预订
let POST_DORESERVATION = "/v1/room/doRoomBooking"
//获取可预订房间列表
let POST_ROOMRESERVABLE = "/v1/room/getAllowBookingRooms"
//获取已预订房间
let POST_ROOMRESERVED = "/v1/room/getReservedRooms"
//转房
let POST_TRANSFERROOM = "/v1/room/changeOpenRoom"
//签收菜品
let POST_RECEIPTGOODS = "/v1/room/doReceiptGoods"
//获取可取酒水
let POST_GETWINEINLIST = "/v1/wine/getWineInListWithPhone"
//执行取酒
let POST_DOGETWINE = "/v1/wine/doFetchWine"
//执行打折
let POST_DODISCOUNT = "/v1/room/doDiscount"
//获取选秀名单
let POST_BEAUTYLIST = "/v1/ticket/getWaiterNowWorkStatus"
//---------------------------------------------------------------查询----------------------------------------------
//获取历史账单列表
let POST_BILLQUERY = "/v1/room/getOpenRoomHistoryBill"
///退单汇总
let POST_ORDERBACKQUERY = "/v1/summary/getGoodsChargebackSummary"
///退单明细
let POST_ORDERBACKDETAILQUERY = "/v1/summary/getGoodsChargebackRecord"
//赠送查询
let POST_GIFTQUERY = "/v1/summary/queryGiftSummary"
//打折查询
let POST_DISCOUNTQUERY = "/v1/summary/queryDiscountSummary"
//订房查询
let POST_BOOKINGROOMQUERY = "/v1/summary/queryBookingRoomSummary"
//挂账回收查询
let POST_ONCREDITQUERY = "/v1/room/getBillCredit"
//营业报表
let POST_BUSINESSREPORTFORM = "/v1/summary/getBusinessReport"
//营业汇总
let POST_BUSINESSSUMARY = "/v1/summary/getBusinessSummary"
//出品汇总
let POST_PRODUCTIONSUMARY = "/v1/summary/getGoodsSalesSummary"
//签到查询
let POST_SINGQUERY = "/v1/ticket/waiterCheckInList"
//购票汇总
let POST_BUYTICKETSUMMARY = "/v1/ticket/buyTicketSummary"
//个人购票详情
let POST_BUYTICKETDETAIL = "/v1/ticket/getBuyTicketRecord"
//个人上台次数明细
let POST_WORKTICKETDETAIL = "/v1/ticket/getOnWorkRecord"
//服务员退台查询
let POST_BACKSTATEGEQUERY = "/v1/ticket/getQuitStagekList"
//退票查询
let POST_BACKTICKETQUERY = "/v1/ticket/getRefundTicketList"
//小费查询
let POST_SERVICEFEEQUERY = "/v1/ticket/getOnWorkTip"
//免票查询
let POST_FREETICKETQUERY = "/v1/ticket/freeTicketSummary"
//扫码上台
let POST_ONSTAGE = "/v1/person/scanOnStage"
//扫码值班
let POST_ONDUTY = "/v1/person/scanOpenRoomOnDuty"
//今日值房
let POST_ONDUTYQUERY = "/v1/person/getOnDutyRoomList"
//订房业绩
let POST_RBPERFORMANCEQUERY = "/v1/summary/getOpenRoomPerformanceSummary"
///订房业绩明细
let POST_RBPERFORMANCEDETAIL  = "/v1/summary/getOpenRoomPerformanceDetail"
//个人或部门订房
let POST_ROOMBOOKINGQUERY = "/v1/room/getBookingRooms"
//点单业绩汇总
let POST_ORDERPERFORMANCEQUERY = "/v1/summary/getOrderingPerformanceSummary"
//充值过期汇总
let POST_CHARGEINVALIDSUMMARY = "/v1/summary/getRechargeExpireSummary"
//上传房情
let POST_REPORTROOMNOTEDETAIL = "/v1/person/reportRoomDetail"
//获取房情详情
let POST_ROOMNOTEDETAIL = "/v1/person/getRoomReportDetail"
//轮房查询
let POST_TURNROOMSQUERY = "/v1/summary/queryTurnsRoomSummary"
//房情查询
let POST_ROOMNOTEQUERY = "/v1/summary/queryOpenRoomSituationReport"
//日考勤汇总
let POST_SignSummary = "/v1/summary/getSigninSummary"
//出勤查询
let POST_SignRecord = "/v1/summary/querySigninRecord"
//值房查询
let POST_FetchOnDuty = "/v1/room/getDutyRoomRecord"
///-罚款查询
///<#罚款查询>
///-Parameters:
/// -startTime:<#开始时间>
/// -endTime:<#结束时间>
/// -departmentID:<#部门 ID>
/// -empID:<#员工 ID>
let POST_FineQuery = "/v1/summary/getPenaltyDetail"
//--------------------------------------------点单-----------------------------------------
//商品分类
let POST_GOODSCATEGORY = "/v1/room/goodsCategory"
//所有商品
let POST_ALLGOODS = "/v1/room/goodsList"
//所有赠送商品
let POST_ALLGIFTABLEGOODS = "/v1/room/getGiftGoods"
//获取商品详情
let POST_GOODSDETAIL = "/v1/room/goodsDetail"
//点单
let POST_DOORDER = "/v1/order/createGoodsOrder"
//赠送点单
let POST_DOGIFTORDER = "/v1/order/createGiftGoodsOrder"
//执行转房
let POST_DOTRANSFERROOM = "/v1/room/changeOpenRoom"
//我的台票账户
let POST_TICKETACCOUNT = "/v1/person/getMyTicketAccount"
//-----------------------------------------报盈-----------------------------------------------
//提交报盈
let POST_SUBMMITSURPLUS = "/v1/room/commitSurplusGoods"
//可报盈商品
let POST_GOODSOFSURPLUS = "/v1/room/getAccountSurplusGoods"
//获取可报盈房间
let POST_GETROOMFORSURPLUS = "/v1/room/getRoomsWithCommitSurplus"
//-----------------------------------------选秀----------------------------------------------
//呼叫
let POST_DOCALLGIRL = "/v1/call/doCallGirl"
/*-----------------------------------------月费----------------------------------------------*/
//创建月费请求
let POST_CREATMONTHFEEAPPLY = "/v1/recharge/createPreparePaymentQrcode"
//查询月费结果
let POST_QUERYMONTHFEERESULT = "/v1/recharge/queryPreparePaymentResult"
//GPS签到
let POST_GPSSIGNUP = "/v1/person/doAttendance"
///----------------------------------------购票-----------------------------------------------
//创建购票订单
let POST_CREATTICKETORDER  = "/v1/ticket/createBuyTicketOrder"
//查询支付结果
let POST_FETCHRESULTOFTICKET = "/v1/ticket/ticketOrderPaymentResult"
///----------------------------------------聊天----------------------------------------------
///获取联系人列表
let POST_CHATFRIENDSlIST = "/v1/chat/getMyChatFriends"
///获取讨论组列表
let POST_CHATGROUPlIST = "/v1/chat/getMyChatTopicGroups"
///静默添加好友
let POST_ADDFRIEND = "/v1/chat/addFriend"
///申请添加好友
let POST_APPLYADDFRIEND = "/v1/chat/addNewFriend"
///创建讨论组
let POST_CREATGROUP = "/v1/chat/createTopicGroup"
///为讨论组添加组员
let POST_ADDMEMBERTOGROUP = "/v1/chat/addTopicGroupMember"
/// 移除群成员
let POST_REMOVEMEMFROMGROUP = "/v1/chat/removeTopicGroupMember"
///解散群组
let POST_DELETGROUP = "/v1/chat/removeTopicGroup"
///获取讨论组详情
let POST_DETAILOFGROUP = "/v1/chat/getTopicGroupDetail"
///修改讨论信息
let POST_UPDATEGROUPINFO = "/v1/chat/updateTopicGroup"
///获取可聊天人员
let POSST_FETCHEMPLOYEETOCHAT = "/v1/chat/getPlaceChatEmployees"
///获取联系人详情
let POST_DETAILOFCHATEMPLOYEE = "/v1/chat/getChatEmployeeDetail"
///解绑设备
let POST_UNBINDDEVICE = "/v1/workbench/unbindDeviceId"
///好友申请信息
let POST_ADDAPPLY = "/v1/chat/getApplyFriendList"
///删除好友
let POST_DELETFRIEND = "/v1/chat/removeFriend"
///好友申请信息处理
let POST_DEALFRIENDAPPLY = "/v1/chat/applyFriendHandle"
///我的申请
let POST_FETCHMYADDAPPLY = "/v1/chat/getFriendApproveRecord"
///设置好友别名
let POST_SETALIAS = "/v1/chat/setFriendAliasName"
///获取系统消息列表
let POST_FETCHSYSMESSAGELIST = "/v1/chat/getJtSystemMessage"
