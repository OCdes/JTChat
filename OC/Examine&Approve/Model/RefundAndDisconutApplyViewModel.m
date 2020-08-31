//
//  RefundAndDisconutApplyViewModel.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "RefundAndDisconutApplyViewModel.h"
#import "SimpleAlertView.h"
#import "PCHeader.h"
#import "RequestManager.h"
@interface RefundAndDisconutApplyViewModel ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RefundAndDisconutApplyViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindModel];
    }
    return self;
}

- (void)bindModel {
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UITableView *tablview = (UITableView *)input;
        self.tableView = tablview;
        
        dispatch_group_t group = dispatch_group_create();
        
        dispatch_group_enter(group);
        [RequestManager postWithApi:POST_GETREFOUNDABLEROOMS params:@{@"type":[self.type isEqualToString:@"3"]?@(1):@(2)} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            dispatch_group_leave(group);
            NSArray *arr = data[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (arr.count) {
                    self.selectArr = data[@"data"];
                } else {
                    NSString *contentStr = [self.type isEqualToString:@"3"] ? @"当前暂无可退台票":@"当前暂无可打折房间";
                    SimpleAlertView *alertView = [[SimpleAlertView alloc] init];
                    alertView.sureTitle = @"我知道了";
                    alertView.contentStr = contentStr;
                    [alertView show];
                }
            });
        } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [RequestManager postWithApi:POST_GETAPPROVALER params:@{@"eventClassify":self.type} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            if (data) {
                NSArray *arr = data[@"data"];
                BOOL isUserinteraction = NO;
                self.personList = data[@"data"];
                if (arr.count) {
                    NSMutableArray *apMarr = [NSMutableArray array];//审批人
                    NSMutableArray *cpMarr = [NSMutableArray array];//抄送人
                    for (NSDictionary *dict in arr) {
                        if ([dict[@"authority"] isEqualToNumber:@(1)]) {
                            [cpMarr addObject:dict];
                        } else {
                            [apMarr addObject:dict];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (apMarr.count) {
                            self.approvalList = [NSArray arrayWithArray:apMarr];
                            self.ccList = [NSArray arrayWithArray:cpMarr];
                        } else {
                            SHOW_ERROE(@"需要设置审批人后才能使用！");
                            tablview.userInteractionEnabled = isUserinteraction;
                        }
                    });
                } else {
                    SHOW_ERROE(@"需要完善组织架构才能使用！");
                    tablview.userInteractionEnabled = isUserinteraction;
                }
            }
            dispatch_group_leave(group);
        } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
            dispatch_group_leave(group);
        }];
        
        
        
        return [RACSignal empty];
    }];
    
    
    self.submitRefundTicketCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (!self.applyRoom.length || !self.applyNote.length || !self.money.length) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        NSArray *marr = @[@{@"EmployeeNo":[USERDEFAULTS objectForKey:@"emp_code"], @"RefundDate":BUSINESSDATE, @"RoomName": self.applyRoom,@"BillNo":self.discountBill,@"Amount":self.money,@"TicketID":self.ticketID,@"Remark":self.applyNote?self.applyNote:@""}];
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"5",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":@""} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            SHOW_SUCCESS(@"提交成功")
            [self.nav popViewControllerAnimated:YES];
            [self.refreshSubject sendNext:data[@"parameter"]];
        } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
            
        }];
        return [RACSignal empty];
    }];
    
    self.submitDiscountCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (!self.applyRoom.length || !self.discount.length || !self.applyReason.length) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        NSArray *marr = @[@{@"EmployeeNo":[USERDEFAULTS objectForKey:@"emp_code"],@"RoomName":self.applyRoom,@"BillNo":self.discountBill,@"Discount":self.discount,@"Remark":self.applyNote?self.applyNote:@""}];
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"6",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":@""} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
            SHOW_SUCCESS(@"提交成功")
            [self.nav popViewControllerAnimated:YES];
            [self.refreshSubject sendNext:data[@"parameter"]];
        } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
            
        }];
        return [RACSignal empty];
    }];
}

- (id)updateApproveList:(id)approveList selectList:(id)selectList {
    if(approveList ){
        NSArray *arr = approveList[@"Data"];
        self.personList = approveList[@"Data"];
        if (arr.count) {
            NSMutableArray *apMarr = [NSMutableArray array];//审批人
            NSMutableArray *cpMarr = [NSMutableArray array];//抄送人
            for (NSDictionary *dict in arr) {
                if ([dict[@"类型"] isEqualToNumber:@(1)]) {
                    [cpMarr addObject:dict];
                } else {
                    [apMarr addObject:dict];
                }
            }
            if (apMarr.count) {
                self.approvalList = [NSArray arrayWithArray:apMarr];
                self.ccList = [NSArray arrayWithArray:cpMarr];
            } else {
                SHOW_ERROE(@"需要设置审批人后才能使用！");
                self.tableView.userInteractionEnabled = NO;
            }
            
        } else {
            SHOW_ERROE(@"需要完善组织架构才能使用！");
            self.tableView.userInteractionEnabled = NO;
        }
        
    }
    if (selectList ) {
        NSArray *arr = selectList[@"Data"];
        if (arr.count) {
            self.selectArr = selectList[@"Data"];
        } else {
            NSString *contentStr = [self.type isEqualToString:@"3"] ? @"当前暂无可退台票":@"当前暂无可打折房间";
            SimpleAlertView *alertView = [[SimpleAlertView alloc] init];
            alertView.sureTitle = @"我知道了";
            alertView.contentStr = contentStr;
            [alertView show];
        }
    }
    return @{@"ErrCode":@(approveList[@"ErrCode"]&&selectList[@"ErrCode"])};
}

@end
