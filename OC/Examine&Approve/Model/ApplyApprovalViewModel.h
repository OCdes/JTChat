//
//  ApplyApprovalViewModel.h
//  JingTeYuHui
//
//  Created by LJ on 2019/10/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"
@class RACCommand;
NS_ASSUME_NONNULL_BEGIN

@interface ApplyApprovalViewModel : OCBaseViewModel

@property (nonatomic, strong) RACCommand *refreshCommand;

@property (nonatomic, assign) NSInteger num;

@end

NS_ASSUME_NONNULL_END
