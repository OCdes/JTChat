//
//  MyApplyTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/9/18.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "OCBaseTableView.h"
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface MyApplyTableView : OCBaseTableView

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) RACSubject *tapRowSubject;

@end

@interface ApplyTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface ExpenseApplyCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface FreeTicketCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface AdvanceCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface RefundTicketCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface DiscoutDetailCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end

@interface AskOffApplyDetailCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *dict;

@end


NS_ASSUME_NONNULL_END
