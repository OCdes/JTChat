//
//  RefundAndDisconutApplyViewModel.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/25.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseViewModel.h"
#import "PurchaseApplyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundAndDisconutApplyViewModel : OCBaseViewModel

@property (nonatomic, strong) RACCommand *refreshCommand, *submitRefundTicketCommand, *submitDiscountCommand;

@property (nonatomic, strong) RACSubject *refreshSubject;

@property (nonatomic, strong) NSArray *approvalList, *ccList, *personList, *selectArr;

@property (nonatomic, strong) NSMutableArray *approvalMArr, *goodsMArr, *noteMArr;

@property (nonatomic, strong) NSString *applyReason, *applyType, *applyDate, *applyNote, *freeNum, *money, *type, *applyRoom, *discountBill, *discount, *ticketID;//type 3可退 4可打折
@property (nonatomic, strong) NSString *empID;

@end

NS_ASSUME_NONNULL_END
