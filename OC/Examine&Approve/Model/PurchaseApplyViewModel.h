//
//  PurchaseApplyViewModel.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/11.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"
@class RACCommand, RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface PurchaseApplyViewModel : OCBaseViewModel

@property (nonatomic, strong) NSArray *approvalList, *ccList, *personList, *approvalTypeList;

@property (nonatomic, strong) RACCommand *refreshCommand, *submitApprove, *submitFreeTicketCommand, *submitAdvanceCommand, *submitExpenseCommand, *submitAskoffCommand, *examineTypeCommand, *applyTypeCommand;

@property (nonatomic, strong) RACSubject *refreshSubject, *applyTypeSubject;

@property (nonatomic, strong) NSMutableArray *approvalMArr, *goodsMArr, *noteMArr;

@property (nonatomic, strong) NSString *applyReason, *applyType, *applyDate, *applyNote, *freeNum, *money, *startTime, *endTime, *hours, *askoffType, *requestType, *empID;

@end

@interface ApprovalMenModel : NSObject

@property (nonatomic, strong) NSString *name, *phone, *authority;

@end

@interface ApprovalGoodsModel : NSObject

@property (nonatomic, strong) NSString *GoodsName, *GoodsModel, *Quantity, *Unit, *Price, *RequiredDate, *Remark, *expenseFeeType, *expenseFee, *expenseTicketNum, *note;

@end


NS_ASSUME_NONNULL_END
