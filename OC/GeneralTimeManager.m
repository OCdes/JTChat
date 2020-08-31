//
//  GeneralTimeManager.m
//  JingTeYuHui
//
//  Created by LJ on 2019/7/22.
//  Copyright © 2019 WanCai. All rights reserved.
//

#import "GeneralTimeManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static GeneralTimeManager *_timerManager;
@implementation GeneralTimeManager

+ (instancetype)manager {
    if (!_timerManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _timerManager = [[GeneralTimeManager alloc] init];
        });
    }
    return _timerManager;
}

- (GeneralTimeModel *)getCurrentWeek {
    NSDateFormatter *ddFormate = [[NSDateFormatter alloc] init];
    ddFormate.dateFormat = @"yyyy-MM-dd";
    ddFormate.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    GeneralTimeModel *model = [GeneralTimeModel new];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [calendar setFirstWeekday:2];
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger weekDay = [currenComps weekOfYear];//获取当天周几
    NSInteger week = [currenComps weekday]-1;
    NSInteger day = [currenComps day];//获取当天几号
    long firstDiff, lastDiff;
    
    firstDiff = day == 1 ? 0 : (week == 0) ? -6 : 0;
    lastDiff = 0;
    [currenComps setDay:day+firstDiff];
    NSDate *startDate = [calendar dateFromComponents:currenComps];
    
    NSDate *yearEndDate = [ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
    model.startDate = startDate;
    model.endDate = yearEndDate;
    model.num = [NSString stringWithFormat:@"第%li周",weekDay];
    model.year = [NSString stringWithFormat:@"%li",[currenComps year]];
    return model;
}

- (GeneralTimeModel *)getCurrentMonth {
    NSDateFormatter *ddFormate = [[NSDateFormatter alloc] init];
    ddFormate.dateFormat = @"yyyy-MM-dd";
    ddFormate.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    GeneralTimeModel *model = [GeneralTimeModel new];
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    forma.dateFormat = @"yyyy";
    NSString *year = [forma stringFromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth  fromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger month = [currenComps month];//获取当天周几
    NSString *firstDate = [NSString stringWithFormat:@"%@-%li-01", year, month];
    
    model.startDate = [ddFormate dateFromString:firstDate];
    model.endDate = [ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
    model.num = [NSString stringWithFormat:@"%li月",month];
    model.year = [NSString stringWithFormat:@"%li",[currenComps year]];
    return model;
}

- (NSArray *)getWeeksOfYear:(NSDate *)year {
    NSDateFormatter *ddFormate = [[NSDateFormatter alloc] init];
    ddFormate.dateFormat = @"yyyy-MM-dd";
    ddFormate.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSMutableArray *weeksArr = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [calendar setFirstWeekday:2];//设置周一为周的第一天
    NSDate *startDate = year;
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear fromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];
    NSInteger wd = [currenComps weekOfYear];
    NSDateComponents *setComps = [calendar components:NSCalendarUnitYear fromDate:startDate];
    for (int i = 1; i < 54; i++) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.num = [NSString stringWithFormat:@"第%i周",i];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy";
        model.year = [forma stringFromDate:year];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:model.num attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : UIColor.blackColor}];
        NSRange range = [model.num rangeOfString:[NSString stringWithFormat:@"%i",i]];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize: 18] , NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        model.asContent = mAstr;
        NSDateComponents *comp = [calendar components:NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:startDate];
        NSInteger weekDay = [comp weekday]-1;//获取当天周几
        NSInteger day = [comp day];//获取当天几号
        long firstDiff, lastDiff;
        firstDiff = day == 1 ? 0 : (weekDay == 0) ? 0 : (1-weekDay);
        lastDiff = (weekDay == 0) ? 0 : 7-weekDay;
        [comp setDay:day+firstDiff];
        startDate = [calendar dateFromComponents:comp];
        
        NSDateComponents *endComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:startDate];
        [endComps setDay:day+lastDiff];
        NSDate *endDate = [calendar dateFromComponents:endComps];
        
        NSDate *yearEndDate = [ddFormate dateFromString:[NSString stringWithFormat:@"%@-12-31",model.year]];
        model.startDate = [calendar dateFromComponents:comp];
        model.endDate = [yearEndDate earlierDate:endDate];
        if (![yearEndDate isEqualToDate:endDate]) {
            [endComps setDay:day+lastDiff+1];
            startDate = [calendar dateFromComponents:endComps];
        }
        if (currenComps.year == setComps.year) {
            if (i == wd) {
                model.startDate = [model.startDate earlierDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];
                model.endDate = [ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                [weeksArr addObject:model];
                break;
            } else {
                [weeksArr addObject:model];
            }
        } else {
            [weeksArr addObject:model];
        }
    }
    return [NSArray arrayWithArray:weeksArr];
}

