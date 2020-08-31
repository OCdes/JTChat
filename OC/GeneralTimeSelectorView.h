//
//  GeneralTimeSelectorView.h
//  JingTeYuHui
//
//  Created by LJ on 2019/7/22.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RACSubject;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralTimeSelectorView : UIView

@property (nonatomic, strong) RACSubject *sureSubject;

@property (nonatomic, strong) NSString *dateStr, *startTitleStr;

- (instancetype)initMonthsPickWithFrame:(CGRect)frame;

- (instancetype)initWeeksPickWithFrame:(CGRect)frame;

- (instancetype)initDaysPickWithFrame:(CGRect)frame;

- (instancetype)initDayPickWithFrame:(CGRect)frame;

- (instancetype)initInfinitDayPickWithFrame:(CGRect)frame;

- (instancetype)init3yearsWithFrame:(CGRect)frame;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
