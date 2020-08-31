//
//  ApplyDetailViewModel.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"
#import "MyApplyListViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ApplyDetailViewModel : OCBaseViewModel

@property (nonatomic, strong) NSString *eventNo, *Lock, *state;

@property (nonatomic, strong) NSArray *dataArr, *ApprovePersons, *approvalList, *ccList;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) NSDictionary *ApproveInfo;

@property (nonatomic, assign) ApprovalLIistType type;

@property (nonatomic, strong) RACCommand *refreshCommand, *withdrawCommand, *setStateCommand, *resubmitCommand;

@end

NS_ASSUME_NONNULL_END