- (NSArray *)getMonthsOfYear:(NSDate *)year {
    NSDateFormatter *ddFormate = [[NSDateFormatter alloc] init];
    ddFormate.dateFormat = @"yyyy-MM-dd";
    ddFormate.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSMutableArray *months = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *startDate = year;
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger wd = [currenComps month];
    NSDateComponents *setComps = [calendar components:NSCalendarUnitYear fromDate:year];//传入年
    for (int i = 1; i < 13; i ++) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.num = [NSString stringWithFormat:@"%i月",i];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy";
        model.year = [forma stringFromDate:year];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:model.num attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : UIColor.blackColor}];
        NSRange range = [model.num rangeOfString:[NSString stringWithFormat:@"%i",i]];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18] , NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        model.asContent = mAstr;
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        double timeInterval = 0;
        
        BOOL sucess = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&timeInterval forDate:startDate];
        if (sucess) {
            endDate = [beginDate dateByAddingTimeInterval:timeInterval-1];
            model.startDate = beginDate;
            model.endDate = endDate;
            startDate = [beginDate dateByAddingTimeInterval:timeInterval];
            if (currenComps.year == setComps.year) {
                if (i == wd) {
                    model.endDate = [ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                    [months addObject:model];
                    break;
                } else {
                    [months addObject:model];
                }
            } else {
                [months addObject:model];
            }
            
        } else {
            break;
        }
        
    }
    return [NSArray arrayWithArray:months];
}

- (NSArray *)getFutureMonthsOfYear:(NSDate *)year {
    NSDateFormatter *ddFormate = [[NSDateFormatter alloc] init];
    ddFormate.dateFormat = @"yyyy-MM-dd";
    ddFormate.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSMutableArray *months = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *startDate = year;
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger wd = [currenComps month];
    NSDateComponents *setComps = [calendar components:NSCalendarUnitYear fromDate:year];//传入年
    for (int i = 1; i < 13; i ++) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.num = [NSString stringWithFormat:@"%i月",i];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy";
        model.year = [forma stringFromDate:year];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:model.num attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : UIColor.blackColor}];
        NSRange range = [model.num rangeOfString:[NSString stringWithFormat:@"%i",i]];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18] , NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        model.asContent = mAstr;
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        double timeInterval = 0;
        
        BOOL sucess = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&timeInterval forDate:startDate];
        if (sucess) {
            endDate = [beginDate dateByAddingTimeInterval:timeInterval-1];
            model.startDate = beginDate;
            model.endDate = endDate;
            startDate = [beginDate dateByAddingTimeInterval:timeInterval];
            if (currenComps.year == setComps.year) {
                if (i >= wd) {
                    if (i == wd) {
                        model.startDate = [ddFormate dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                        [months addObject:model];
                    } else {
                        [months addObject:model];
                    }
                } else {
                    startDate = year;
                }
            } else {
                [months addObject:model];
            }
            
        }
        
    }
    return [NSArray arrayWithArray:months];
}

- (NSArray *)getDaysOfYear:(NSDate *)year {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSMutableArray *days = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *startDate = year;
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger wd = [currenComps month];
    NSDateComponents *setComps = [calendar components:NSCalendarUnitYear fromDate:year];//传入年
    for (int i = 1; i < 13; i ++) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.num = [NSString stringWithFormat:@"%i月",i];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy";
        model.year = [forma stringFromDate:year];
        model.month = [NSString stringWithFormat:@"%i",i];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:model.num attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : UIColor.blackColor}];
        NSRange range = [model.num rangeOfString:[NSString stringWithFormat:@"%i",i]];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18] , NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        model.asContent = mAstr;
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        double timeInterval = 0;
        BOOL sucess = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&timeInterval forDate:startDate];
        if (sucess) {
            endDate = [beginDate dateByAddingTimeInterval:timeInterval-1];
            model.startDate = beginDate;
            model.endDate = endDate;
            startDate = [beginDate dateByAddingTimeInterval:timeInterval];
            
            if (currenComps.year == setComps.year) {//当前年
                if (i == wd) {
                    model.endDate = [formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                    model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                    [days addObject:model];
                    break;
                } else {
                    model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                    [days addObject:model];
                }
            } else {
                model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                [days addObject:model];
            }
            
        } else {
            break;
        }
        
    }
    return [NSArray arrayWithArray:days];
}

