//
//  MyApplyListViewModel.m
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "MyApplyListViewModel.h"
#import "PCHeader.h"
#import "RequestManager.h"
@interface MyApplyListViewModel ()

@end

@implementation
MyApplyListViewModel

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
        UITableView *tableView = (UITableView *)input;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [RequestManager postWithApi:POST_GETAPPROVALEVENTS params:@{@"type":@(self.type)} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
                [tableView jt_endRefresh];
                if (data) {
                    self.originArr = data[@"data"];
                    [self.scrollCommand execute:nil];
                } else {
                    
                }
                
            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
                [tableView jt_endRefresh];
                SHOW_ERROE(msg);
            }];
        });
        return [RACSignal empty];
    }];
    
    self.scrollCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSMutableArray *marr = [NSMutableArray array];
        for (NSDictionary *dict in self.originArr) {
             if (self.type == ApprovalLIistTypeApproval) {
                if ([self.screenType isEqualToString: @"1"]) {
                    if (dict[@"approveState"]) {
                        if ([dict[@"approveState"] integerValue] ) {
                                [marr addObject:dict];
                        } else {
                            if ([dict[@"state"] integerValue] >= 2 ) {
                                [marr addObject:dict];
                            }
                        }
                    }
                } else {
                    if (dict[@"approveState"]) {
                        if (![dict[@"approveState"] integerValue] ) {
                            if ([dict[@"state"] integerValue] < 2 ) {
                                [marr addObject:dict];
                            }
                        }
                    }
                }
            } else {
                if ([self.screenType isEqualToString: @"1"]) {
                    if ([dict[@"state"] integerValue] >= 2 ) {
                        [marr addObject:dict];
                    }
                } else {
                    if ([dict[@"state"] integerValue] < 2 ) {
                        [marr addObject:dict];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArr = [NSArray arrayWithArray:marr];
        });
        return [RACSignal empty];
    }];
}

@end
