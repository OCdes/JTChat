//
//  GeneralTimeManager.h
//  JingTeYuHui
//
//  Created by LJ on 2019/7/22.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GeneralTimeModel;
NS_ASSUME_NONNULL_BEGIN

@interface GeneralTimeManager : NSObject

+ (instancetype)manager;

/**
 获取某年周数数组

 @param year 传入当年第一天日期
 @return 周数数组，包括第几周，该周开始日期和结束日期
 */
- (NSArray *)getWeeksOfYear:(NSDate *)year;

- (NSArray *)getMonthsOfYear:(NSDate *)year;

- (NSArray *)getDaysOfYear:(NSDate *)year;

- (NSArray *)getFutureMonthsOfYear:(NSDate *)year;

- (NSArray *)getFutureDaysOfYear:(NSDate *)year;

- (NSArray *)getallDays;

- (GeneralTimeModel *)getCurrentWeek;

- (GeneralTimeModel *)getCurrentMonth;

@end

@interface GeneralTimeModel : NSObject

@property (nonatomic, strong) NSString *num, *year, *month, *week, *day;

@property (nonatomic, strong) NSAttributedString *asContent;

@property (nonatomic, strong) NSDate *startDate, *endDate, *dayDate;

@property (nonatomic, strong) NSArray *days;

@end

NS_ASSUME_NONNULL_END