- (NSArray *)getFutureDaysOfYear:(NSDate *)year {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSMutableArray *days = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *startDate = year;
    NSDateComponents *currenComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]]];//当前年
    NSInteger wd = [currenComps month];
    NSDateComponents *setComps = [calendar components:NSCalendarUnitYear fromDate:year];//传入年
    for (int i = 1; i < 13; i ++) {
        GeneralTimeModel *model = [GeneralTimeModel new];
        model.num = [NSString stringWithFormat:@"%i月",i];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        forma.dateFormat = @"yyyy";
        model.year = [forma stringFromDate:year];
        model.month = [NSString stringWithFormat:@"%i",i];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:model.num attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12] , NSForegroundColorAttributeName : UIColor.blackColor}];
        NSRange range = [model.num rangeOfString:[NSString stringWithFormat:@"%i",i]];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18] , NSForegroundColorAttributeName : UIColor.blackColor} range:range];
        model.asContent = mAstr;
        NSDate *beginDate = nil;
        NSDate *endDate = nil;
        double timeInterval = 0;
        BOOL sucess = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&timeInterval forDate:startDate];
        if (sucess) {
            endDate = [beginDate dateByAddingTimeInterval:timeInterval-1];
            model.startDate = beginDate;
            model.endDate = endDate;
            startDate = [beginDate dateByAddingTimeInterval:timeInterval];
           
            if (currenComps.year == setComps.year) {
                 if (i >= wd) {
                    if (i == wd) {
                        model.startDate = [formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                        model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                        [days addObject:model];
                    } else {
                        model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                        [days addObject:model];
                    }
                 } else {
                     startDate = [formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"businessDate"]];
                 }
            } else {
                model.days = [NSArray arrayWithArray:[self getDatesWithStartDate:[formatter stringFromDate:model.startDate] endDate:[formatter stringFromDate:model.endDate]]];
                [days addObject:model];
            }
            
        } else {
            break;
        }
        
    }
    return [NSArray arrayWithArray:days];
}

- (NSArray *)getallDays {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateStr = [formatter stringFromDate:date];
    int dateNum = [dateStr intValue];
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = dateNum-1; i < dateNum+2; i ++) {
        NSArray *arr = [self getNormalDatesWithStartDate:[NSString stringWithFormat:@"%i-01-01",i] endDate:[NSString stringWithFormat:@"%i-12-31",i]];
        [mArr addObjectsFromArray:arr];
    }
    return [NSArray arrayWithArray:mArr];
}

- (NSArray*)getNormalDatesWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    //字符串转时间
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyy-MM-dd";
    matter.timeZone = [NSTimeZone localTimeZone];
    NSDate *start = [matter dateFromString:startDate];
    NSDate *end = [matter dateFromString:endDate];
    
    NSMutableArray *componentAarray = [NSMutableArray array];
    NSComparisonResult result = [start compare:end];
    NSDateComponents *comps;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy年MM月dd日 EEE";
    while (result != NSOrderedDescending) {
        comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitWeekday fromDate:start];
        NSString * dateStr = [formatter stringFromDate:start];
        [componentAarray addObject:dateStr];
        
        //后一天
        [comps setDay:([comps day]+1)];
        start = [calendar dateFromComponents:comps];
        
        //对比日期大小
        result = [start compare:end];
    }
    return componentAarray;
}

- (NSArray*)getDatesWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    //字符串转时间
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyy-MM-dd";
    matter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *start = [matter dateFromString:startDate];
    NSDate *end = [matter dateFromString:endDate];
    
    NSMutableArray *componentAarray = [NSMutableArray array];
    NSComparisonResult result = [start compare:end];
    NSDateComponents *comps;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.dateFormat = @"dd日";
    while (result != NSOrderedDescending) {
        comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitWeekday fromDate:start];
        NSString * dateStr = [formatter stringFromDate:start];
        NSRange range = [dateStr rangeOfString:@"日"];
        NSMutableAttributedString *mAstr = [[NSMutableAttributedString alloc] initWithString:dateStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : UIColor.blackColor}];
        [mAstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} range:range];
        [componentAarray addObject:mAstr];
        
        //后一天
        [comps setDay:([comps day]+1)];
        start = [calendar dateFromComponents:comps];
        
        //对比日期大小
        result = [start compare:end];
    }
    return componentAarray;
}

@end

@implementation GeneralTimeModel



@end
