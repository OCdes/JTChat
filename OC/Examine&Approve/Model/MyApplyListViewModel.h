//
//  MyApplyListViewModel.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"
@class RACCommand, RACSubject;
NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSInteger, ApprovalLIistType) {
    ApprovalLIistTypeApply = 1,
    ApprovalLIistTypeApproval,
    ApprovalLIistTypeCC
};

@interface MyApplyListViewModel : OCBaseViewModel

@property (nonatomic, assign) ApprovalLIistType type;

@property (nonatomic, strong) RACCommand *refreshCommand, *scrollCommand;

@property (nonatomic, strong) NSArray *dataArr, *originArr;

@property (nonatomic, strong) NSString *screenType;

@end

NS_ASSUME_NONNULL_END
