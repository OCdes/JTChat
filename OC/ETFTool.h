//
//  ETFTool.h
//  JingTeYuHui
//
//  Created by Dj H on 2017/7/14.
//  Copyright © 2017年 Dj H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETFTool : NSObject
- (NSString*)today;
- (NSString*)get7daysago:(NSString*)day;
- (NSString*)to7daysago;
- (NSString *)daysAgo:(NSInteger)numDays currentDay:(NSString *)day;
- (NSString *)todaysAgo:(NSInteger)numDays currentDay:(NSString *)day;
- (NSString*)dateformat:(NSDate*)date format:(NSString*)format;
- (NSDate*)formatdate:(NSString*)sdate format:(NSString*)format;
NSString *msdatetostr(double time,NSString *format);

- (void)token:(NSString *)token;
- (void)login:(NSString *)user stoken:(NSString *)stoken;
- (void)exit;

- (NSString *)getDateTimeWith:(NSDate *)date;
- (NSString *)getCurrentDate;
- (NSString*)getNextMonthDate;
- (NSString*)getdayfrist;
- (NSString*)getdaylast;
- (NSString *)strdatetotime:(NSString*)value;
- (NSDate *)strtodate:(NSString*)value;
- (NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)numberOfMonthsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
- (NSInteger)numberOfYearsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

//+(NSString *)documentsPath:(NSString *)fileName;
-(void)save_Array:(NSString *)fileName Array:(NSArray*)arr;
-(NSArray *)load_Array:(NSString *)fileName;

- (NSString *)weekdayOfDayStr:(NSString *)dateStr;


@end

