//
//  PurchaseApplyViewModel.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "PurchaseApplyViewModel.h"
#import "PCHeader.h"
#import "RequestManager.h"
@implementation PurchaseApplyViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.noteMArr = [NSMutableArray array];
        self.goodsMArr = [NSMutableArray arrayWithObject:[ApprovalGoodsModel new]];
        self.approvalMArr = [NSMutableArray array];
        self.applyTypeSubject = [RACSubject subject];
        self.refreshSubject = [RACSubject subject];
        [self bindModel];
    }
    return self;
}


- (void)bindModel {
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UITableView *tableView = (UITableView *)input;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_FETCHAPPLYTYPTE params:@{@"eventClassify":self.requestType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                if (data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.approvalTypeList = data[@"data"];
                    });
                }
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
            
            [RequestManager postWithApi:POST_GETAPPROVALER params:@{@"eventClassify":self.requestType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
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
                            tableView.userInteractionEnabled = isUserinteraction;
                        }
                         });
                    } else {
                        SHOW_ERROE(@"需要完善组织架构才能使用！");
                        tableView.userInteractionEnabled = isUserinteraction;
                    }
                }
                
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
            
            
        });
        return [RACSignal empty];
    }];
    
    self.applyTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [RACSignal empty];
    }];
    
    self.submitApprove = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSMutableArray *marr = [NSMutableArray array];
        if (!self.applyType.length || !self.applyDate.length) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        for (ApprovalGoodsModel *model in self.goodsMArr) {
            if (!model.GoodsName.length || !model.GoodsModel.length || !model.Quantity.length || !model.Unit.length || !model.Price.length) {
                SHOW_ERROE(@"采购明细中*标项为必填项");
                return [RACSignal empty];
            }
            if (!model.Remark) {
                model.Remark = @"";
            }
            model.RequiredDate = self.applyDate;
            [marr addObject:model.mj_keyValues];
        }
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"1",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":self.applyType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"提交成功")
                    [self.nav popViewControllerAnimated:YES];
                    [self.refreshSubject sendNext:data[@"parameter"]];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.submitFreeTicketCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if ([self.applyType isEqualToString:@"当天全免"]) {
            if (!self.applyType.length || !self.applyDate.length) {
                SHOW_ERROE(@"*标项为必填项");
                return [RACSignal empty];
            }
        } else {
            if (!self.applyType.length || !self.applyReason.length || !self.freeNum.length || !self.applyDate.length) {
                SHOW_ERROE(@"*标项为必填项");
                return [RACSignal empty];
            }
        }
        
        NSArray *marr = @[@{@"EmployeeNo":[USERDEFAULTS objectForKey:@"emp_code"],@"RequiredDate":self.applyDate,@"FreeType":self.applyType,@"Quantity":([self.applyType isEqualToString:@"当天全免"]?@"0":self.freeNum),@"Remark":self.applyNote?self.applyNote:@""}];
        
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"4",@"eventContent":goodsStr,@"approvePersons":approvalStr} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"提交成功")
                    [self.nav popViewControllerAnimated:YES];
                    [self.refreshSubject sendNext:data[@"parameter"]];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.submitAdvanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (!self.applyType.length || !self.money.length || !self.applyDate.length) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        NSArray *marr = @[@{@"EmployeeNo":[USERDEFAULTS objectForKey:@"emp_code"],@"RequiredDate":self.applyDate,@"TotalFees":self.money,@"Remark":self.applyNote?self.applyNote:@""}];
        
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"3",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":self.applyType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"提交成功")
                    [self.nav popViewControllerAnimated:YES];
                    [self.refreshSubject sendNext:data[@"parameter"]];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.submitExpenseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (!self.applyType.length ) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        NSMutableArray *marr = [NSMutableArray array];
        for (ApprovalGoodsModel *model in self.goodsMArr) {
            if (!model.expenseFeeType.length || !model.expenseFee.length || !model.RequiredDate.length) {
                SHOW_ERROE(@"报销明细中*标项为必填项");
                return [RACSignal empty];
            }
            NSDictionary *dict = @{@"ProduceDate":model.RequiredDate, @"CostDescription":model.note?model.note:@"", @"CostAmount":model.expenseFee,@"Tickets":@"",@"Remark":model.expenseFeeType};
            [marr addObject:dict];
        }
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"2",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":self.applyType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"提交成功")
                    [self.nav popViewControllerAnimated:YES];
                    [self.refreshSubject sendNext:data[@"parameter"]];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.submitAskoffCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (!self.applyType.length || !self.applyReason.length || !self.startTime.length || !self.endTime.length) {
            SHOW_ERROE(@"*标项为必填项");
            return [RACSignal empty];
        }
        NSArray *marr = @[@{@"EmployeeNo":[USERDEFAULTS objectForKey:@"emp_code"],@"Type":self.applyType,@"StartTime":self.startTime,@"EndTime":self.endTime,@"Hours":self.hours,@"Remark":self.applyReason}];
        
        NSString *goodsStr = marr.mj_JSONString;
        NSString *approvalStr = self.personList.mj_JSONString;
        approvalStr = [[[[approvalStr stringByReplacingOccurrencesOfString:@"姓名" withString:@"name"] stringByReplacingOccurrencesOfString:@"手机" withString:@"phone"] stringByReplacingOccurrencesOfString:@"类型" withString:@"authority"] stringByReplacingOccurrencesOfString:@"部门" withString:@"department"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":@"7",@"eventContent":goodsStr,@"approvePersons":approvalStr,@"applyType":self.applyType} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"提交成功")
                    [self.nav popViewControllerAnimated:YES];
                    [self.refreshSubject sendNext:data[@"parameter"]];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    //1采购审批,2报销审批,3用款审批,\r 4免票审批,5退票审批,6打折审批 \r 7请假审批
    self.examineTypeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"getBusinessType",@"eventClassify":input} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
//                
//            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
//                
//            }];
//        });
        return [RACSignal empty];
    }];
}

@end


@implementation ApprovalMenModel



@end


@implementation ApprovalGoodsModel



@end
