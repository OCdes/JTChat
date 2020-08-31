//
//  PayWayTableView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/3/12.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface PayWayTableView : UITableView

@property (nonatomic, strong) NSArray *selecArr;

@property (nonatomic, strong) RACSubject *tapRowSubject;

@end

@interface PayWayCell : UITableViewCell

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, assign) BOOL isSelect;

@end

NS_ASSUME_NONNULL_END
