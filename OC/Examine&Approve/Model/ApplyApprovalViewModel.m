//
//  ApplyApprovalViewModel.m
//  JingTeYuHui
//
//  Created by LJ on 2019/10/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "ApplyApprovalViewModel.h"
#import "PCHeader.h"
#import "RequestManager.h"
@implementation ApplyApprovalViewModel

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
//        dispatch_async(dispatch_get_global_queue(DISPATCH_TARGET_QUEUE_DEFAULT, 0), ^{
//            [RequestManager postWithApi:POST_GETAPPROVALEVENTS params:@{@"type":@"1"} success:^(NSNumber * _Nonnull code, NSString * _Nonnull msg, NSDictionary * _Nonnull data) {
//
//            } failure:^(NSNumber * _Nonnull code, NSString * _Nonnull msg) {
//
//            }];
//        });
        return [RACSignal empty];
    }];
}

@end
