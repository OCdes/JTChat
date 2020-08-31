//
//  ApplyDetailViewModel.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ApplyDetailViewModel.h"
#import "PCHeader.h"
#import "RequestManager.h"
@implementation ApplyDetailViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self bindModel];
    }
    return self;
}

- (void)setState:(NSString *)state {
    _state = NSStringFormate(@"%@",state);
}

- (void)bindModel {
    @weakify(self);
    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        UITableView *tableView = (UITableView *)input;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_GETAPPROVALDETAIL params:@{@"eventNo":self.eventNo} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                [tableView jt_endRefresh];
                self.Lock = NSStringFormate(@"%@",data[@"data"][@"lock"]);
                self.ApproveInfo = data[@"data"][@"approveEvent"];
                self.ApprovePersons = data[@"data"][@"persons"];
                self.state = data[@"data"][@"approveEvent"][@"state"];
                NSMutableArray *apMarr = [NSMutableArray array];//审批人
                NSMutableArray *cpMarr = [NSMutableArray array];//抄送人
                for (NSDictionary *dict in self.ApprovePersons) {
                    if ([dict[@"authority"] isEqualToNumber:@(1)]) {
                        [cpMarr addObject:dict];
                    } else {
                        [apMarr addObject:dict];
                    }
                }
                if (apMarr.count) {
                    self.approvalList = [NSArray arrayWithArray:apMarr];
                    self.ccList = [NSArray arrayWithArray:cpMarr];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.dataArr = data[@"data"][@"persons"];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    
    self.withdrawCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_REFOUNDAPPROVAL params:@{@"eventNo":self.eventNo} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"撤销成功");
                    [self.refreshCommand execute:nil];
                    [self.refreshSubject sendNext:nil];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.setStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_UPDATESTATUSOFAPPROVAL params:@{@"eventNo":self.eventNo,@"state":input,@"remark":@""} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"设置成功");
                    [self.refreshCommand execute:nil];
                    [self.refreshSubject sendNext:nil];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        return [RACSignal empty];
    }];
    
    self.resubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_REFOUNDAPPROVAL params:@{@"eventNo":self.eventNo} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_semaphore_signal(semaphore);
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                dispatch_semaphore_signal(semaphore);
                return;
            }];
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableArray *marr =  [NSMutableArray array];
            for (NSDictionary *dict in self.approvalList) {
                NSDictionary *ddict = @{@"name":dict[@"approvePerson"],@"phone":NSStringFormate(@"%@",dict[@"approvePhone"]),@"authority": NSStringFormate(@"%@",dict[@"authority"]),@"department":dict[@"department"]};
                [marr addObject:ddict];
            }
            [RequestManager postWithApi:POST_CREATAPPROVAL params:@{@"service":@"createApprove",@"eventClassify":NSStringFormate(@"%@",self.ApproveInfo[@"eventClassify"]),@"eventContent":self.ApproveInfo[@"eventContent"],@"approvePersons":marr.mj_JSONString,@"applyType":self.ApproveInfo[@"applyType"]} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHOW_SUCCESS(@"重提成功");
                    [self.nav popViewControllerAnimated:YES];
                });
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                
            }];
        });
        
        return [RACSignal empty];
    }];
}

@end
