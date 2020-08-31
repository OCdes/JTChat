//
//  PCHeader.h
//  Swift-jtyh
//
//  Created by LJ on 2020/3/19.
//  Copyright © 2020 WanCai. All rights reserved.
//

#ifndef PCHeader_h
#define PCHeader_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <ALQRCode/ALGeneratorQRCode.h>
#import <SDWebImage/SDWebImage.h>
#import "UIColor+HexColor.h"
#import "UIView+Size.h"
#import "UIButton+Setting.h"
#import <MJExtension/MJExtension.h>
#import "精特娱通-Swift.h"
#import "NSString+Category.h"
#import "JTHUD.h"
#import <AFNetworking/AFNetworking.h>
#import "PrewarningDataManager.h"
//NOTE:尺寸类
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height
#define APPWINDOW [[UIApplication sharedApplication] delegate].window
#define BUSINESSDATE [[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]
#define IphoneX  [UIScreen mainScreen].bounds.size.height >= 812
//系统字体设置字号
#define SYS_FONT(font) [UIFont systemFontOfSize:font]
#define NSStringFormate(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define HexColor(color) [UIColor colorFromHexCode:color]
//提示框
#define SHOWHUD(title) [JTHUD showWithStatus:title]
#define SHOW_ERROE(title) [JTHUD showErrorWithStatus:title];
#define SHOW_SUCCESS(title) [JTHUD showSuccessWithStatus:title];
//dismiss 提示框
#define DISMISS_HUD(time) \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ \
[SVProgressHUD dismiss]; \
});
#define HEX_FFF HexColor(@"#FFFFFF")
#define HEX_999 HexColor(@"#999999")
#define HEX_666 HexColor(@"#666666")
#define HEX_333 HexColor(@"#333333")
#define HEX_LIGHTBLUE HexColor(@"#408CE2")

#define jwt (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"jwt"]
#define emp_code (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"emp_code"]
#define PREWARNING_MANAGER [PrewarningDataManager manager]

#define agentUrl @"http://192.168.0.82:14002"//测试地址：@"http://192.168.0.82:14002" //正式地址：(NSString *)[USERDEFAULTS objectForKey:@"agentUrl"]


//-------------------接口------------------1
/// 获取审批事件的业务类型
#define POST_FETCHAPPLYTYPTE @"/v1/approve/getBusinessType"
//获取审批事件 type:1 我创建的审批 2 我要处理的审批 3 抄送给我的审批
#define POST_GETAPPROVALEVENTS @"/v1/approve/getApproveList"
//创建审批事件
#define POST_CREATAPPROVAL @"/v1/approve/createApprove"
//获取推送审批人
#define POST_GETAPPROVALER @"/v1/approve/getPushLeaders"
//撤销审批
#define POST_REFOUNDAPPROVAL @"/v1/approve/repealApprove"
//获取审批事件详情
#define POST_GETAPPROVALDETAIL @"/v1/approve/getApproveDetail"
//获取可退票房间
#define POST_GETREFOUNDABLEROOMS @"/v1/approve/getAllowRefundTicket"
//执行审批事件
#define POST_UPDATESTATUSOFAPPROVAL @"/v1/approve/doUpdateApproveState"
#endif /* PCHeader_h */
